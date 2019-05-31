Class {
	#name : #ForthWordAlreadyDefined,
	#superclass : #Error,
	#category : #'SmallForth-Exceptions'
}

{ #category : #'as yet unclassified' }
ForthWordAlreadyDefined class >> word: aString [ 
	^ self new messageText: aString 
]
