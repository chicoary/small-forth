"
A ForthInterpreterTest is a test class for testing the behavior of ForthInterpreter
"
Class {
	#name : #ForthInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'forth',
		'skipTests'
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
	skipTests := false
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
ForthInterpreterTest >> testAbort2 [
	
	self should: [forth eval: '1 2 3 true abort'] raise: ForthAbort.
	self assert: forth stackCopy isEmpty.
	
		
]

{ #category : #tests }
ForthInterpreterTest >> testAbs [
	
	self assert: (forth eval: '7 abs'; stackCopy) equals: #(7).
	self assert: (forth eval: '-7 abs'; stackCopy) equals: #(7).

	
]

{ #category : #tests }
ForthInterpreterTest >> testAddsOne [
		self assert: (forth eval: '3 1+'; stackCopy) equals: #(4).
		
]

{ #category : #tests }
ForthInterpreterTest >> testAddsTwo [
		self assert: (forth eval: '3 2+'; stackCopy) equals: #(5).
		
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
ForthInterpreterTest >> testClass [
	
		self should: [ forth eval: '42 class' ] raise: ForthMissingWord  
	
]

{ #category : #tests }
ForthInterpreterTest >> testCopyFromReturnStack [
	
	forth eval: '7 >r r@'.
	self assert: forth stackCopy equals: #(7).
	self assert: forth returnStackCopy equals: #(7).
]

{ #category : #tests }
ForthInterpreterTest >> testDictionaryPersitenceBetweenEvals [
	
		forth eval: ': test 888 999 ;'.
		
		self assert: (forth eval: 'test'; stackCopy) equals: #(888 999) reversed
	
]

{ #category : #tests }
ForthInterpreterTest >> testDictionaryUppercaseWord [
	
		forth eval: ': /TEST 888 999 DUP ;'.
		
		self assert: (forth eval: '/test'; stackCopy) equals: #(888 999 999) reversed
	
]

{ #category : #tests }
ForthInterpreterTest >> testDivide [
	
	self assert: (forth eval: '20 7 /'; top) equals: 2.
	self assert: forth stackCopy size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testDividesByTwo [
		self assert: (forth eval: '8 2/'; stackCopy) equals: #(4).
		self assert: (forth eval: '-8 2/'; stackCopy) equals: #(-4).
		
]

{ #category : #tests }
ForthInterpreterTest >> testDoLoop [
	self assert: (forth eval: '3 0 do 9 loop'; stackCopy) equals: #(9 9 9) reversed.
	self assert: (forth eval: '5 2 do 9 loop'; stackCopy) equals: #(9 9 9) reversed.
	self assert: (forth eval: '-2 -5 do 9 loop'; stackCopy) equals: #(9 9 9) reversed
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testDoLoopWithIndex [
	self assert: (forth eval: '3 0 do i loop'; stackCopy) equals: #(0 1 2) reversed
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
ForthInterpreterTest >> testEmptyExpression [
	
	self assert: (forth eval: ''; stackCopy) equals: Array empty
	
	
	
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
ForthInterpreterTest >> testMax [
	
	self assert: (forth eval: '7 9 max'; stackCopy) equals: #(9).

	
]

{ #category : #tests }
ForthInterpreterTest >> testMin [
	
	self assert: (forth eval: '7 9 min'; stackCopy) equals: #(7).

	
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
ForthInterpreterTest >> testMultipliesByTwo [
		self assert: (forth eval: '3 2*'; stackCopy) equals: #(6).
		self assert: (forth eval: '-3 2*'; stackCopy) equals: #(-6).
		
]

{ #category : #tests }
ForthInterpreterTest >> testNegate [
	
	self assert: (forth eval: '7 negate'; stackCopy) equals: #(-7).
	self assert: (forth eval: '-7 negate'; stackCopy) equals: #(7).

	
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
ForthInterpreterTest >> testPushOnReturnStack [
	
	forth eval: '7 >r'.
	self assert: forth stackCopy isEmpty.
	self assert: forth returnStackCopy equals: #(7) 
]

{ #category : #tests }
ForthInterpreterTest >> testPushOnStack [
	
	forth eval: '7 >r r>'.
	self assert: forth stackCopy equals: #(7).
	self assert: forth returnStackCopy isEmpty
]

{ #category : #tests }
ForthInterpreterTest >> testQuestionMarkDup [ 
	
	self assert: (forth eval: '7 ?dup'; stackCopy) equals: #(7 7).

	self assert: (forth eval: '0 ?dup'; stackCopy) equals: #(0).
	
	
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
ForthInterpreterTest >> testSquare [
		self assert: (forth eval: '
		
		: square dup * ;
		7 square
		
		'; top) equals: 49.
		self assert: forth stackCopy size equals: 1
]

{ #category : #tests }
ForthInterpreterTest >> testStarSlash [
	
		self assert: (forth eval: '225 32 100 */'; stackCopy) equals: #(72).
		
]

{ #category : #tests }
ForthInterpreterTest >> testStarSlashMod [
	self assert: (forth eval: '225 32 88 */mod'; stackCopy) equals: #(72 81) reversed
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testSubtractsOne [
		self assert: (forth eval: '3 1-'; stackCopy) equals: #(2)
		
]

{ #category : #tests }
ForthInterpreterTest >> testSubtractsTwo [
		self assert: (forth eval: '3 2-'; stackCopy) equals: #(1).
		
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
ForthInterpreterTest >> testTrue [
	
	self assert: (forth eval: 'true'; top) equals: -1.
	self assert: forth stackCopy size equals: 1.
	
	
	
	
	
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
