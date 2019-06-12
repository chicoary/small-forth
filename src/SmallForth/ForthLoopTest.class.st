Class {
	#name : #ForthLoopTest,
	#superclass : #ForthInterpreterTest,
	#category : #'SmallForth-Tests-Core'
}

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
ForthLoopTest >> testNestedDoLoop [
	self assert: (forth eval: '3 1 do 4 1 do i j loop loop'; stackCopy) equals: #(1 1 2 1 3 1 1 2 2 2 3 2) reversed
]
