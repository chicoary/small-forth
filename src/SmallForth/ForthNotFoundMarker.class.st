Class {
	#name : #ForthNotFoundMarker,
	#superclass : #Error,
	#category : #'SmallForth-Exceptions'
}

{ #category : #'as yet unclassified' }
ForthNotFoundMarker class >> marker: word [ 
	^ self new messageText: word
]
