"
See ForthStack comment.
"
Class {
	#name : #ForthParameterStack,
	#superclass : #ForthStack,
	#category : #'SmallForth-Core'
}

{ #category : #signalling }
ForthParameterStack >> signalStackUnderflow [
	ForthParameterStackUnderflow new signal
]
