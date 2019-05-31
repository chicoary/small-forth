Class {
	#name : #ForthMissingWord,
	#superclass : #Error,
	#category : #'SmallForth-Exceptions'
}

{ #category : #'as yet unclassified' }
ForthMissingWord class >> messageText: aString [ 
	^ self new messageText: aString 
]
