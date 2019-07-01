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
		'nestLevel',
		'returnStack',
		'maxLoopCount',
		'variables',
		'pairingLoopStack',
		'loopLevel',
		'positionStack',
		'loopCountStack'
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

{ #category : #'forth-synonyms' }
ForthInterpreter >> _2drop [
	stack
		pop;
		pop
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _2dup [
	stack push: stack second.
	stack push: stack second
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _2over [
	stack push: stack fourth.
	stack push: stack fourth
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _2swap [
	stack swap: 1 with: 3.
	stack swap: 2 with: 4
	
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> __marker [
	| marker |
	marker := self getNextWord.
	self removeWordsAfterMarker: marker
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _abortQuote [
	| abort |
	abort := stack pop ~= 0.
	abort
		ifTrue: [ self emptyStack.
			self _dotQuote.
			self signalAbort ]
		ifFalse: [ self getStringBeforeQuoteAndDiscardQuote: stream ]
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _addsOne [
	stack push: stack pop + 1
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _addsTwo [
	stack push: stack pop + 2
]

{ #category : #'variable-support' }
ForthInterpreter >> _at [
	
	| variableAddress variableValue |
	
	variableAddress := stack pop.
	
	variableValue := (variables detect: [ :assoc | assoc key == variableAddress ]) value.
	
	stack push: variableValue 
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _backSlash [
	self skipBackSlashComment: stream
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _colon [
	self addWordToDictionaryWithStream: stream
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _comment [
	self skipComment: stream
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _divides [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second // top) 
	
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _dividesByTwo [
	stack push: stack pop >> 1
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _dot [
	Transcript show: stack pop; space
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _dotQuote [
	self showString: stream
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _dotS [
	Transcript 
		show: ('<{1}>' format: { stack size });
		space;
		show: (' ' join: stack reversed);
		space
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _equal [
	| top second |
	top := stack pop.
	second := stack pop.
	second = top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'variable-support' }
ForthInterpreter >> _exclamationMark [

	| variableAddress variableValue |

	variableAddress := stack pop.
	variableValue := stack pop.
	
	(variables detect: [ :assoc | assoc key == variableAddress ]) value: variableValue
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _greaterThan [
	| top second |
	top := stack pop.
	second := stack pop.
	second > top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _greaterThanR [
	returnStack push: stack pop 
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _greaterThanZero [
	| top |
	top := stack pop.
	0 < top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> _iSingleQuotationMark [
	
	| index |
	
	index := returnStack second.
	stack push: index
	
	
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _lessThan [
	| top second |
	top := stack pop.
	second := stack pop.
	second < top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _lessThanZero [
	| top |
	top := stack pop.
	0 > top ifTrue: [ stack push: -1 ] ifFalse: [ stack push: 0 ]
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _minus [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second - top) 
	
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _mult [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second * top
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _multipliesByTwo [
	stack push: stack pop << 1
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _notEqual [
	| top second |
	top := stack pop.
	second := stack pop.
	second = top ifTrue: [ stack push: 0 ] ifFalse: [ stack push: -1 ]
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _plus [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second + top
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _plusLoop [
	| increment |
	increment := stack pop.
	self loopWithIncrement: increment
]

{ #category : #'variable-support' }
ForthInterpreter >> _pushAddressOfVariable [
	
	| variableName variableAddress |
	
	variableName := self getNextWord.
	variableAddress := self addressOfVariableNamed: variableName.
	
	stack push: variableAddress
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _questionMarkDup [
	stack top = 0
		ifFalse: [ stack push: stack top ]
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _rAt [
	stack push: returnStack top
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _rGreaterThan [
	stack push: returnStack pop
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _slashMod [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second \\ top.
	stack push: second // top
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _starSlash [
	| third second top |
	top := stack pop.
	second := stack pop.
	third := stack pop.
	stack push: third * second // top
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _starSlashMod [
	| third second top times |
	top := stack pop.
	second := stack pop.
	third := stack pop.
	times := third * second.
	stack push: times \\ top.
	stack push: times // top
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _subtractsOne [
	stack push: stack pop - 1
]

{ #category : #'forth-synonyms' }
ForthInterpreter >> _subtractsTwo [
	stack push: stack pop - 2
]

{ #category : #'forth-synonyms' }
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
	self emptyStack.
	self signalAbort
]

{ #category : #'forth-primitives' }
ForthInterpreter >> abs [
	stack push: stack pop abs
]

{ #category : #accessing }
ForthInterpreter >> acceptUppercase [
	acceptUppercase := true
]

{ #category : #'dictionary-support' }
ForthInterpreter >> addWord: word ToDictionaryWithStream: aReadStream [
	| car writeStream |
	writeStream := WriteStream on: String empty.
	car := self discardWhiteSpacesOn: aReadStream.
	[ car = $; ]
		whileFalse: [ writeStream nextPut: car.
			car := aReadStream next ].
	WordDictionary addFirst: word -> writeStream contents
]

{ #category : #'dictionary-support' }
ForthInterpreter >> addWordToDictionaryWithStream: aReadStream [
	| word |
	word := self getNextWord.
	self addWord: word ToDictionaryWithStream: aReadStream
]

{ #category : #'variable-support' }
ForthInterpreter >> addressOfVariableNamed: variableName [
	^ variableName asSymbol hash
]

{ #category : #'forth-primitives' }
ForthInterpreter >> again [
	| loopCount position |
	
	position := positionStack pop.
	
	maxLoopCount > 0
		ifTrue: [ loopCount := loopCountStack pop.
			loopCount := loopCount + 1.
			loopCount >= maxLoopCount ifTrue: [ self signalMaxLoopCountHasBeenReached ].
			loopCountStack  push: loopCount ].
		
	stream position: position.	"again"
		
	positionStack push: position
]

{ #category : #'forth-primitives' }
ForthInterpreter >> and [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: (second & top > 0 ifTrue: [ -1 ] ifFalse: [ 0 ])
]

{ #category : #'forth-primitives' }
ForthInterpreter >> begin [
	| position loopCount |
	
	loopLevel := loopLevel + 1.
	
	maxLoopCount > 0 ifTrue: [ loopCount := 0. loopCountStack push: loopCount ].
	
	position := stream position.
	
	positionStack push: position.
	
	
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> char [
	| word |
	word := self getNextWord.
	stack push: word first charCode
]

{ #category : #'marker-support' }
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
ForthInterpreter >> checkPairingLoopStackIsEmpty [
	pairingLoopStack ifNotEmpty: [ self signalIfElseThenUnpairing ] 
]

{ #category : #'if-else-then-support' }
ForthInterpreter >> checkPreviousIf [
	pairingLoopStack top = #if ifFalse: [ self signalIfElseThenUnpairing ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> cr [
	Transcript show: Character cr
]

{ #category : #'variable-support' }
ForthInterpreter >> createEntryOfVariableNamed: aVariableName [
	| variableAddress |
	
	variableAddress := self addressOfVariableNamed: aVariableName.
	variables addFirst: variableAddress -> 0	"zero"
]

{ #category : #'variable-support' }
ForthInterpreter >> createVariableNamed: aVariableName [ 
	| variableEntryString |
	
	self createEntryOfVariableNamed: aVariableName.
	
	variableEntryString := '_pushAddressOfVariable {1}' format: { aVariableName }.
	WordDictionary addFirst: aVariableName -> variableEntryString
]

{ #category : #'if-else-then-support' }
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
ForthInterpreter >> do [
	| index limit position loopCount |
	
	self flag: #testing. self haltIf: [ false ].
	
	maxLoopCount > 0 ifTrue: [ 
		loopCount := 0. 
		loopCountStack push: loopCount ].
	
	index := stack pop.
	limit := stack pop.
	
	position := stream position.
	
	self flag: #implementing. "position em stack separado"
	"returnStack push: position."
	positionStack push: position.
	
	returnStack push: limit.
	returnStack push: index.
	
	self flag: #testing. self haltIf: [ false ].
	
	
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
	(pairingLoopStack isEmpty or: [pairingLoopStack top ~= #if]) ifTrue: [ self signalIfElseThenUnpairing ].
	self pushElseToPairingStack.
	self skipUntilElseOrThenWithFalseLevel: nestLevel 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> emit [
	Transcript show: (Character value: stack pop)
]

{ #category : #evaluating }
ForthInterpreter >> emptyStack [
	stack removeAll
]

{ #category : #evaluating }
ForthInterpreter >> eval [
	| word | 
	word := self getNextWord. 
	[ word isEmpty ]
		whileFalse: [ 
			(self isNumber: word)
				ifTrue: [ self pushNumberToStack: word ]
				ifFalse: [ self forthPerform: word ].
			word := self getNextWord ].
	self checkPairingLoopStackIsEmpty
]

{ #category : #evaluating }
ForthInterpreter >> eval: aForthExpression [
	self 
		stream: (ReadStream on: aForthExpression); "New stream"
		stack: ForthStack new;	"New stack"
		variables: OrderedCollection new; "New collection"
		eval
]

{ #category : #evaluating }
ForthInterpreter >> evalWord: word [

	^ [ 
		ForthInterpreter new
			stream: (ReadStream on: (self lastVersionAtWord: word));
			stack: "self" stack; "Same stack"
			variables: variables; "Same variables"
			eval;
			removeLocalVariables. 
		]
		on: KeyNotFound
		do: [ (ForthMissingWord messageText: ('Missing word: {1}' format: {word}))
				signal ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> false [
	stack push: 0
]

{ #category : #evaluating }
ForthInterpreter >> forceToLowercase: word [
	^ (self isEligibleForLoweringCase: word)
		ifTrue: [ word asLowercase ]
		ifFalse: [ word ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> forget [
	| word |
	word := self getNextWord.
	self forgetWord: word
]

{ #category : #'forget-support' }
ForthInterpreter >> forgetWord: word [
	self removeLastVersionOfWord: word
]

{ #category : #evaluating }
ForthInterpreter >> forthPerform: word [
	| syn lowercase |
	lowercase := self forceToLowercase: word.
	(self
		isPrimitive: (syn := (self synonymousOf: lowercase) asSymbol))
			ifTrue: [ self perform: syn ]
			ifFalse: [ self evalWord: lowercase ]
]

{ #category : #evaluating }
ForthInterpreter >> getNextWord [
	| car writeStream word |
	"self halt."
	writeStream := WriteStream on: String empty.
	car := self discardWhiteSpacesOn: stream.
	[ car isNotNil and: [ (self isWhiteSpace: car) not ] ]
		whileTrue: [ writeStream nextPut: car.
			car := stream next ].
	word := writeStream contents.
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

{ #category : #'variable-support' }
ForthInterpreter >> getValueOfVariableNamed: aVariableName [
	| variableAddress variableValue |

	variableAddress := self addressOfVariableNamed: aVariableName.
	variableValue := (variables
		detect: [ :assoc | assoc key == variableAddress ]) value.
	^ variableValue
]

{ #category : #'variable-support' }
ForthInterpreter >> getValueOnVariableAddress: variableAddress [ 
	^ (variables
		detect: [ :assoc | assoc key == variableAddress ]) value
]

{ #category : #'variable-support' }
ForthInterpreter >> getValueOnVariableAddress: variableAddress onVariableCollection: aVariableCollection [
	^ (aVariableCollection
		detect: [ :assoc | assoc key == variableAddress ]) value
]

{ #category : #'forth-primitives' }
ForthInterpreter >> i [
	| index |	
		
	self flag: #testing. self haltIf: [ false ].
	
	index := returnStack top.
	stack push: index.
	
	self flag: #testing. self haltIf: [ false ].
	
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> if [
	self incrementNestLevel.
	self pushIfToPairingStack.
	stack pop = -1 "True" ifTrue: [ ^ self ].
	self skipUntilElseOrThenWithFalseLevel: nestLevel
	
]

{ #category : #'if-else-then-support' }
ForthInterpreter >> incrementNestLevel [
	nestLevel := nestLevel + 1
]

{ #category : #'dictionary-support' }
ForthInterpreter >> indexOfWord: word [ 
	| index |
	index := 0.
	WordDictionary detect: [ :assoc | index := index + 1. (self forceToLowercase: assoc key) = word ]
	ifNone: [ index := 0 ].

	^ index
]

{ #category : #initialization }
ForthInterpreter >> initialize [
	acceptUppercase := false.
	nestLevel := 0.
	maxLoopCount := 0.
	
	loopLevel := 0.
	
	pairingLoopStack := Stack new.
	returnStack := Stack new.
	positionStack := Stack new.
	loopCountStack := Stack new.
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
		allSatisfy: [ :car | car isDigit or: [
			car isUppercase
				or: [ car isSpecial
						or: [ car isOtherPunctuation or: [ car isConnectorPunctuation ] ] ] ]]
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

{ #category : #testing }
ForthInterpreter >> isWhiteSpace: aCharacter [ 
	^ { Character space. Character tab. Character cr. Character lf } includes: aCharacter
]

{ #category : #'forth-primitives' }
ForthInterpreter >> j [
	
	| index |
	
	index := returnStack third.
	stack push: index
	
	
]

{ #category : #'dictionary-support' }
ForthInterpreter >> lastVersionAtWord: word [
	| lastVersion index |
	index := self indexOfWord: word.
	index = 0
		ifTrue: [ 
			self emptyStack. 
			self signalMissingWord: word ].
	lastVersion := (WordDictionary at: index) value.
	^ lastVersion
]

{ #category : #'forth-primitives' }
ForthInterpreter >> leave [
	self skipUntilEndOfLoop 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> loop [
	self loopWithIncrement: 1
]

{ #category : #'loop-support' }
ForthInterpreter >> loopWithIncrement: increment [
	| limit index position sign loopCount |
	
	self flag: #testing. self haltIf: [false]. 
	
	index := returnStack first. 
	limit := returnStack second. 
	
	maxLoopCount > 0
		ifTrue: [ loopCount := loopCountStack pop.
			loopCount := loopCount + 1.
			loopCount >= maxLoopCount ifTrue: [ self signalMaxLoopCountHasBeenReached ].
			loopCountStack  push: loopCount ].
	
	index := index + increment. returnStack pop; push: index.
	sign := increment sign.
	(index - limit) * sign >= 0
		ifTrue: [  
			returnStack pop; pop.
			positionStack pop. 
		] 
		ifFalse: [ 
			position := positionStack top.
			stream position: position
		].
		
		self flag: #testing. self haltIf: [false].
		
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> marker [
	| marker |
	marker := self getNextWord.
	self markerWord: marker
]

{ #category : #'dictionary-support' }
ForthInterpreter >> markerWord: marker [
	self checkDuplicatedMarker: marker.
	WordDictionary addFirst: marker -> ('__marker {1}' format: {marker})
]

{ #category : #'forth-primitives' }
ForthInterpreter >> max [
	stack push: (stack pop max: stack pop)
]

{ #category : #'loop-support' }
ForthInterpreter >> maxLoopCount: anInteger [ 
	maxLoopCount := anInteger.
]

{ #category : #'forth-primitives' }
ForthInterpreter >> min [
	stack push: (stack pop min: stack pop)
]

{ #category : #'forth-primitives' }
ForthInterpreter >> mod [
	| top second |
	top := stack pop.
	second := stack pop.
	stack push: second \\ top
]

{ #category : #'forth-primitives' }
ForthInterpreter >> negate [
	stack push: stack pop negated
]

{ #category : #'variable-support' }
ForthInterpreter >> newVariableCollection [
	^ OrderedCollection new
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
ForthInterpreter >> page [
	
	Transcript clear
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> primitiveWords [
	^ #(
	_2drop _2dup _2over _2swap __marker _abortQuote _addsOne _addsTwo _at _backSlash _colon 	_comment #_rAt _divides _dividesByTwo _dot _dotQuote _dotS _equal 	_exclamationMark 	_greaterThan _greaterThanZero _lessThan _lessThanZero _minus _mult _multipliesByTwo _notEqual 	_plus _plusLoop _pushAddressOfVariable 	#_greaterThanR #_rGreaterThan _questionMarkDup 	_slashMod _starSlash _starSlashMod _subtractsOne _subtractsTwo _zeroEqual _iSingleQuotationMark
					
	abort abs again and 	begin char cr do drop dup else emit #false forget i if invert j leave loop 	marker max min mod 	negate or over page rot space spaces swap then 	#true until variable 	while repeat		
	)
	
	
]

{ #category : #'if-else-then-support' }
ForthInterpreter >> pushElseToPairingStack [
	pairingLoopStack push: #else
]

{ #category : #'variable-support' }
ForthInterpreter >> pushFlagOnVariables: aVariableCollection [ 
	
	aVariableCollection addFirst: -1 "flag" -> nil
]

{ #category : #'if-else-then-support' }
ForthInterpreter >> pushIfToPairingStack [
	pairingLoopStack push: #if
]

{ #category : #evaluating }
ForthInterpreter >> pushNumberToStack: word [
	stack push: word asNumber
]

{ #category : #removing }
ForthInterpreter >> removeElseAndIfFromPairingStack [
	pairingLoopStack top = #else
		ifTrue: [ pairingLoopStack pop ].
	pairingLoopStack pop = #if
		ifFalse: [ self signalIfElseThenUnpairing ]
]

{ #category : #'dictionary-support' }
ForthInterpreter >> removeLastVersionOfWord: word [
	| index |
	index := self indexOfWord: word.
	index = 0
		ifTrue: [ self signalMissingWord: word ].
	WordDictionary removeAt: index
]

{ #category : #'variable-support' }
ForthInterpreter >> removeLocalVariables [
	
	variables first key = -1 "flag" ifTrue: [ variables removeFirst. ^ self ].
	variables removeFirst.
	self removeLocalVariables
]

{ #category : #'dictionary-support' }
ForthInterpreter >> removeWordsAfterMarker: marker [ 

	[ WordDictionary first key = marker ] whileFalse: [  
	
		WordDictionary removeFirst
	
	].
	WordDictionary removeFirst
	
	
	
]

{ #category : #'forth-primitives' }
ForthInterpreter >> repeat [
	| position |
	
	position := positionStack top.
	
	stream position: position
]

{ #category : #'dictionary-support' }
ForthInterpreter >> resetDictionary [
	WordDictionary removeAll 
]

{ #category : #accessing }
ForthInterpreter >> returnStackCopy [
	^ returnStack copy
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

{ #category : #'forth-primitive-support' }
ForthInterpreter >> showString: aReadStream [
	| string |
	string := self getStringBeforeQuoteAndDiscardQuote: aReadStream.
	Transcript show: string
]

{ #category : #'error signalling' }
ForthInterpreter >> signalAbort [
	ForthAbort new signal
]

{ #category : #'error signalling' }
ForthInterpreter >> signalIfElseThenUnpairing [
	ForthUnpairingIfElseThen new signal
]

{ #category : #'error signalling' }
ForthInterpreter >> signalMarkerDuplicateSomeWord: word [ 
	(ForthMarkerDuplicatedWord marker: word) signal
]

{ #category : #'forth-primitives' }
ForthInterpreter >> signalMaxLoopCountHasBeenReached [
	ForthMaxLoopCountHasBeenReached new signal
]

{ #category : #'error signalling' }
ForthInterpreter >> signalMissingWord: word [ 
	(ForthMissingWord messageText: word) signal
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipBackSlashComment: aReadStream [ 
	self skipStringBeforeCrAndDiscardCr: aReadStream
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipComment: aReadStream [
	self skipStringBeforeRightParenthesisAndDiscardRightParenthesis: aReadStream
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipDotQuoteString [
	self skipStringUntilChar: $"
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipLineCommentString [
	self skipStringUntilChar: Character cr
]

{ #category : #'forth-primitive-support' }
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

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipStringUntilChar: char [
	| car |
	car := stream next.
	[ car isNotNil and: [ car ~= char ] ]
		whileTrue: [ car := stream next ]
]

{ #category : #'loop-support' }
ForthInterpreter >> skipToAfterRepeat: aTargetLoopLevel [
	
	| word |
		
	word := self getNextWord.
	word ifEmpty: [ ^ self ].
	word asLowercase = 'begin'
		ifTrue: [ loopLevel := loopLevel + 1 ].
	word asLowercase = 'repeat'
		ifTrue: [ | isTargetLevel |
			isTargetLevel := loopLevel = aTargetLoopLevel.
			loopLevel := loopLevel - 1.
			isTargetLevel ifTrue: [ 
				positionStack pop.
				^ self ] ].
	self skipToAfterRepeat: aTargetLoopLevel
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipUntilElseOrThenWithFalseLevel: aFalseNestLevel [ 
		| word |
		word := self getNextWord asLowercase. 
		word ifEmpty: [ ^ self ].
		word = 'if' ifTrue: [ self pushIfToPairingStack. self incrementNestLevel ].
		word = 'else' ifTrue: [ self checkPreviousIf. self pushElseToPairingStack. nestLevel = aFalseNestLevel ifTrue: [ ^ self ] ].
		word = 'then' ifTrue: [ 
			self removeElseAndIfFromPairingStack. 
			nestLevel = aFalseNestLevel ifTrue: [ ^ self ]. 
			self decrementNestLevel ].
		self skipUntilElseOrThenWithFalseLevel: aFalseNestLevel
]

{ #category : #'loop-support' }
ForthInterpreter >> skipUntilEndOfLoop [
	| word |

	word := self getNextWord. 
	word ifEmpty: [ ^ self ].
	(#(loop again '+loop') includes: word asLowercase) ifTrue: [ ^ self ]. 
	self skipUntilEndOfLoop
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> skipUntilThenWithNestLevel: aTargetNestLevel [ 
	| word |
	word := self getNextWord asLowercase. 
	word ifEmpty: [ ^ nil ].
	word = 'if' ifTrue: [ self pushIfToPairingStack. self incrementNestLevel ].
	word = 'else' ifTrue: [ self pushElseToPairingStack. nestLevel = aTargetNestLevel ifTrue: [ ^ nil ] ].
	word = 'then' ifTrue: [ 
			self removeElseAndIfFromPairingStack. 
			nestLevel = aTargetNestLevel ifTrue: [ ^ self ]. 
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

{ #category : #'forth-primitive-support' }
ForthInterpreter >> synonymousOf: word [ 
	^ self synonyms at: word ifAbsent: [ word ]
	
]

{ #category : #'forth-primitive-support' }
ForthInterpreter >> synonyms [
	^ {  
		'/mod' -> '_slashMod'.					'.s' -> '_dotS'.
		'.' -> '_dot'.								'*' -> '_mult'.
		'+' -> '_plus'.								'-' -> '_minus'.
		'/' -> '_divides'.							'2swap' -> '_2swap'.
		'2dup' -> '_2dup'.							'2over' -> '_2over'.
		'2drop' -> '_2drop'.						'."' -> '_dotQuote'.
		':' -> '_colon'.							'(' -> '_comment'.
		'\' -> '_backSlash'.						'=' -> '_equal'.
		'<>' -> '_notEqual'.						'<' -> '_lessThan'.
		'>' -> '_greaterThan'.					'0=' -> '_zeroEqual'.
		'0<' -> '_lessThanZero'.					'0>' -> '_greaterThanZero'.
		'?dup' -> '_questionMarkDup'.			'abort"' -> '_abortQuote'.
		'1+' -> '_addsOne'.						'2+' -> '_addsTwo'.
		'1-' -> '_subtractsOne'.					'2-' -> '_subtractsTwo'.
		'2*' -> '_multipliesByTwo'.				'2/' -> '_dividesByTwo'.
		'r>' -> '_rGreaterThan'.					'>r' -> '_greaterThanR'.
		'r@' -> '_rAt'.								'*/' -> '_starSlash'.
		'*/mod' -> '_starSlashMod'.				'+loop' -> '_plusLoop'.
		'!' -> '_exclamationMark'.				'@' -> '_at'.
		'i''' -> '_iSingleQuotationMark'.
		
	} asDictionary 
]

{ #category : #'forth-primitives' }
ForthInterpreter >> then [
	self updatePairingLoopStack.
	nestLevel = 1 ifTrue: [ self checkPairingLoopStackIsEmpty ].
	self decrementNestLevel.
	
	
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
ForthInterpreter >> until [
	| repeat position loopCount |
	
	maxLoopCount > 0
		ifTrue: [ loopCount := loopCountStack pop.
			loopCount := loopCount + 1.
			loopCount >= maxLoopCount ifTrue: [ self signalMaxLoopCountHasBeenReached ].
			loopCountStack  push: loopCount ].
	
	repeat := stack pop = 0.
	repeat
		ifTrue: [ 
			position := positionStack top.
			stream position: position ]
		ifFalse: [ 
			positionStack pop 
	]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> updatePairingLoopStack [
	pairingLoopStack top = #else
		ifTrue: [ pairingLoopStack pop ].
	pairingLoopStack pop = #if
		ifFalse: [ self signalIfElseThenUnpairing ]
]

{ #category : #'forth-primitives' }
ForthInterpreter >> updatePairingStackForElse [
	pairingLoopStack push: #else
]

{ #category : #'forth-primitives' }
ForthInterpreter >> variable [
	| variableName |
	
	variableName := self getNextWord.
	self createVariableNamed: variableName  
]

{ #category : #'variable-support' }
ForthInterpreter >> variables: aVariableCollection [ 
	
	self pushFlagOnVariables: aVariableCollection.
		
	variables := aVariableCollection
]

{ #category : #'forth-primitives' }
ForthInterpreter >> while [
	| bool loopCount |
	
	maxLoopCount > 0
		ifTrue: [ loopCount := loopCountStack pop.
			loopCount := loopCount + 1.
			loopCount >= maxLoopCount ifTrue: [ self signalMaxLoopCountHasBeenReached ].
			loopCountStack push: loopCount ].
	
	bool := stack pop ~= 0.
	bool ifFalse: [ self skipToAfterRepeat: loopLevel ]
]
