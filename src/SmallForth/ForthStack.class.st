"
I am a subclass of Stack that overrides some methods for reraise a substitute exception class.
"
Class {
	#name : #ForthStack,
	#superclass : #Stack,
	#category : #'SmallForth-Core'
}

{ #category : #accessing }
ForthStack >> at: index [
	^ [ super at: index ]
		on: SubscriptOutOfBounds
		do: [ self signalStackUnderflow ]
]

{ #category : #removing }
ForthStack >> pop [
	^ [ super pop ] on: CollectionIsEmpty do: [ self signalStackUnderflow ]
]

{ #category : #signalling }
ForthStack >> signalStackUnderflow [
	self subclassResponsibility 
]

{ #category : #accessing }
ForthStack >> swap: i with: j [
	^ [ super swap: i with: j ] on: SubscriptOutOfBounds do: [ self signalStackUnderflow ]
]

{ #category : #accessing }
ForthStack >> top [
	^ [ super top ] on: CollectionIsEmpty do: [ self signalStackUnderflow ]
]
