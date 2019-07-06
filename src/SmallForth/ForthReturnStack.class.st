"
See ForthStack comment.
"
Class {
	#name : #ForthReturnStack,
	#superclass : #ForthStack,
	#category : #'SmallForth-Core'
}

{ #category : #signalling }
ForthReturnStack >> signalStackUnderflow [
	ForthReturnStackUnderflow new signal
]
