Class {
	#name : #ForthLoopTest,
	#superclass : #ForthInterpreterTest,
	#category : #'SmallForth-Tests-Core'
}

{ #category : #tests }
ForthLoopTest >> testBeginAgainLoop [
 
	forth maxLoopCount: 50.

	self should: [ forth eval: 'begin again' ] raise: ForthMaxLoopCountHasBeenReached
]

{ #category : #tests }
ForthLoopTest >> testBegintUntilLoop [
	
	self assert: (forth eval: '1 2 3 4 5 6 7 8 9 begin 5 < until'; stackCopy) equals: #(1 2 3) reversed.
	 
]

{ #category : #tests }
ForthLoopTest >> testDoLoop [
	self assert: (forth eval: '3 0 do 9 loop'; stackCopy) equals: #(9 9 9) reversed.
	self assert: (forth eval: '5 2 do 9 loop'; stackCopy) equals: #(9 9 9) reversed.
	self assert: (forth eval: '-2 -5 do 9 loop'; stackCopy) equals: #(9 9 9) reversed
	
	
]

{ #category : #tests }
ForthLoopTest >> testDoLoopWithIndex [
	self assert: (forth eval: '3 0 do i loop'; stackCopy) equals: #(0 1 2) reversed
]

{ #category : #tests }
ForthLoopTest >> testMaxLoopCount [
	self flag: #implementing. "Testar outros loops que não o BEGIN AGAIN"
	self flag: #testing. 
	forth maxLoopCount: 50.
	self should: [ forth eval: '10 0 do i . R> R> 1+ >R >R loop' ] raise: ForthMaxLoopCountHasBeenReached
]

{ #category : #tests }
ForthLoopTest >> testNegativeIncrementPlusDoLoop [
	self assert: (forth eval: '-20 0 do i -3 +loop'; stackCopy) equals: #(0 -3 -6 -9 -12 -15 -18) reversed.

]

{ #category : #tests }
ForthLoopTest >> testNestedBegintUntilLoop [
	
	self assert: (forth eval: 
	'
		: gen 0 do i loop ;
	
		20 gen begin begin 12 < until 7 < until
	
	'
	; stackCopy) equals: #(0 1 2 3 4 5) reversed
	 
]

{ #category : #tests }
ForthLoopTest >> testNestedDoLoop [
	self assert: (forth eval: '3 1 do 4 1 do i j loop loop'; stackCopy) equals: #(1 1 2 1 3 1 1 2 2 2 3 2) reversed
]

{ #category : #tests }
ForthLoopTest >> testPlusDoLoop [
	self assert: (forth eval: '20 0 do i 3 +loop'; stackCopy) equals: #(0 3 6 9 12 15 18) reversed.

]
