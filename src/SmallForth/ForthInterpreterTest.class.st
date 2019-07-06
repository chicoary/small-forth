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
	forth resetDictionary
]

{ #category : #tests }
ForthInterpreterTest >> test2DUPUppercased [
	self assert: (forth eval: '3 4 2dup'; stack) equals: #(3 4 3 4) reversed.
	self assert: (forth eval: '3 4 2DUP'; stack) equals: #(3 4 3 4) reversed
]

{ #category : #tests }
ForthInterpreterTest >> test2drop [
	
		self assert: (forth eval: '1 2 3 4 2drop'; top) equals: 2.
		self assert: forth stack size equals: 2.
		self assert: forth stack equals: #(2 1)
	
]

{ #category : #tests }
ForthInterpreterTest >> test2dup [
	
		self assert: (forth eval: '1 2 3 4 2dup'; top) equals: 4.
		self assert: forth stack size equals: 6.
		self assert: forth stack equals: #(4 3 4 3 2 1)
	
]

{ #category : #tests }
ForthInterpreterTest >> test2over [
	
		self assert: (forth eval: '1 2 3 4 2over'; top) equals: 2.
		self assert: forth stack size equals: 6.
		self assert: forth stack equals: #(2 1 4 3 2 1)
	
]

{ #category : #tests }
ForthInterpreterTest >> test2swap [
	
		self assert: (forth eval: '1 2 3 4 2swap'; top) equals: 2.
		self assert: forth stack size equals: 4.
		self assert: forth stack equals: #(2 1 4 3)
	
]

{ #category : #tests }
ForthInterpreterTest >> testAbort2 [
	
	self should: [forth eval: '1 2 3 true abort'] raise: ForthAbort.
	self assert: forth stack isEmpty.
	
		
]

{ #category : #tests }
ForthInterpreterTest >> testAbs [
	
	self assert: (forth eval: '7 abs'; stack) equals: #(7).
	self assert: (forth eval: '-7 abs'; stack) equals: #(7).

	
]

{ #category : #tests }
ForthInterpreterTest >> testAddsOne [
		self assert: (forth eval: '3 1+'; stack) equals: #(4).
		
]

{ #category : #tests }
ForthInterpreterTest >> testAddsTwo [
		self assert: (forth eval: '3 2+'; stack) equals: #(5).
		
]

{ #category : #tests }
ForthInterpreterTest >> testAnd [
	
	self assert: (forth eval: '0 0 and'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '0 99 and'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '99 0 and'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '99 98 and'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testAtPutWithStack [
	
	| s x |
		
	s := Stack new.
	x := 'whatever'.
	s push: x; push: x.
	self assert: s equals: { x. x }.
	s at: 2 put: x.
	self assert: s equals: { x }.
	
]

{ #category : #tests }
ForthInterpreterTest >> testClass [
	
		self should: [ forth eval: '42 class' ] raise: ForthMissingWord  
	
]

{ #category : #tests }
ForthInterpreterTest >> testClearTheStack [
	
	self should: [ forth eval: '1 2 3 XX' ] raise: ForthMissingWord.
	self assert: [ forth stack isEmpty ]
		
		
]

{ #category : #tests }
ForthInterpreterTest >> testCopyFromReturnStack [
	
	forth eval: '7 >r r@'.
	self assert: forth stack equals: #(7).
	self assert: forth returnStackCopy equals: #(7).
]

{ #category : #tests }
ForthInterpreterTest >> testDictionaryPersitenceBetweenEvals [
	
		forth eval: ': test 888 999 ;'.
		
		self assert: (forth eval: 'test'; stack) equals: #(888 999) reversed
	
]

{ #category : #tests }
ForthInterpreterTest >> testDictionaryUppercaseWord [
	
		forth eval: ': /TEST 888 999 DUP ;'.
		
		self assert: (forth eval: '/test'; stack) equals: #(888 999 999) reversed
	
]

{ #category : #tests }
ForthInterpreterTest >> testDivide [
	
	self assert: (forth eval: '20 7 /'; top) equals: 2.
	self assert: forth stack size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testDividesByTwo [
		self assert: (forth eval: '8 2/'; stack) equals: #(4).
		self assert: (forth eval: '-8 2/'; stack) equals: #(-4).
		
		self assert: (forth eval: '-7 2/'; stack) equals: #(-4).
		
]

{ #category : #tests }
ForthInterpreterTest >> testDrop [
	
	self assert: (forth eval: '20 7 drop'; top) equals: 20.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testDup [ 
	
	self assert: (forth eval: '7 dup'; stack) equals: #(7 7).
	self assert: forth stack size equals: 2.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testEmptyExpression [
	
	self assert: (forth eval: ''; stack) equals: Array empty
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testEqual [ 
	
	self assert: (forth eval: '7 dup ='; top) equals: -1.
	self assert: forth stack size equals: 1.
	self assert: (forth eval: '7 9 ='; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testFalse [
	
	self assert: (forth eval: 'false'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testForceToLowercaseFor2DUP [
	self assert: (forth forceToLowercase: '2DUP') equals: '2dup'.

]

{ #category : #tests }
ForthInterpreterTest >> testGreaterThan [
	
	self assert: (forth eval: '7 dup >'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '7 9 >'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '9 7 >'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testGreaterThanZero [ 
	
	self assert: (forth eval: '0 0>'; top) equals: 0.
	self assert: forth stack size equals: 1.
	self assert: (forth eval: '-7 0>'; top) equals: 0.
	self assert: forth stack size equals: 1.
	self assert: (forth eval: '9 0>'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testInvert [
	
	self assert: (forth eval: '0 invert'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '-1 invert'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '99 invert'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '-99 invert'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testLessThan [
	
	self assert: (forth eval: '7 dup <'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '7 9 <'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '9 7 <'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testLessThanZero [ 
	
	self assert: (forth eval: '0 0<'; top) equals: 0.
	self assert: forth stack size equals: 1.
	self assert: (forth eval: '-7 0<'; top) equals: -1.
	self assert: forth stack size equals: 1.
	self assert: (forth eval: '9 0<'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
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
	
	self assert: (forth eval: '7 9 max'; stack) equals: #(9).

	
]

{ #category : #tests }
ForthInterpreterTest >> testMin [
	
	self assert: (forth eval: '7 9 min'; stack) equals: #(7).

	
]

{ #category : #tests }
ForthInterpreterTest >> testMinus [
	
	self assert: (forth eval: '7 9 -'; top) equals: -2.
	self assert: forth stack size equals: 1.
	
	
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
	self assert: forth stack size equals: 1.
	
]

{ #category : #tests }
ForthInterpreterTest >> testMult [
	
	self assert: (forth eval: '7 9 *'; top) equals: 63.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testMultipliesByTwo [
		self assert: (forth eval: '3 2*'; stack) equals: #(6).
		self assert: (forth eval: '-3 2*'; stack) equals: #(-6).
		
]

{ #category : #tests }
ForthInterpreterTest >> testNegate [
	
	self assert: (forth eval: '7 negate'; stack) equals: #(-7).
	self assert: (forth eval: '-7 negate'; stack) equals: #(7).

	
]

{ #category : #tests }
ForthInterpreterTest >> testNotEqual [
	
	self assert: (forth eval: '7 dup <>'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '7 9 <>'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testOr [
	
	self assert: (forth eval: '0 0 or'; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '0 99 or'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '99 0 or'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '99 98 or'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testOver [
	
		self assert: (forth eval: '42 99 over'; top) equals: 42.
		self assert: forth stack size equals: 3.
		self assert: forth stack equals: #(42 99 42)
	
]

{ #category : #tests }
ForthInterpreterTest >> testPlus [
	
	self assert: (forth eval: '7 9 +'; top) equals: 16.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testPushNumber [
	
	self assert: (forth eval: '7'; top) equals: 7.
	self assert: forth stack size equals: 1.
	
	self assert: (forth eval: '-7'; top) equals: -7.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testPushOnReturnStack [
	
	forth eval: '7 >r'.
	self assert: forth stack isEmpty.
	self assert: forth returnStackCopy equals: #(7) 
]

{ #category : #tests }
ForthInterpreterTest >> testPushOnStack [
	
	forth eval: '7 >r r>'.
	self assert: forth stack equals: #(7).
	self assert: forth returnStackCopy isEmpty
]

{ #category : #tests }
ForthInterpreterTest >> testQuestionMarkDup [ 
	
	self assert: (forth eval: '7 ?dup'; stack) equals: #(7 7).

	self assert: (forth eval: '0 ?dup'; stack) equals: #(0).
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testRot [
	
		self assert: (forth eval: '42 99 27 rot'; top) equals: 42.
		self assert: forth stack size equals: 3.
		self assert: forth stack equals: #(42 27 99)
	
]

{ #category : #tests }
ForthInterpreterTest >> testSlashMod [
	
	self assert: (forth eval: '20 7 /mod' ; top)equals: 2.
	self assert: forth stack size equals: 2.
	self assert: forth stack equals: #(2 6)
]

{ #category : #tests }
ForthInterpreterTest >> testSquare [
		self assert: (forth eval: '
		
		: square dup * ;
		7 square
		
		'; top) equals: 49.
		self assert: forth stack size equals: 1
]

{ #category : #tests }
ForthInterpreterTest >> testStarSlash [
	
		self assert: (forth eval: '225 32 100 */'; stack) equals: #(72).
		
]

{ #category : #tests }
ForthInterpreterTest >> testStarSlashMod [
	self assert: (forth eval: '225 32 88 */mod'; stack) equals: #(72 81) reversed
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testSubtractsOne [
		self assert: (forth eval: '3 1-'; stack) equals: #(2)
		
]

{ #category : #tests }
ForthInterpreterTest >> testSubtractsTwo [
		self assert: (forth eval: '3 2-'; stack) equals: #(1).
		
]

{ #category : #tests }
ForthInterpreterTest >> testSwap [
	
		self assert: (forth eval: '22 42 99 swap'; top) equals: 42.
		self assert: forth stack size equals: 3.
		self assert: forth stack equals: #(42 99 22)
	
]

{ #category : #tests }
ForthInterpreterTest >> testSynonymous [
	self
		assert:
			(forth
				eval: ': test dup ; 7 test *';
				top)
		equals: 49.
	self assert: forth stack size equals: 1
]

{ #category : #tests }
ForthInterpreterTest >> testTrue [
	
	self assert: (forth eval: 'true'; top) equals: -1.
	self assert: forth stack size equals: 1.
	
	
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testUnderflow [
	
	self should: [ forth eval: '.' ] raise: ForthParameterStackUnderflow
	
	
	
]

{ #category : #tests }
ForthInterpreterTest >> testUppercase [
	
	forth acceptUppercase.
	self assert: (forth eval: '7 ?DUP'; stack) equals: #(7 7)
]

{ #category : #tests }
ForthInterpreterTest >> testVariable [
		
		self assert: (forth eval: '
		
			variable date
			variable month
			variable year
			
			18 date !
			06 month !
			2019 year !
			
			date @
			month @
			year @
		
		'; stack) equals: #(18 6 2019) reversed
		
	
]

{ #category : #tests }
ForthInterpreterTest >> testVariableInsideWord [
		
		self assert: (forth eval: '
		
			variable date
			variable month

			18 date  !
			 6 month !
			
			: test variable date 19 date ! date @ month @ ;
			
			test
			date @
		
		'; stack) equals: #(19 6 18) reversed
		
	
]

{ #category : #tests }
ForthInterpreterTest >> testVariableShadowInsideWord [
		
			self assert: (forth eval: '
		
			variable date
			variable month
			variable year

			18 date  !
			 6 month !
			2019 year !
			
			: test  variable year 2020 year ! date @ month @ year @ ;
		
			test
			date @ month @	year @
		
		'; stack) equals: #(18 6 2020 18 6 2019) reversed
		
	
]

{ #category : #tests }
ForthInterpreterTest >> testZeroEqual [ 
	
	self assert: (forth eval: '7 dup - 0='; top) equals: -1.
	self assert: forth stack size equals: 1.
	self assert: (forth eval: '7 9 - 0='; top) equals: 0.
	self assert: forth stack size equals: 1.
	
	
]

{ #category : #test }
ForthInterpreterTest >> test_2drop [

	forth stack: forth newStack.
	self should: [ forth _2drop ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	self should: [ forth _2drop ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	forth _2drop.
	self assert: forth stack isEmpty 
]

{ #category : #test }
ForthInterpreterTest >> test_2dup [

	forth stack: forth newStack.
	self should: [ forth _2dup ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	self should: [ forth _2dup ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	forth _2dup.
	self assert: forth stack equals: #(1 2 1 2) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_2over [

	forth stack: forth newStack.
	self should: [ forth _2over ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	self should: [ forth _2over ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	self should: [ forth _2over ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	forth pushNumber: 3.
	self should: [ forth _2over ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	forth pushNumber: 3.
	forth pushNumber: 4.
	forth _2over.
	self assert: forth stack equals: #(1 2 3 4 1 2) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_2swap [

	forth stack: forth newStack.
	self should: [ forth _2swap ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	self should: [ forth _2swap ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	self should: [ forth _2swap ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	forth pushNumber: 3.
	self should: [ forth _2swap ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 1.
	forth pushNumber: 2.
	forth pushNumber: 3.
	forth pushNumber: 4.
	forth _2swap.
	self assert: forth stack equals: #(3 4 1 2) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_addsOne [

	forth stack: forth newStack.
	self should: [ forth _addsOne ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 1.
	forth _addsOne.
	self assert: forth stack equals: #(2) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_addsTwo [
	
	forth stack: forth newStack.
	self should: [ forth _addsTwo ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 1.
	forth _addsTwo.
	self assert: forth stack equals: #(3) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_at [
	
	forth stack: forth newStack.
	forth variables: forth newVariableCollection.
	forth createVariableNamed: #x.
	forth pushNumber: 99.
	forth pushAddressOfVariableNamed: #x.
	forth _exclamationMark.
	forth pushAddressOfVariableNamed: #x.
	
	forth _at.
	self assert: forth stack equals: #(99) reversed.
	
	self should: [ forth eval: 'yyutyu' ] raise: ForthMissingWord 
]

{ #category : #test }
ForthInterpreterTest >> test_divides [
	
	forth stack: forth newStack.
	self should: [ forth _divides ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _divides ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 3.
	forth _divides.
	self assert: forth stack equals: #(2) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_dividesByTwo [

	forth stack: forth newStack.
	self should: [ forth _dividesByTwo ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 7.
	forth _dividesByTwo.
	self assert: forth stack equals: #(3) reversed.
	
	forth emptyStack.
	forth pushNumber: -7.
	forth _dividesByTwo.
	self assert: forth stack equals: #(-4) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_equal [

	forth stack: forth newStack.
	self should: [ forth _equal ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _equal ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 7.
	forth _equal.
	self assert: forth stack equals: #(-1) reversed.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 8.
	forth _equal.
	self assert: forth stack equals: #(0) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_exclamationMark [
	
	forth stack: forth newStack.
	forth variables: forth newVariableCollection.
	forth createVariableNamed: #x.
	forth pushNumber: 99.
	forth pushAddressOfVariableNamed: #x.
	forth _exclamationMark.
	
	self assert: (forth valueOfVariableNamed: #x) equals: 99.
	
	self should: [ forth valueOfVariableNamed: #yyutyu ] raise: ForthMissingWord
]

{ #category : #test }
ForthInterpreterTest >> test_greaterThan [

	forth stack: forth newStack.
	self should: [ forth _greaterThan ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _greaterThan ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 7.
	forth _greaterThan.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 8.
	forth _greaterThan.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: 8.
	forth pushNumber: 7.
	forth _greaterThan.
	self assert: forth stack equals: #(-1) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_greaterThanR [
	
	forth stack: forth newStack.
	self should: [ forth _greaterThanR ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth _greaterThanR.
	forth _rGreaterThan.
	self assert: forth stack equals: #(7).
	

]

{ #category : #test }
ForthInterpreterTest >> test_greaterThanZero [

	forth stack: forth newStack.
	self should: [ forth _greaterThanZero ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 8.
	forth _greaterThanZero.
	self assert: forth stack equals: #(-1) reversed.
	
	forth emptyStack.
	forth pushNumber: -8.
	forth _greaterThanZero.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: 0.
	forth _greaterThanZero.
	self assert: forth stack equals: #(0) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_lessThan [

	forth stack: forth newStack.
	self should: [ forth _lessThan ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _lessThan ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 7.
	forth _lessThan.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 8.
	forth _lessThan.
	self assert: forth stack equals: #(-1) reversed.
	
	forth emptyStack.
	forth pushNumber: 8.
	forth pushNumber: 7.
	forth _lessThan.
	self assert: forth stack equals: #(0) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_lessThanZero [

	forth stack: forth newStack.
	self should: [ forth _lessThanZero ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 8.
	forth _lessThanZero.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: -8.
	forth _lessThanZero.
	self assert: forth stack equals: #(-1) reversed.
	
	forth emptyStack.
	forth pushNumber: 0.
	forth _lessThanZero.
	self assert: forth stack equals: #(0) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_minus [

	forth stack: forth newStack.
	self should: [ forth _minus ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _minus ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 7.
	forth _minus.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: 6.
	forth pushNumber: 9.
	forth _minus.
	self assert: forth stack equals: #(-3) reversed.
	
	forth emptyStack.
	forth pushNumber: 8.
	forth pushNumber: 2.
	forth _minus.
	self assert: forth stack equals: #(6) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_mult [

	forth stack: forth newStack.
	self should: [ forth _mult ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _mult ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 9.
	forth _mult.
	self assert: forth stack equals: #(63) reversed.
	
	
]

{ #category : #test }
ForthInterpreterTest >> test_multipliesByTwo [

	forth stack: forth newStack.
	self should: [ forth _multipliesByTwo ] raise: ForthParameterStackUnderflow.

	forth emptyStack.
	forth pushNumber: 7.
	forth _multipliesByTwo.
	self assert: forth stack equals: #(14) reversed.
	
	forth emptyStack.
	forth pushNumber: -7.
	forth _multipliesByTwo.
	self assert: forth stack equals: #(-14) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_notEqual [

	forth stack: forth newStack.
	self should: [ forth _notEqual ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _notEqual ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 7.
	forth _notEqual.
	self assert: forth stack equals: #(0) reversed.
	
	forth emptyStack.
	forth pushNumber: 7.
	forth pushNumber: 8.
	forth _notEqual.
	self assert: forth stack equals: #(-1) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_plus [

	forth stack: forth newStack.
	self should: [ forth _plus ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _plus ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 6.
	forth pushNumber: 9.
	forth _plus.
	self assert: forth stack equals: #(15) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_questionMarkDup [

	self flag: #toImplement.

	forth stack: forth newStack.
	self should: [ forth _questionMarkDup ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 6.
	forth _questionMarkDup.
	self assert: forth stack equals: #(6 6) reversed.
	
	forth emptyStack.
	forth pushNumber: 0.
	forth _questionMarkDup.
	self assert: forth stack equals: #(0) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_rAt [
	
	forth stack: forth newStack.
	self should: [ forth _rAt ] raise: ForthReturnStackUnderflow.
	
	forth stack: forth newStack.
	forth pushNumber: 99.
	forth _greaterThanR. ">R"
	forth _rAt. "R@"
	self assert: forth stack equals: #(99) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_rGreaterThan [

	self flag: #toImplement.
	
	forth stack: forth newStack.
	self should: [ forth _rGreaterThan ] raise: ForthReturnStackUnderflow.
	
	forth stack: forth newStack.
	forth pushNumber: 99.
	forth pushNumber: 98.
	forth _greaterThanR. ">R"
	forth _greaterThanR. ">R"
	forth _rGreaterThan. "R>"
	forth _rGreaterThan. "R>"
	self assert: forth stack equals: #(99 98) reversed
]

{ #category : #test }
ForthInterpreterTest >> test_slashMod [

	self flag: #toImplement.

	forth stack: forth newStack.
	self should: [ forth _slashMod ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 7.
	self should: [ forth _slashMod ] raise: ForthParameterStackUnderflow.
	
	forth emptyStack.
	forth pushNumber: 19.
	forth pushNumber: 5.
	forth _slashMod.
	self assert: forth stack equals: #(4 3) reversed
]
