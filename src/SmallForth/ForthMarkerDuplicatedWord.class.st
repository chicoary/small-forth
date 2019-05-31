Class {
	#name : #ForthMarkerDuplicatedWord,
	#superclass : #Error,
	#category : #'SmallForth-Exceptions'
}

{ #category : #'as yet unclassified' }
ForthMarkerDuplicatedWord class >> marker: word [ 
	^ self new messageText: word
]
