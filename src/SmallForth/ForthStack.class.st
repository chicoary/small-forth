"
I am a subclass of Stack that overrides pop and top for reraise a substitute exception class.
"
Class {
	#name : #ForthStack,
	#superclass : #Stack,
	#category : #'SmallForth-Core'
}

{ #category : #removing }
ForthStack >> pop [
	^ [ super pop ] on: CollectionIsEmpty do: [ ForthStackUnderflow new signal ]
]

{ #category : #accessing }
ForthStack >> top [
	^ [ super top ] on: CollectionIsEmpty do: [ ForthStackUnderflow new signal ]
]
