Class {
	#name : #ForthNeedsTranscriptTest,
	#superclass : #ForthInterpreterTest,
	#category : #'SmallForth-Tests-Core'
}

{ #category : #running }
ForthNeedsTranscriptTest >> setUp [ 
	super setUp.
	skipTests := true
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testAbort [
	
	self useTranscriptOn: [
		forth eval: 'false abort ." Must see me"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
	]
		
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testAbortWithMessage [
	
	self useTranscriptOn: [
	
	forth eval: 'false abort" Message" ." No message"'.
	self assert: forth stackCopy isEmpty.
	self assert: (UIManager default confirm: 'Do you see an ''No message'' on Transcript?').
	
	]	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testAbortWithMessage2 [
	
	self useTranscriptOn:[
	self should: [ forth eval: 'true abort" Message" ." Must not see me"' ] raise: ForthAbort.
	self assert: forth stackCopy isEmpty.
	self assert: (UIManager default confirm: 'Do you see an ''Message'' only on Transcript?').

	]
		
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testBackSlash [
		
		self useTranscriptOn:[
		forth eval: '
		
		42 emit 
		\ I am a comment
		." Comment"
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''*Comment'' on Transcript?').
		
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testChar [
		
		self useTranscriptOn:[
		forth eval: 'char * emit'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an * on Transcript?').
		
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testComment [
		
		self useTranscriptOn:[
		forth eval: '42 emit ( I am a comment) ." Comment"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''*Comment'' on Transcript?').
		
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testCr [
		
		self useTranscriptOn:[
		forth eval: '." abcd" cr ." efg"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''abcd'' and ''efg'' in two lines on Transcript?').
		
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testDot [
	
	self useTranscriptOn:[
	forth eval: '7 dup * .'.
	self assert: [ forth stackCopy isEmpty ].
	self assert: (UIManager default confirm: 'Do you see an 49 on Transcript?').
	 
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testDot2 [
	
	self useTranscriptOn:[
	forth eval: '77 42 . .'.
	self assert: [ forth stackCopy isEmpty ].
	self assert: (UIManager default confirm: 'Do you see an 42 77 on Transcript?').

	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testDotQuote [
		
		self useTranscriptOn:[
		forth eval: '42 emit ." Hello    World!"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''*Hello    World!'' on Transcript?').
		 
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testDotQuoteWithEmptyString [
		
		self useTranscriptOn:[
		forth eval: '." "'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you ''see'' an ''empty string'' on Transcript?').
		
	]
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testDotS [
	
	self useTranscriptOn: [
		
		forth eval: '1 2 3 .s'.
		self assert: forth stackCopy size equals: 3.
		self assert: forth stackCopy equals: #(3 2 1).
		self assert: (UIManager default confirm: 'Do you see an ''<3> 1 2 3'' on Transcript?').

	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testEmit [
		
		self useTranscriptOn:[
		forth eval: '42 emit'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an * on Transcript?').

	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testForget [
		
		self useTranscriptOn:[
		forth eval: '
		
			: greet ." Dummy." ;
			: greet ." Dummy2." ;
			: greet ." Hello, I speak Forth." ;
			: greet ." Hi there!" ;
			forget greet
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Hello, I speak Forth.'' in on Transcript?').

	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfElseThenWithComment [
	
	self useTranscriptOn:[
		forth eval: 'false if 1 ( I have an else and a then in the middle) else ." Must (with else or then) see me" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must (with else or then) see me'' on Transcript?').

	
	
	
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfElseThenWithComment2 [
	
	self useTranscriptOn:[
		forth eval: 'true if ." Must see me" else 2 ( I have an else and a then in the middle) then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').

	
	
	
	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfElseThenWithDotQuote [
	
	self useTranscriptOn:[
		forth eval: 'false if ." I have an else and a then in the middle" else ." Must see me" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').

	
	
	
	]
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfElseThenWithDotQuote2 [
	
	self useTranscriptOn:[
		forth eval: 'true if ." Must see me" else ." I have an else and a then in the middle" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').

	
	
	
	]
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfElseThenWithLineComment [
	
	self useTranscriptOn:[
		forth eval: 'false if 1 \ I have an else and a then in the middle
				else ." Must see me" then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		
	
	]
	
	
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfElseThenWithLineComment2 [
	
	self useTranscriptOn:[
		forth eval: 'true if ." Must see me" 
				else \ I have an else and a then in the middle
				then'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').

	]
	
	
	
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfThenWithComment [
	
	self useTranscriptOn:[
		forth eval: 'false if 1 ( I have an else and a then in the middle) then ." Must see me"'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').
		
	]
	
	
	
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfThenWithDotQuote [
	
	self useTranscriptOn:[
		forth eval: 'false if ." I have an else and a then in the middle" then ." Must see me"'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').

	]
	
	
	
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testIfThenWithLineComment [
	
	self useTranscriptOn:[
		forth eval: 'false if 1 
				
				\ I have an else and a then in the middle
				
				then ." Must see me"'.
		self assert: (UIManager default confirm: 'Do you see an ''Must see me'' on Transcript?').

	
	]
	
	
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testMarker [
		
		self useTranscriptOn:[
		forth eval: '
		
			: greet ." Dummy." ;
			: greet ." Hello, I speak Forth." ;
			marker -work
			: greet ." Hi there!" ;
			-work
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Hello, I speak Forth.'' in on Transcript?').

	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testSpace [
		
		self useTranscriptOn:[
		forth eval: '." abcd" space space space ." efg"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''abcd   efg'' on Transcript?').

	]
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testSpaces [
		
		self useTranscriptOn:[
		forth eval: '." abcd" 3 spaces ." efg"'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''abcd   efg'' on Transcript?').

	]
	
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testTranscript [
		
		self useTranscriptOn:[
		
		forth eval: '42 emit'.
		
		self assert: (UIManager default confirm: 'Do not you see weird contents on Transcript?').

	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testTwoMarker [
		
		self useTranscriptOn:[
		forth eval: '
		
			: greet ." Dummy." ;
			marker -work2
			: greet ." Hello, I speak Forth." ;
			marker -work
			: greet ." Hi there!" ;
			-work2
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Dummy.'' in on Transcript?').

	
	]
]

{ #category : #tests }
ForthNeedsTranscriptTest >> testTwoMarker2 [
		
		self useTranscriptOn:[
		forth eval: '
		
			: greet ." Dummy." ;
			marker -work2
			: greet ." Hello, I speak Forth." ;
			marker -work
			: greet ." Hi there!" ;
			-work
			greet
		
		'.
		self assert: forth stackCopy isEmpty.
		self assert: (UIManager default confirm: 'Do you see an ''Hello, I speak Forth.'' in on Transcript?').

	
	]
]

{ #category : #'test support' }
ForthNeedsTranscriptTest >> useTranscriptOn: aBlockClosure [
	skipTests
		ifTrue: [ self inform: 'Skiping...'. self skip ]
		ifFalse: [ Transcript openIfNone.
			Transcript clear.
			aBlockClosure value.
			self closeTranscriptWindow ]
]
