"
A ForthInterpreterTest is a test class for testing the behavior of ForthInterpreter
"
Class {
	#name : #ForthInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'forth'
	],
	#classVars : [
		'ForthWordAlreadyExists'
	],
	#category : #'SmallForth-Tests-Core'
}

{ #category : #'test support' }
ForthInterpreterTest >> closeTranscriptWindow [
	| morph |
	morph := World submorphs 
		detect: [ :each | each model = Transcript ].
	morph delete
]

{ #category : #running }
ForthInterpreterTest >> setUp [ 
	super setUp.
	forth := ForthInterpreter new.
	forth resetDictionary.
]

{ #category : #tests }
ForthInterpreterTest >> test2drop [
	
		self assert: (forth eval: '1 2 3 4 2drop'; top) equals: 2.
		self assert: forth stackCopy size equals: 2.
		self assert: forth stackCopy equals: #(2 1)
	
]

{ #category : #tests }
ForthInterpreterTest >> test2dup [
	
		self assert: (forth eval: '1 2 3 4 2dup'; top) equals: 4.
		self assert: forth stackCopy size equals: 6.
		self assert: forth stackCopy equals: #(4 3 4 3 2 1)
	
]

{ #category : #tests }
ForthInterpreterTest >> test2over [
	
		self assert: (forth eval: '1 2 3 4 2over'; top) equals: 2.
		self assert: forth stackCopy size equals: 6.
		self assert: forth stackCopy equals: #(2 1 4 3 2 1)
	
]

{ #category : #tests }
ForthInterpreterTest >> test2swap [
	
		self assert: (forth eval: '1 2 3 4 2swap'; top) equals: 2.
		self assert: forth stackCopy size equals: 4.
		self assert: forth stackCopy equals: #(2 1 4 3)
	
]

{ #category : #tests }
ForthInterpreterTest >> testAbort [
	
	Transcript openIfNone. 
	Transcript clear.
	forth eval: 'false abort ." Must see me"'.
	self assert: forth stackCopy isEmpty.
	self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
	self closeTranscriptWindow 
	
		
]

{ #category : #tests }
ForthInterpreterTest >> testAbort2 [
	
	self should: [forth eval: '1 2 3 true abort'] raise: ForthAbort.
	self assert: forth stackCopy isEmpty.
	
		
]

{ #category : #tests }
ForthInterpreterTest >> testAbortWithMessage [
	
	Transcript openIfNone. 
	Transcript clear.
	forth eval: 'false abort" Message" ." No message"'.
	self assert: forth stackCopy isEmpty.
	self assert: (UIManager default confirm: 'Do you see an ''No message'' on Transcript?').
	self closeTranscriptWindow 
	
		
]

{ #category : #tests }
ForthInterpreterTest >> testAbortWithMessage2 [
	
	Transcript openIfNone. 
	Transcript clear.
	self should: [ forth eval: 'true abort" Message" ." Must not see me"' ] raise: ForthAbort.
	self assert: forth stackCopy isEmpty.
	self assert: (UIManager default confirm: 'Do you see an ''Message'' only on Transcript?').
	self closeTranscriptWindow 
	
		
]

{ #category : #tests }
ForthInterpreterTest >> testAnd [
	
	self assert: (forth eval: '0 0 and'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '0 99 and'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '99 0 and'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '99 98 and'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testBackSlash [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '
		
		42 emit 
		\ I am a comment
		." Comment"
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''*Comment'' on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testChar [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: 'char * emit'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an * on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testClass [
	
		self should: [ forth eval: '42 class' ] raise: ForthMissingWord  
	
]

{ #category : #tests }
ForthInterpreterTest >> testComment [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '42 emit ( I am a comment) ." Comment"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''*Comment'' on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testCr [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '." abcd" cr ." efg"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''abcd'' and ''efg'' in two lines on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testDivide [
	
	self assert: (forth eval: '20 7 /'; top) equals: 2.
	self assert: forth stackCopy size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testDot [
	
	Transcript openIfNone. 
	Transcript clear.
	forth eval: '7 dup * .'.
	self assert: [ forth stackCopy isEmpty ].
	self assert: (UIManager default confirm: 'Do you see an 49 on Transcript?').
	self closeTranscriptWindow  
	
]

{ #category : #tests }
ForthInterpreterTest >> testDot2 [
	
	Transcript openIfNone. 
	Transcript clear.
	forth eval: '77 42 . .'.
	self assert: [ forth stackCopy isEmpty ].
	self assert: (UIManager default confirm: 'Do you see an 42 77 on Transcript?').
	self closeTranscriptWindow  
	
]

{ #category : #tests }
ForthInterpreterTest >> testDotQuote [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '42 emit ." Hello    World!"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''*Hello    World!'' on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testDotQuoteWithEmptyString [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '." "'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you ''see'' an ''empty string'' on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testDotS [
	
	Transcript openIfNone. 
	Transcript clear.
	forth eval: '1 2 3 .s'.
	self assert: forth stackCopy size equals: 3.
	self assert: forth stackCopy equals: #(3 2 1).
	self assert: (UIManager default confirm: 'Do you see an ''<3> 1 2 3'' on Transcript?').
	self closeTranscriptWindow  
	
]

{ #category : #tests }
ForthInterpreterTest >> testDrop [
	
	self assert: (forth eval: '20 7 drop'; top) equals: 20.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testDup [ 
	
	self assert: (forth eval: '7 dup'; stackCopy) equals: #(7 7).
	self assert: forth stackCopy size equals: 2.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testEmit [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '42 emit'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an * on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testEmptyExpression [
	
	"self should: [" forth eval: '' "] raise: Error
	
	"
	
]

{ #category : #tests }
ForthInterpreterTest >> testEqual [ 
	
	self assert: (forth eval: '7 dup ='; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	self assert: (forth eval: '7 9 ='; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testFalse [
	
	self assert: (forth eval: 'false'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testForget [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '
		
			: greet ." Dummy." ;
			: greet ." Dummy2." ;
			: greet ." Hello, I speak Forth." ;
			: greet ." Hi there!" ;
			forget greet
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Hello, I speak Forth.'' in on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testGreaterThan [
	
	self assert: (forth eval: '7 dup >'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '7 9 >'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '9 7 >'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testGreaterThanZero [ 
	
	self assert: (forth eval: '0 0>'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	self assert: (forth eval: '-7 0>'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	self assert: (forth eval: '9 0>'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThen [ 
	
	self assert: (forth eval: 'false if 1 2 3 swap else 4 5 6 dup then'; stackCopy) equals: #(6 6 5 4).
	self assert: forth stackCopy size equals: 4.
	self assert: (forth eval: 'true if 1 2 3 swap else 4 5 6 dup then'; stackCopy) equals: #(2 3 1).
	self assert: forth stackCopy size equals: 3.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThenWithComment [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'false if 1 ( I have an else and a then in the middle) else ." Must (with else or then) see me" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must (with else or then) see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThenWithComment2 [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'true if ." Must see me" else 2 ( I have an else and a then in the middle) then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThenWithDotQuote [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'false if ." I have an else and a then in the middle" else ." Must see me" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThenWithDotQuote2 [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'true if ." Must see me" else ." I have an else and a then in the middle" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThenWithLineComment [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'false if 1 \ I have an else and a then in the middle
				else ." Must see me" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfElseThenWithLineComment2 [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'true if ." Must see me" 
				else \ I have an else and a then in the middle
				then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfThen [ 
	
	self assert: (forth eval: 'false if 1 2 3 swap then 4 5 6'; stackCopy) equals: #(6 5 4).
	self assert: forth stackCopy size equals: 3.
	self assert: (forth eval: 'true if 1 2 3 swap then 4 5 6'; stackCopy) equals: #(6 5 4 2 3 1).
	self assert: forth stackCopy size equals: 6.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfThenWithComment [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'false if 1 ( I have an else and a then in the middle) then ." Must see me"'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfThenWithDotQuote [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'false if ." I have an else and a then in the middle" then ." Must see me"'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfThenWithLineComment [
	
	Transcript openIfNone. 
		Transcript clear.
		forth eval: 'false if 1 
				
				\ I have an else and a then in the middle
				
				then ." Must see me"'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		self closeTranscriptWindow 
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testIfWithouThen [ 
	
	self should: [forth eval: 'true if 1 2 3 swap']  raise: ForthIfWithouThen.
	self should: [forth eval: 'false if 1 2 3 swap'] raise: ForthIfWithouThen
]

{ #category : #tests }
ForthInterpreterTest >> testInvert [
	
	self assert: (forth eval: '0 invert'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '-1 invert'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '99 invert'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '-99 invert'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testLessThan [
	
	self assert: (forth eval: '7 dup <'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '7 9 <'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '9 7 <'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testLessThanZero [ 
	
	self assert: (forth eval: '0 0<'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	self assert: (forth eval: '-7 0<'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	self assert: (forth eval: '9 0<'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testMarker [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '
		
			: greet ." Dummy." ;
			: greet ." Hello, I speak Forth." ;
			marker -work
			: greet ." Hi there!" ;
			-work
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Hello, I speak Forth.'' in on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testMarkerDuplicateWord [
		
		
		self should: [forth eval: '
		
			: greet ." Dummy." ;
			: greet ." Hello, I speak Forth." ;
			marker greet
			: greet ." Hi there!" ;
			greet
		
		'] raise: ForthMarkerDuplicatedWord.
		
	
]

{ #category : #tests }
ForthInterpreterTest >> testMinus [
	
	self assert: (forth eval: '7 9 -'; top) equals: -2.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testMissingMarker [
		
			self should: [forth eval: '
		
			: greet ." Dummy." ;
			: greet ." Hello, I speak Forth." ;
			: greet ." Hi there!" ;
			-work
			greet
		
		'] raise: ForthMissingWord 
		
	
]

{ #category : #tests }
ForthInterpreterTest >> testMissingWord [
	
	| word |
	word := 'xpto', (10000 atRandom asString). 
	self should: [ forth eval: word ] raise: ForthMissingWord
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testMod [
	
	self assert: (forth eval: '20 7 mod'; top) equals: 6.
	self assert: forth stackCopy size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testMult [
	
	self assert: (forth eval: '7 9 *'; top) equals: 63.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfElseThen [ 
	
	self assert: (forth eval: '
		false 
			if 
				false 
					if 2
					else 3 ( <<<)
					then
			else 4
			then 5 ( <<<)
	'; 
	stackCopy) equals: #(5 3).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfElseThen2 [ 
	
	self assert: (forth eval: '
		false 
			if 
				true 
					if 2
					else 3 ( <<<)
					then
			else 4
			then 5 ( <<<)
	'; 
	stackCopy) equals: #(5 3).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfElseThen3 [
	
	self assert: (forth eval: '
		true 
			if 
				false 
					if 2
					else 3 ( <<<)
					then
			else 4
			then 5 ( <<<)
	'; 
	stackCopy) equals: #(5 3).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfElseThen4 [
	
	self assert: (forth eval: '
		true 
			if 
				true 
					if 2 ( <<<)
					else 3 
					then
			else 4
			then 5 ( <<<)
	'; 
	stackCopy) equals: #(5 2).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfThen [ 
	
	self assert: (forth eval: 'false if false if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfThen2 [ 
	
	self assert: (forth eval: 'false if true if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfThen3 [
	
	self assert: (forth eval: 'true if false if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7 6 5 4).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNestedIfThen4 [
	
	self assert: (forth eval: 'true if true if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7 6 5 4 3 2 1).
	
]

{ #category : #tests }
ForthInterpreterTest >> testNotEqual [
	
	self assert: (forth eval: '7 dup <>'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '7 9 <>'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testOr [
	
	self assert: (forth eval: '0 0 or'; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '0 99 or'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '99 0 or'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '99 98 or'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testOver [
	
		self assert: (forth eval: '42 99 over'; top) equals: 42.
		self assert: forth stackCopy size equals: 3.
		self assert: forth stackCopy equals: #(42 99 42)
	
]

{ #category : #tests }
ForthInterpreterTest >> testPlus [
	
	self assert: (forth eval: '7 9 +'; top) equals: 16.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testPushNumber [
	
	self assert: (forth eval: '7'; top) equals: 7.
	self assert: forth stackCopy size equals: 1.
	
	self assert: (forth eval: '-7'; top) equals: -7.
	self assert: forth stackCopy size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testQuestionMarkDup [ 
	
	self assert: (forth eval: '7 ?dup'; stackCopy) equals: #(7 7).

	self assert: (forth eval: '0 ?dup'; stackCopy) equals: #(0).
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testRedefineWord [
	
	self shouldnt: [ forth eval: ': test dup ; : test dup dup ;' ] raise: Error
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testRot [
	
		self assert: (forth eval: '42 99 27 rot'; top) equals: 42.
		self assert: forth stackCopy size equals: 3.
		self assert: forth stackCopy equals: #(42 27 99)
	
]

{ #category : #tests }
ForthInterpreterTest >> testSlashMod [
	
	self assert: (forth eval: '20 7 /mod' ; top)equals: 2.
	self assert: forth stackCopy size equals: 2.
	self assert: forth stackCopy equals: #(2 6)
]

{ #category : #tests }
ForthInterpreterTest >> testSpace [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '." abcd" space space space ." efg"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''abcd   efg'' on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testSpaces [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '." abcd" 3 spaces ." efg"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''abcd   efg'' on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testSquare [
		self assert: (forth eval: '
		
		: square dup * ;
		7 square
		
		'; top) equals: 49.
		self assert: forth stackCopy size equals: 1
]

{ #category : #tests }
ForthInterpreterTest >> testSwap [
	
		self assert: (forth eval: '22 42 99 swap'; top) equals: 42.
		self assert: forth stackCopy size equals: 3.
		self assert: forth stackCopy equals: #(42 99 22)
	
]

{ #category : #tests }
ForthInterpreterTest >> testSynonymous [
	self
		assert:
			(forth
				eval: ': test dup ; 7 test *';
				top)
		equals: 49.
	self assert: forth stackCopy size equals: 1
]

{ #category : #tests }
ForthInterpreterTest >> testTranscript [
		
		Transcript openIfNone. 
		Transcript clear.
		
		forth eval: '42 emit'.
		
		self assert: (UIManager default confirm: 'Do you see weird contents on Transcript?') not.
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testTrue [
	
	self assert: (forth eval: 'true'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testTwoMarker [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '
		
			: greet ." Dummy." ;
			marker -work2
			: greet ." Hello, I speak Forth." ;
			marker -work
			: greet ." Hi there!" ;
			-work2
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Dummy.'' in on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testTwoMarker2 [
		
		Transcript openIfNone. 
		Transcript clear.
		forth eval: '
		
			: greet ." Dummy." ;
			marker -work2
			: greet ." Hello, I speak Forth." ;
			marker -work
			: greet ." Hi there!" ;
			-work
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Hello, I speak Forth.'' in on Transcript?').
		self closeTranscriptWindow 
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testUnderflow [
	
	self should: [ forth eval: '.' ] raise: ForthStackUnderflow
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testUppercase [
	
	forth acceptUppercase.
	self assert: (forth eval: '7 ?DUP'; stackCopy) equals: #(7 7)
]

{ #category : #tests }
ForthInterpreterTest >> testZeroEqual [ 
	
	self assert: (forth eval: '7 dup - 0='; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	self assert: (forth eval: '7 9 - 0='; top) equals: 0.
	self assert: forth stackCopy size equals: 1.
	
	
]
