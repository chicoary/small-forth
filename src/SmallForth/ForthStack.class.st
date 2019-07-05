"
I am a subclass of Stack that overrides pop and top for reraise a substitute exception class.
"
Class {
	#name : #ForthStack,
	#superclass : #Stack,
	#category : #'SmallForth-Core'
}

{ #category : #accessing }
ForthStack >> at: index [
	^ [ super at: index ] on: SubscriptOutOfBounds do: [ ForthStackUnderflow new signal ]
]

{ #category : #removing }
ForthStack >> pop [
	^ [ super pop ] on: CollectionIsEmpty do: [ ForthStackUnderflow new signal ]
]

{ #category : #accessing }
ForthStack >> swap: i with: j [
	^ [ super swap: i with: j ] on: SubscriptOutOfBounds do: [ ForthStackUnderflow new signal ]
]

{ #category : #accessing }
ForthStack >> top [
	^ [ super top ] on: CollectionIsEmpty do: [ ForthStackUnderflow new signal ]
]
