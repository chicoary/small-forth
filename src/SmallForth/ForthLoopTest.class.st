Class {
	#name : #ForthLoopTest,
	#superclass : #ForthInterpreterTest,
	#classInstVars : [
		'generateAll'
	],
	#category : #'SmallForth-Tests-Core'
}

{ #category : #'as yet unclassified' }
ForthLoopTest class >> arrayTimes: x fromYArray: yArray andZArray: zArray [ 
	| array coll |
	
	coll := OrderedCollection empty.
	
	coll add: 1.
	
	coll := coll, yArray.
	x timesRepeat: [ coll := coll, zArray, yArray ].
	
	coll add: 10.
	
	array := coll asArray.
	^ array
	
]

{ #category : #'code generation' }
ForthLoopTest class >> calculateStackFromCounter: aCounter [
	| x y z xTimes yTimes zTimes stackString yArray zArray xArray |
	
	x := (aCounter at: 1) digitValue.
	y := (aCounter at: 2) digitValue.
	z := (aCounter at: 3) digitValue.
	
	yArray := self yArrayFrom: y.
	zArray := self zArrayFrom: z.
	xArray := self arrayTimes: x fromYArray: yArray andZArray: zArray.
	stackString := xArray asString.

	^ stackString
]

{ #category : #'code generation' }
ForthLoopTest class >> compileFromMethodSource: source [
	"^ self compile: source classified: 'generated-test'"
	
	(generateAll
		or: [ (self canUnderstand: source asInstanceSideBehaviorName asSymbol) not ])
		ifTrue: [ 
			self compile: source classified: 'generated-test' ]
]

{ #category : #initialization }
ForthLoopTest class >> generateMissingTestsOnly [
	generateAll := false
]

{ #category : #'code generation' }
ForthLoopTest class >> generateNestedBeginWhileRepeatLoopTests [
	<script>
	| smallForthSource max string size testMethodSource |
	
	[ :job | 
	job title: 'Generating tests for loops BEGIN WHILE REPEAT' translated.
	max := 3r222.
	0 to: max do: [ :n | 
		job progress: 1.0 * n / max.
		(Delay forMilliseconds: 10) wait.
		string := '000' , (n radix: 3).
		size := string size.
		string := string copyFrom: size - 2 to: size.
		smallForthSource := self
			sourceOfNestedBeginWhileRepeatLoopTestFor: string.
		testMethodSource := self
			testMethodSourceOfNestedBeginWhileRepeatLoopFor: smallForthSource
			counter: string.
		self compileFromMethodSource: testMethodSource ] ] asJob run.
	self inform: 'Done'
]

{ #category : #'initialize - event' }
ForthLoopTest class >> initialize [ 
	self generateMissingTestsOnly
]

{ #category : #'code generation' }
ForthLoopTest class >> sourceOfNestedBeginWhileRepeatLoopTestFor: string [ 

	| source a b c |
	
	a := (string at: 1) digitValue.	
	b := (string at: 2) digitValue.
	c := (string at: 3) digitValue.
	
	source := ' variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ {2} < while 4 y @ 1+ y ! repeat 5
		x @ {1} <
	while 6
		0 z ! begin 7 z @ {3} < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	' format: { a . b . c }.
	^ source
]

{ #category : #'code generation' }
ForthLoopTest class >> swiftForthSourceCompacted: smallForthSource [
	^ (': test {1} ;' format: {smallForthSource}) withSeparatorsCompacted
]

{ #category : #'code generation' }
ForthLoopTest class >> testMethodSourceOfNestedBeginWhileRepeatLoopFor: smallForthSource counter: aCounter [ 
	| testMethodSource stream swiftForthSource |
	
	swiftForthSource := self swiftForthSourceCompacted: smallForthSource.
	
	stream := WriteStream on: String empty.
	
	stream << 'testNestedBeginWhileRepeatLoop_' << aCounter.
	stream cr. 
	
	stream cr. 
	stream nextPut: $".
	stream cr. 
	stream << swiftForthSource.
	stream cr. 
	stream nextPut: $".
	stream cr.
	
	stream cr.  
	stream << 'self assert: (forth eval: '''. 
	stream cr. 
	stream << smallForthSource.
	stream cr. 
	stream << ''''.
	stream cr. 
	stream << ('; stackCopy) equals: {1} reversed' format: { self calculateStackFromCounter: aCounter } ).
	
	testMethodSource := stream contents.
	
	^ testMethodSource
]

{ #category : #'as yet unclassified' }
ForthLoopTest class >> yArrayFrom: y [ 
	| array coll |
	
	coll := OrderedCollection empty.
	coll add: 2; add: 3.
	y timesRepeat: [ coll add: 4; add: 3 ].
	coll add: 5.
	array := coll asArray.
	^ array
]

{ #category : #'as yet unclassified' }
ForthLoopTest class >> zArrayFrom: z [ 
	| array coll |
	
	coll := OrderedCollection empty.
	coll add: 6; add: 7.
	z timesRepeat: [ coll add: 8; add: 7 ].
	coll add: 9.
	array := coll asArray.
	^ array
]

{ #category : #tests }
ForthLoopTest >> testBeginAgainLoop [
 
	forth maxLoopCount: 50.

	self should: [ forth eval: 'begin again' ] raise: ForthMaxLoopCountHasBeenReached
]

{ #category : #tests }
ForthLoopTest >> testBeginAgainLoopWithLeave [

	self assert: (forth eval: '1 begin 2 leave 3 again 4'; stack) equals: #(1 2 4) reversed
]

{ #category : #tests }
ForthLoopTest >> testBeginAgainLoopWithVariables [

	self assert: (forth eval: 'begin I I'' leave again'; stack) equals: #(1 0) reversed.
	self assert: (forth eval: 'begin begin J leave again leave again'; stack) equals: #(1) reversed.
	self assert: (forth eval: 'begin I I 2 > if leave then again'; stack) equals: #(1 2 3) reversed.
]

{ #category : #tests }
ForthLoopTest >> testBeginWhileRepeat [

	self assert: (forth eval: '1 begin 2 false while 3 repeat 4'; stack) equals: #(1 2 4) reversed
]

{ #category : #tests }
ForthLoopTest >> testBeginWhileRepeatWithMaxIterationLimit [
	
	forth maxLoopCount: 50.
	
	self should: [ forth eval: 'begin true while 99 repeat' ] raise: ForthMaxLoopCountHasBeenReached
]

{ #category : #tests }
ForthLoopTest >> testBeginWhileRepeatWithVariable [

	self assert: (forth eval: '
	variable x
	0 x !
	1 begin 2 x @ 1+ x ! x @ 5 < while 3 repeat 4
	'
	; stack) equals: #(1 2 3 2 3 2 3 2 3 2 4) reversed
]

{ #category : #tests }
ForthLoopTest >> testBeginWhileRepeatWithVariables [

	self assert: (forth eval: 'begin I 4 < while I repeat'; stack) equals: #(1 2 3) reversed.
	self assert: (forth eval: 'begin I 3 < while begin I 4 < while J I repeat repeat'; stack) equals: #(1 1 1 2 1 3 2 1 2 2 2 3) reversed.
]

{ #category : #tests }
ForthLoopTest >> testBegintUntilLoop [
	
	self assert: (forth eval: '1 2 3 4 5 6 7 8 9 begin 5 < until'; stack) equals: #(1 2 3) reversed.
	 
]

{ #category : #tests }
ForthLoopTest >> testBegintUntilLoopWithVariables [
	
	self assert: (forth eval: 'begin I I 5 > until'; stack) equals: #(1 2 3 4 5 6) reversed.
	 
]

{ #category : #tests }
ForthLoopTest >> testDoLoop [
	self assert: (forth eval: '3 0 do 9 loop'; stack) equals: #(9 9 9) reversed.
	self assert: (forth eval: '5 2 do 9 loop'; stack) equals: #(9 9 9) reversed.
	self assert: (forth eval: '-2 -5 do 9 loop'; stack) equals: #(9 9 9) reversed
	
	
]

{ #category : #tests }
ForthLoopTest >> testDoLoopWithIndex [
	self assert: (forth eval: '3 0 do i loop'; stack) equals: #(0 1 2) reversed
]

{ #category : #tests }
ForthLoopTest >> testDoLoopWithLeave [

	self assert: (forth eval: '1 10 0 do 2 leave 3 loop  4'; stack) equals: #(1 2 4) reversed.
	self assert: (forth eval: '1 10 0 do 2 leave 3 LOOP  4'; stack) equals: #(1 2 4) reversed.
	
]

{ #category : #tests }
ForthLoopTest >> testDoLoopWithLimitVariable [
	self assert: (forth eval: '3 0 do I'' I loop'; stack) equals: #(3 0 3 1 3 2) reversed.
	
]

{ #category : #tests }
ForthLoopTest >> testDoPlusLoopWithLeave [

	self assert: (forth eval: '1 10 0 do 2 leave 3 +loop  4'; stack) equals: #(1 2 4) reversed.
	self assert: (forth eval: '1 10 0 do 2 leave 3 +LOOP  4'; stack) equals: #(1 2 4) reversed.
	
]

{ #category : #tests }
ForthLoopTest >> testMaxLoopCountWithDoLoop [

	forth maxLoopCount: 1500.
	
	self should: [ forth eval: '10 0 do R> R> 1+ >R >R loop' ] raise: ForthMaxLoopCountHasBeenReached
]

{ #category : #tests }
ForthLoopTest >> testMaxLoopCountWithPlusDoLoop [

	forth maxLoopCount: 50.
	self should: [ forth eval: '10 0 do i R> R> 3 + >R >R 2 +loop' ] 
	raise: ForthMaxLoopCountHasBeenReached
]

{ #category : #tests }
ForthLoopTest >> testNegativeIncrementPlusDoLoop [
	self assert: (forth eval: '-20 0 do i -3 +loop'; stack) equals: #(0 -3 -6 -9 -12 -15 -18) reversed.

]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_000 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_001 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_002 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_010 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_011 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_012 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_020 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_021 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_022 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 0 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 0 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_100 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 6 7 9 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_101 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 6 7 8 7 9 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_102 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 6 7 8 7 8 7 9 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_110 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 6 7 9 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_111 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 6 7 8 7 9 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_112 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 6 7 8 7 8 7 9 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_120 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 6 7 9 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_121 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 6 7 8 7 9 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_122 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 1 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 1 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 6 7 8 7 8 7 9 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_200 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 6 7 9 2 3 5 6 7 9 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_201 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 6 7 8 7 9 2 3 5 6 7 8 7 9 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_202 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 0 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 5 6 7 8 7 8 7 9 2 3 5 6 7 8 7 8 7 9 2 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_210 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 6 7 9 2 3 4 3 5 6 7 9 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_211 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 6 7 8 7 9 2 3 4 3 5 6 7 8 7 9 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_212 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 1 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 5 6 7 8 7 8 7 9 2 3 4 3 5 6 7 8 7 8 7 9 2 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_220 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 0 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 6 7 9 2 3 4 3 4 3 5 6 7 9 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_221 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 1 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 6 7 8 7 9 2 3 4 3 4 3 5 6 7 8 7 9 2 3 4 3 4 3 5 10) reversed
]

{ #category : #'generated-test' }
ForthLoopTest >> testNestedBeginWhileRepeatLoop_222 [

"
: test variable x variable y variable z 1 0 x ! begin 2 0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5 x @ 2 < while 6 0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9 x @ 1+ x ! repeat 10 ;
"

self assert: (forth eval: '
 variable x variable y variable z
	1 0 x !
	begin 2 
		0 y ! begin 3 y @ 2 < while 4 y @ 1+ y ! repeat 5
		x @ 2 <
	while 6
		0 z ! begin 7 z @ 2 < while 8 z @ 1+ z ! repeat 9
		x @ 1+ x !
	repeat 10
	
'
; stack) equals: #(1 2 3 4 3 4 3 5 6 7 8 7 8 7 9 2 3 4 3 4 3 5 6 7 8 7 8 7 9 2 3 4 3 4 3 5 10) reversed
]

{ #category : #tests }
ForthLoopTest >> testNestedBegintUntilLoop [
	
	self assert: (forth eval: 
	'
		: gen 0 do i loop ;
	
		20 gen begin begin 12 < until 7 < until
	
	'
	; stack) equals: #(0 1 2 3 4 5) reversed
	 
]

{ #category : #tests }
ForthLoopTest >> testNestedDoLoop [

	self assert: (forth eval: '3 1 do 4 1 do i j loop loop'; stack) equals: #(1 1 2 1 3 1 1 2 2 2 3 2) reversed
]

{ #category : #tests }
ForthLoopTest >> testPlusDoLoop [
	self assert: (forth eval: '20 0 do i 3 +loop'; stack) equals: #(0 3 6 9 12 15 18) reversed.

]
