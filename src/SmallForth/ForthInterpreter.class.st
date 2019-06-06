"
I am a Forth language interpreter.

My main method is #eval: that receive a string with Forth words and execute them. 

Examples (try on Playground):

	ForthInterpreter new eval: '7 dup *'; top.
	
	ForthInterpreter new eval: '7 8 9 dup '; stack.
	
My internals includes a stack and a dictionary (See https://www.forth.com/starting-forth/0-starting-forth/).
There is a blog post series (in portuguese) starting in https://chicoary.wordpress.com/2019/05/08/smallforth-an-implementation-over-pharo-smalltalk/.

Public API and Key Messages

- eval: for interpretation.
- top for stack top return.
- stack for get a copy of the stack.
- new for create an interpreter instance.
"
Class {
	#name : #ForthInterpreter,
	#superclass : #Object,
	#instVars : [
		'stack',
		'stream',
		'acceptUppercase',
		'falseLevel',
		'nestLevel',
		'pairingStack'
	],
	#classVars : [
		'WordDictionary'
	],
	#category : #'SmallForth-Core'
}

{ #category : #example }
ForthInterpreter class >> example [
	| expr | 
	expr := ': egg-size
   dup 18 < if  ." reject "      else
   dup 21 < if  ." small "       else
   dup 24 < if  ." medium "      else
   dup 27 < if  ." large "       else
   dup 30  < if  ." extra large " else
      ."  error "
   then then then then then drop ;

	{1} dup . egg-size'.

	Transcript openIfNone.
	Transcript clear. 
	ForthInterpreter new eval: (expr format: {  
		UIManager default request: 'Egg size?'
	})
]

{ #category : #'class initialization' }
ForthInterpreter class >> initialize [ 
	WordDictionary := OrderedCollection new
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _2drop [
	stack
		pop;
		pop
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _2dup [
	stack push: stack second.
	stack push: stack second
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _2over [
	stack push: stack fourth.
	stack push: stack fourth
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _2swap [
	stack swap: 1 with: 3.
	stack swap: 2 with: 4
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> __marker [
	| marker |
	marker := self getNextWord.
	self removeWordsAfterMarker: marker
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _abortQuote [
	| abort |
	abort := stack pop ~= 0.
	abort
		ifTrue: [ stack removeAll.
			self _dotQuote.
			self signalAbort ]
		ifFalse: [ self getStringBeforeQuoteAndDiscardQuote: stream ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _backSlash [
	self skipBackSlashComment: stream
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _colon [
	self compile: stream
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _comment [
	self skipComment: stream
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _divide [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second // top) 
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _dot [
	Transcript show: stack pop; space
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _dotQuote [
	self showString: stream
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _dotS [
	Transcript 
		show: ('<{1}>' format: { stack size });
		space;
		show: (' ' join: stack reversed);
		space
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _equal [
	| top second |
	top := stack pop.
	second := stack pop.
	second = top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _greaterThan [
	| top second |
	top := stack pop.
	second := stack pop.
	second > top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _greaterThanZero [
	| top |
	top := stack pop.
	0 < top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _lessThan [
	| top second |
	top := stack pop.
	second := stack pop.
	second < top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _lessThanZero [
	| top |
	top := stack pop.
	0 > top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _minus [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second - top) 
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _mult [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second * top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _notEqual [
	| top second |
	top := stack pop.
	second := stack pop.
	second = top ifTrue: [ stack push: 0 ] ifFalse: [ stack push: -1 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _plus [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second + top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _questionMarkDup [
	stack top = 0
		ifFalse: [ stack push: stack top ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _slashMod [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second \\ top.
	stack push: second // top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _zeroEqual [
	| top |
	top := stack pop.
	0 = top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> abort [
	| abort |
	abort := stack pop ~= 0.
	abort ifFalse: [ ^ self ].
	stack removeAll.
	self signalAbort
]

{ #category : #accessing }
ForthInterpreter >> acceptUppercase [
	acceptUppercase := true
]

{ #category : #'forth-primitives' }
ForthInterpreter >> and [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second & top > 0 ifTrue: [ -1 ] ifFalse: [ 0 ])
]

{ #category : #'forth-primitives' }
ForthInterpreter >> char [
	| word |
	word := self getNextWord.
	stack push: word first charCode
]

{ #category : #'forth-primitives' }
ForthInterpreter >> checkDuplicatedMarker: word [
	| index |
	index := self indexOfWord: word.
	index = 0
		ifFalse: [ self signalMarkerDuplicateSomeWord: word ]
]

{ #category : #evaluating }
ForthInterpreter >> checkNestLevel [
	nestLevel = 0  ifFalse: [ self signalIfElseThenUnpairing  ]
]

{ #category : #evaluating }
ForthInterpreter >> checkPairingStack [
	pairingStack ifNotEmpty: [ self signalIfElseThenUnpairing ] 
]

{ #category : #compiling }
ForthInterpreter >> compile: aReadStream [
	| word car writeStream |
	writeStream := WriteStream on: String empty.
	word := self getNextWord.
	car := self discardWhiteSpacesOn: aReadStream.
	[ car = $; ]
		whileFalse: [ writeStream nextPut: car.
			car := aReadStream next ].
	WordDictionary addFirst: word -> writeStream contents
]

{ #category : #'forth-primitives' }
ForthInterpreter >> continueAfterElseOrThen [
	| word |
	word := self getNextWord. 
	[ word isEmpty or: [ self isElseOrThenAtFalseLevel: word ] ]
		whileFalse: [ self updateNestLevel: word.
			self handleSkipWord: word.
			word := self getNextWord ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> continueAfterThen [
	| word | 
	word := self getNextWord.
	[ word isNotEmpty and: [ (self isThen: word) not ] ]
		whileTrue: [ 
			(self isIf: word) ifTrue: [ self pushIfToPairingStack ].
			self updateNestLevel: word.
			self handleSkipWord: word.
			word := self getNextWord ].
	self updateNestLevel: word.
	(self isThen: word) ifTrue: [ self updatePairingStack ] 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> cr [
	Transcript show: Character cr
]

{ #category : #'forth-primitives' }
ForthInterpreter >> decrementNestLevel [
	nestLevel := nestLevel - 1
]

{ #category : #evaluating }
ForthInterpreter >> discardWhiteSpacesOn: aReadStream [ 
	| car |
	car := aReadStream next. 
	[ car isNotNil and: [self isWhiteSpace: car]] whileTrue: [
		
			car := aReadStream next 

		
	].
	^ car
]

{ #category : #'forth-primitives' }
ForthInterpreter >> drop [
	stack pop
]

{ #category : #'forth-primitives' }
ForthInterpreter >> dup [
	stack push: stack top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> else [
	self pushElseToPairingStack.
	self flag: #testing.
	"self skipUntilThenWithNestLevel: nestLevel."
	self skipUntilElseOrThenWithNestLevel: nestLevel 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> emit [
	Transcript show: (Character value: stack pop)
]

{ #category : #evaluating }
ForthInterpreter >> eval [
	| word | 
	word := self getNextWord. 
	[ word isEmpty ]
		whileFalse: [ (self isNumber: word)
				ifTrue: [ self pushNumberToStack: word ]
				ifFalse: [ self forthPerform: word ].
			word := self getNextWord ].
	self checkPairingStack
]

{ #category : #evaluating }
ForthInterpreter >> eval: aForthExpression [
	self 
		stream: (ReadStream on: aForthExpression);
		stack: ForthStack new;	"New stack"
		eval
]

{ #category : #evaluating }
ForthInterpreter >> evalWord: word [
	^ [ 
		ForthInterpreter new
			stream: (ReadStream on: (self lastVersionAtWord: word));
			stack: self stack; "Same stack"
			eval 
		]
		on: KeyNotFound
		do: [ (ForthMissingWord messageText: ('Missing word: {1}' format: {word}))
				signal ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> false [
	stack push: 0
]

{ #category : #'forth-primitives' }
ForthInterpreter >> forget [
	| word |
	word := self getNextWord.
	self forgetWord: word
]

{ #category : #'forth-primitives' }
ForthInterpreter >> forgetWord: word [
	self removeLastVersionOfWord: word
]

{ #category : #evaluating }
ForthInterpreter >> forthPerform: word [
	| syn lowercase |
	lowercase := self maybeInLowercase: word.
	(self
		forthRespondsTo: (syn := (self synonymousOf: lowercase) asSymbol))
		ifTrue: [ self perform: syn ]
		ifFalse: [ self evalWord: lowercase ]
]

{ #category : #testing }
ForthInterpreter >> forthRespondsTo: word [
	^ self isPrimitive: word 
	
]

{ #category : #evaluating }
ForthInterpreter >> getNextWord [
	| car writeStream word |
	writeStream := WriteStream on: String empty.
	car := self discardWhiteSpacesOn: stream.
	[ car isNotNil and: [ (self isWhiteSpace: car) not ] ]
		whileTrue: [ writeStream nextPut: car.
			car := stream next ].
	word := writeStream contents.
	"self haltIf: [#(if else then) includes: word]. "
	self flag: #debugging.
	^ word
]

{ #category : #evaluating }
ForthInterpreter >> getStringBeforeQuoteAndDiscardQuote: aReadStream [ 
	| car writeStream |
	writeStream := WriteStream on: String empty.
	car := aReadStream next.
	[ car isNotNil and: [ self isNotQuote: car ] ]  whileTrue: [ 
	
		writeStream nextPut: car.
	
	car := aReadStream next ].
   ^ writeStream  contents
]

{ #category : #'forth-primitives' }
ForthInterpreter >> handleSkipWord: word [
	(self isDotQuote: word)
		ifTrue: [ self skipDotQuoteString ].
	(self isComment: word)
		ifTrue: [ self skipCommentString ].
	(self isLineComment: word)
		ifTrue: [ self skipLineCommentString ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> if [
	self incrementNestLevel.
	self pushIfToPairingStack.
	stack pop ~= 0 ifTrue: [ ^ self ].
	falseLevel := nestLevel.
	self skipUntilElseOrThenWithNestLevel: nestLevel
]

{ #category : #'forth-primitives' }
ForthInterpreter >> incrementNestLevel [
	nestLevel := nestLevel + 1
]

{ #category : #'forth-primitives' }
ForthInterpreter >> indexOfWord: word [ 
	| index |
	index := 0.
	WordDictionary detect: [ :assoc | index := index + 1. assoc key = word ]
	ifNone: [ index := 0 ].

	^ index
]

{ #category : #initialization }
ForthInterpreter >> initialize [
	acceptUppercase := false.
	nestLevel := 0.
	pairingStack := Stack new
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> invert [
	| top |
	top := stack pop.
	stack push: (top = 0 ifTrue: [ -1 ] ifFalse: [ 0 ])
]

{ #category : #testing }
ForthInterpreter >> isComment: word [
	^ word = '('
]

{ #category : #testing }
ForthInterpreter >> isDotQuote: word [ 
	^ word = '."'
]

{ #category : #testing }
ForthInterpreter >> isDotQuoteWord: word [ 
	^ word = '."'
]

{ #category : #evaluating }
ForthInterpreter >> isEligibleForLoweringCase: word [
	^ word
		allSatisfy: [ :car | 
			car isUppercase
				or: [ car isSpecial
						or: [ car isOtherPunctuation or: [ car isConnectorPunctuation ] ] ] ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> isElse: word [
	^ word = 'else'
]

{ #category : #'forth-primitives' }
ForthInterpreter >> isElseOrThen: word [
	| bool |
	bool := #(else then) includes: word.
	(self isThen: word) ifTrue: [ self updatePairingStack ].
	^ bool
]

{ #category : #'forth-primitives' }
ForthInterpreter >> isElseOrThenAtFalseLevel: word [
	| bool |
	(self isIf: word)
		ifTrue: [ self pushIfToPairingStack ].
	(self isElse: word)
		ifTrue: [ self pushElseToPairingStack ].
	bool := (self isElseOrThen: word)
		and: [ self isFalseLevelMatchesNestLevel ].
	self updateNestLevel: word.
	^ bool
]

{ #category : #testing }
ForthInterpreter >> isFalseLevelMatchesNestLevel [
	^ falseLevel = nestLevel
]

{ #category : #testing }
ForthInterpreter >> isIf: word [ 
	^ word = 'if'
]

{ #category : #testing }
ForthInterpreter >> isLineComment: word [ 
	^ word = '\'
]

{ #category : #testing }
ForthInterpreter >> isNotCr: aCharacter [ 
	^ aCharacter ~= Character cr
]

{ #category : #testing }
ForthInterpreter >> isNotQuote: aCharacter [ 
	^ aCharacter ~= $"
]

{ #category : #testing }
ForthInterpreter >> isNotRightParenthesis: aCharacter [ 
	^ aCharacter ~= $)
]

{ #category : #testing }
ForthInterpreter >> isNumber: word [
	(self isSignal: word first)
		ifTrue: [ ^ word allButFirst isAllDigits ]
		ifFalse: [ ^ word isAllDigits ]
]

{ #category : #testing }
ForthInterpreter >> isPrimitive: word [
	^ self primitiveWords includes: word
]

{ #category : #testing }
ForthInterpreter >> isSignal: aCharacter [ 
	^ aCharacter = $-
]

{ #category : #'forth-primitives' }
ForthInterpreter >> isThen: word [
	| bool |
	bool := word = 'then'.
	^ bool
]

{ #category : #'forth-primitives' }
ForthInterpreter >> isThenAtFalseLevel: word [
	
   | bool |
	(self isIf: word)
		ifTrue: [ self pushIfToPairingStack ].
	(self isElse: word)
		ifTrue: [ self pushElseToPairingStack ].
	bool := self isThen: word.
	self updateNestLevel: word.
	^ bool
]

{ #category : #testing }
ForthInterpreter >> isWhiteSpace: aCharacter [ 
	^ { Character space. Character tab. Character cr. Character lf } includes: aCharacter
]

{ #category : #evaluating }
ForthInterpreter >> lastVersionAtWord: word [
	| lastVersion index |
	index := self indexOfWord: word.
	index = 0
		ifTrue: [ self signalMissingWord: word ].
	lastVersion := (WordDictionary at: index) value.
	^ lastVersion
]

{ #category : #'forth-primitives' }
ForthInterpreter >> marker [
	| marker |
	marker := self getNextWord.
	self markerWord: marker
]

{ #category : #'forth-primitives' }
ForthInterpreter >> markerWord: marker [
	self checkDuplicatedMarker: marker.
	WordDictionary addFirst: marker -> ('__marker {1}' format: {marker})
]

{ #category : #evaluating }
ForthInterpreter >> maybeInLowercase: word [
	^ (self isEligibleForLoweringCase: word)
		ifTrue: [ word asLowercase ]
		ifFalse: [ word ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> mod [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second \\ top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> or [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second | top > 0 ifTrue: [ -1 ] ifFalse: [ 0 ])
]

{ #category : #'forth-primitives' }
ForthInterpreter >> over [
	"| top second |
	top := stack pop.
	second := stack pop.
	stack push: second.
	stack push: top.
	stack push: second.
	"
	
	stack push: (stack second)
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> primitiveWords [
	
	^ #(
	_2drop _2dup _2over _2swap __marker _abortQuote _backSlash _colon _comment _divide _dot _dotQuote _dotS _equal 
	_greaterThan _greaterThanZero _lessThan _lessThanZero _minus _mult _notEqual _plus _questionMarkDup _slashMod 
	_zeroEqual 
	
	abort and char cr drop dup else emit #false forget if invert marker mod or over rot space spaces swap then #true)
	

]

{ #category : #'forth-primitives' }
ForthInterpreter >> pushElseToPairingStack [
	pairingStack push: #else
]

{ #category : #'forth-primitives' }
ForthInterpreter >> pushIfToPairingStack [
	pairingStack push: #if
]

{ #category : #evaluating }
ForthInterpreter >> pushNumberToStack: word [
	stack push: word asNumber
]

{ #category : #removing }
ForthInterpreter >> removeElseAndIfFromPairingStack [
	pairingStack top = #else
		ifTrue: [ pairingStack pop ].
	pairingStack pop = #if
		ifFalse: [ self signalIfElseThenUnpairing ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> removeLastVersionOfWord: word [
	| index |
	index := self indexOfWord: word.
	index = 0
		ifTrue: [ self signalMissingWord: word ].
	WordDictionary removeAt: index
]

{ #category : #'forth-primitives' }
ForthInterpreter >> removeWordsAfterMarker: marker [ 

	[ WordDictionary first key = marker ] whileFalse: [  
	
		WordDictionary removeFirst
	
	].
	WordDictionary removeFirst
	
	
	
]

{ #category : #initialization }
ForthInterpreter >> resetDictionary [
	WordDictionary removeAll 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> rot [
	"| top second third |
	top := stack pop.
	second := stack pop.
	third := stack pop.
	stack push: third.
	stack push: top.
	stack push: second.
	"
	
	stack 
		swap: 3 with: 2;
		swap: 2 with: 1
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> showString: aReadStream [
	| string |
	string := self getStringBeforeQuoteAndDiscardQuote: aReadStream.
	Transcript show: string
]

{ #category : #signalling }
ForthInterpreter >> signalAbort [
	ForthAbort new signal
]

{ #category : #signalling }
ForthInterpreter >> signalIfElseThenUnpairing [
	ForthUnpairingIfElseThen new signal
]

{ #category : #'forth-primitives' }
ForthInterpreter >> signalMarkerDuplicateSomeWord: word [ 
	(ForthMarkerDuplicatedWord marker: word) signal
]

{ #category : #'forth-primitives' }
ForthInterpreter >> signalMissingWord: word [ 
	(ForthMissingWord messageText: word) signal
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipBackSlashComment: aReadStream [ 
	self skipStringBeforeCrAndDiscardCr: aReadStream
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipComment: aReadStream [
	self skipStringBeforeRightParenthesisAndDiscardRightParenthesis: aReadStream
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipCommentString [
	self skipStringUntilChar: $)
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipDotQuoteString [
	self skipStringUntilChar: $"
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipLineCommentString [
	self skipStringUntilChar: Character cr
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipStringBeforeCrAndDiscardCr: aReadStream [ 
	| car |
	car := aReadStream next.
	[ car isNotNil and: [ self isNotCr: car ] ]
		whileTrue: [ car := aReadStream next ]
]

{ #category : #evaluating }
ForthInterpreter >> skipStringBeforeRightParenthesisAndDiscardRightParenthesis: aReadStream [
	| car |
	car := aReadStream next.
	[ car isNotNil and: [ self isNotRightParenthesis: car ] ]
		whileTrue: [ car := aReadStream next ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipStringUntilChar: char [
	| car |
	car := stream next.
	[ car isNotNil and: [ car ~= char ] ]
		whileTrue: [ car := stream next ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipUntilElseOrThenWithNestLevel: aTargetNestLevel [ 
		| word |
		self flag: #testing.
		word := self getNextWord. 
		word ifEmpty: [ ^ nil ].
		word = 'if' ifTrue: [ self pushIfToPairingStack. self incrementNestLevel ].
		word = 'else' ifTrue: [ self pushElseToPairingStack. nestLevel = aTargetNestLevel ifTrue: [ ^ nil ] ].
		word = 'then' ifTrue: [ 
			self removeElseAndIfFromPairingStack. 
			nestLevel = aTargetNestLevel ifTrue: [ ^ nil ]. 
			self decrementNestLevel ].
		self skipUntilElseOrThenWithNestLevel: aTargetNestLevel
]

{ #category : #'forth-primitives' }
ForthInterpreter >> skipUntilThenWithNestLevel: aTargetNestLevel [ 
	| word |
	self flag: #maybeDelete.
	word := self getNextWord. 
	word ifEmpty: [ ^ nil ].
	word = 'if' ifTrue: [ self pushIfToPairingStack. self incrementNestLevel ].
	word = 'else' ifTrue: [ self pushElseToPairingStack. nestLevel = aTargetNestLevel ifTrue: [ ^ nil ] ].
	word = 'then' ifTrue: [ 
			self removeElseAndIfFromPairingStack. 
			nestLevel = aTargetNestLevel ifTrue: [ ^ nil ]. 
			self decrementNestLevel ].
	self skipUntilThenWithNestLevel: aTargetNestLevel	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> space [
	Transcript show: Character space
]

{ #category : #'forth-primitives' }
ForthInterpreter >> spaces [
	| times |
	times := stack pop.
	times timesRepeat: [ self space ]
]

{ #category : #'private ' }
ForthInterpreter >> stack [
	^ stack
]

{ #category : #accessing }
ForthInterpreter >> stack: aCollection [ 
	stack := aCollection
]

{ #category : #accessing }
ForthInterpreter >> stackCopy [
	^ stack copy
]

{ #category : #accessing }
ForthInterpreter >> stream: aStream [
	stream := aStream

]

{ #category : #'forth-primitives' }
ForthInterpreter >> swap [
	"| top second |
	top := stack pop.
	second := stack pop.
	stack push: second.
	stack push: top.
	stack push: second.
	"
	
	stack swap: 1 with: 2
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> synonymousOf: word [ 
	^ self synonyms at: word ifAbsent: [ word ]
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> synonyms [
	^ {  
	
		'/mod' -> '_slashMod'.
		'.s' -> '_dotS'.
		'.' -> '_dot'.
		'*' -> '_mult'.
		'+' -> '_plus'.
		'-' -> '_minus'.
		'/' -> '_divide'.
		'2swap' -> '_2swap'.
		'2dup' -> '_2dup'.
		'2over' -> '_2over'.
		'2drop' -> '_2drop'.
		'."' -> '_dotQuote'.
		':' -> '_colon'.
		'(' -> '_comment'.
		'\' -> '_backSlash'.
		'=' -> '_equal'.
		'<>' -> '_notEqual'.
		'<' -> '_lessThan'.
		'>' -> '_greaterThan'.
		'0=' -> '_zeroEqual'.
		'0<' -> '_lessThanZero'.
		'0>' -> '_greaterThanZero'.
		'?dup' -> '_questionMarkDup'.
		'abort"' -> '_abortQuote'.
	
	} asDictionary 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> then [
	self updatePairingStack.
	nestLevel := nestLevel - 1
]

{ #category : #accessing }
ForthInterpreter >> top [
	^ stack top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> true [
	stack push: -1
]

{ #category : #'forth-primitives' }
ForthInterpreter >> updateNestLevel: word [
	(self isIf: word)
		ifTrue: [ nestLevel := nestLevel + 1 ].
	(self isThen: word)
		ifTrue: [ nestLevel := nestLevel - 1 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> updatePairingStack [
	pairingStack top = #else
		ifTrue: [ pairingStack pop ].
	pairingStack pop = #if
		ifFalse: [ self signalIfElseThenUnpairing ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> updatePairingStackForElse [
	pairingStack push: #else
]
