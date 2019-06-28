Class {
	#name : #ForthIfElseThenTest,
	#superclass : #ForthInterpreterTest,
	#classInstVars : [
		'generateAll'
	],
	#category : #'SmallForth-Tests-Core'
}

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateAll [
	generateAll := true.
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateExprFor: n withTemplate: template andSize: size [
	| count array expr binary |
	binary := self lead: n withZerosToSize: size.
	array := OrderedCollection empty.
	count := 0.
	binary
		do: [ :char | 
			count := count + 1.
			count <= (size / 2)
				ifTrue: [ array
						add:
							(char = $1
								ifTrue: [ #true ]
								ifFalse: [ #false ]) ]
				ifFalse: [ array
						add:
							(char = $1
								ifTrue: [ #else ]
								ifFalse: [ String empty ]) ] ].
	expr := template format: array.
	^ expr
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateIfsTests [
	<script> 
	"self generateAll."
	self generateMissingTestsOnly.
	[ :job | job title: 'Generating...' translated.
	self generateTestsWithOneIf.
	job progress: 0.25.
	self generateTestsWithTwoIfs.
	job progress: 0.50.
	self generateTestsWithTwoIfs2.
	job progress: 0.75.
	self generateTestsWithThreeIfs.
	job progress: 1.00. ] asJob run
]

{ #category : #initialization }
ForthIfElseThenTest class >> generateMissingTestsOnly [
	generateAll := false
]

{ #category : #tests }
ForthIfElseThenTest class >> generateNestedIfsWith2Ifs [
	<script>
	| expr2 |
	Transcript
		clear;
		openIfNone.
	0 to: 15 do: [ :n | 
		| expr |
		expr := self generateNestedIfsWith2IfsFor: n.
		expr2 := self generateNestedIfsWith2IfsFor_2: n.
		
		Transcript cr; show: $#; show: n; show: $:; space; show: expr.
		Transcript cr; show: $#; show: n; show: $:; space; show: expr2
	]
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateNestedIfsWith2IfsFor: n [
	| exprTemplate |
	exprTemplate := '{1} if {2} if {3} then {4} then'.
	^ self generateNestedIfsWith2IfsFor: n with: exprTemplate
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateNestedIfsWith2IfsFor: n with: exprTemplate [
	| count array expr binary |
	binary := self lead: n withZerosToSize: 4.
	array := OrderedCollection empty.
	count := 0.
	binary
		do: [ :char | 
			count := count + 1.
			count <= 3
				ifTrue: [ array
						add:
							(char = $1
								ifTrue: [ #true ]
								ifFalse: [ #false ]) ]
				ifFalse: [ array
						add:
							(char = $1
								ifTrue: [ #else ]
								ifFalse: [ String empty ]) ] ].
	expr := exprTemplate format: array.
	^ expr
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateNestedIfsWith2IfsFor_2: n [ 
	| exprTemplate |
	exprTemplate := '{1} if  {3} {2} if {4} then then'.
	^ self generateNestedIfsWith2IfsFor: n with: exprTemplate
]

{ #category : #tests }
ForthIfElseThenTest class >> generateNestedIfsWith3Ifs [
	<script>
	Transcript
		clear;
		openIfNone.
	0 to: 63 do: [ :n | 
		| expr |
		expr := self generateNestedIfsWith3IfsFor: n.
		Transcript cr; show: $#; show: n; show: $:; space; show: expr ]
]

{ #category : #tests }
ForthIfElseThenTest class >> generateNestedIfsWith3IfsFor: n [
	| count array expr binary exprTemplate |
	exprTemplate := '{1} if 1 {2} if 2 {4} 3 then 4 {5} 5 {3} if 6 {6} 7 then 8 then 9'.
	binary := self lead: n withZerosToSize: 6.
	array := OrderedCollection empty.
	count := 0.
	binary
		do: [ :char | 
			count := count + 1.
			count <= 3
				ifTrue: [ array
						add:
							(char = $1
								ifTrue: [ #true ]
								ifFalse: [ #false ]) ]
				ifFalse: [ array
						add:
							(char = $1
								ifTrue: [ #else ]
								ifFalse: [ String empty ]) ] ].
	expr := exprTemplate format: array.
	^ expr
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateSourceFor2: anInteger withTemplate: aString andSize: anInteger3 [
	| expr |
	expr := self
		generateExprFor: anInteger
		withTemplate: aString
		andSize: anInteger3.
	^ self sourceFromExpr2: expr with: anInteger size: anInteger3
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateSourceFor: n withTemplate: template andSize: size [
	| expr |
	expr := self generateExprFor: n withTemplate: template andSize: size.
	^ self sourceFromExpr: expr with: n size: size
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateTestMethodFromSource: source [
	(generateAll
		or: [ (self canUnderstand: source asInstanceSideBehaviorName asSymbol) not ])
		ifTrue: [ 
			self compile: source classified: 'generated-test' ]
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateTestsWithOneIf [
	<script>
	| template numberOfIfs size |
	numberOfIfs := 1.
	size := 2 * numberOfIfs.
	template := '{1} if 1 {2} 2 then 3'.
	[ :job | 
	| max |
	job title: 'Generating tests with one if...' translated.
	max := (2 raisedTo: size) - 1.
	0 to: max do: [ :n | 
		| source |
		job progress: n / max asFloat.
		source := self
			generateSourceFor: n
			withTemplate: template
			andSize: size.
		self generateTestMethodFromSource: source ] ] asJob run
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateTestsWithThreeIfs [
	<script>
	| template numberOfIfs size |
	numberOfIfs := 3.
	size := 2 * numberOfIfs.
	template := '{1} if 1 {2} if 2 {4} 3 then 4 {5} 5 {3} if 6 {6} 7 then 8 then 9'.
	[ :job | 
	| max | job title: 'Generating tests with three if...' translated.
	max := (2 raisedTo: size) - 1.
	0 to: max do: [ :n | 
		| source | job progress: n/max asFloat.
		source := self
			generateSourceFor: n
			withTemplate: template
			andSize: size.
		self generateTestMethodFromSource: source ]] asJob run
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateTestsWithTwoIfs [
	<script>
	| template numberOfIfs size |
	numberOfIfs := 2.
	size := 2 * numberOfIfs.
	template := '{1} if 1 {2} if 2 {3} 3 then 4 {4} 5 then 6'.
	[ :job | 
	| max | job title: 'Generating tests with two if...' translated.
	max := (2 raisedTo: size) - 1.
	0 to: max do: [ :n | 
		| source | job progress: n/max asFloat.
		source := self
			generateSourceFor: n
			withTemplate: template
			andSize: size.
		self generateTestMethodFromSource: source ]] asJob run
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> generateTestsWithTwoIfs2 [
	| template numberOfIfs size |
	numberOfIfs := 2.
	size := 2 * numberOfIfs.
	template := '{1} if 1 {3} 2 {2} if 3 {4} 4 then 5 then 6'.
	0 to: (2 raisedTo: size) - 1 do: [ :n | 
		| source |
		source := self
			generateSourceFor2: n
			withTemplate: template
			andSize: size.
		self generateTestMethodFromSource: source ]
]

{ #category : #initialization }
ForthIfElseThenTest class >> initialize [ 
	self generateMissingTestsOnly
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> lead: number withZerosToSize: size [ 
	| binary mask |
	binary := number radix: 2.
	mask := ''. size timesRepeat: [ mask := mask, '0' ].
	^ (mask, binary) copyFrom: 1 + binary size to: size + binary size
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> sourceFromExpr2:  expr with: n size: size [
	^ 'testIfElseThenX{1}{2} 
		"
		SwiftForth
		: test {3} .s ;
		"
		self assert: (forth eval: ''{3}''; stackCopy) 
		equals: #() reversed' format: { size/2. n. expr }
]

{ #category : #'code generation' }
ForthIfElseThenTest class >> sourceFromExpr: expr with: n size: size [

	^ 'testIfElseThen{1}{2} 
		"
		SwiftForth
		: test {3} .s ;
		"
		self assert: (forth eval: ''{3}''; stackCopy) 
		equals: #() reversed' format: { size/2. n. expr }
]

{ #category : #tests }
ForthIfElseThenTest >> testFalseIfElseThen [ 
	
	self assert: (forth eval: 'false if 1 else 2 then 3'; stackCopy) equals: #(2 3) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testFalseIfFalseIfThenThen [ 
	
	self assert: (forth eval: 'false if 1 false if 2 then 3 then 4'; stackCopy) equals: #(4) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testFalseIfThen [ 
	
	self assert: (forth eval: 'false if 1 then 2'; stackCopy) equals: #(2) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testFalseIfTrueIfThenThen [ 
	
	self assert: (forth eval: 'false if 1 true if 2 then 3 then 4'; stackCopy) equals: #(4) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen [ 
	
	self assert: (forth eval: 'false if 1 2 3 swap else 4 5 6 dup then'; stackCopy) equals: #(6 6 5 4).
	self assert: forth stackCopy size equals: 4.
	self assert: (forth eval: 'true if 1 2 3 swap else 4 5 6 dup then'; stackCopy) equals: #(2 3 1).
	self assert: forth stackCopy size equals: 3.
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen10 [ 
		"
		SwiftForth
		: test drop false if 1  2 then 3 .s ;
		"
		self assert: (forth eval: 'false if 1  2 then 3'; stackCopy) 
		equals: #(3) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen11 [ 
		"
		SwiftForth
		: test drop false if 1 else 2 then 3 .s ;
		"
		self assert: (forth eval: 'false if 1 else 2 then 3'; stackCopy) 
		equals: #(2 3) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen12 [ 
		"
		SwiftForth
		: test drop true if 1  2 then 3 .s ;
		"
		self assert: (forth eval: 'true if 1  2 then 3'; stackCopy) 
		equals: #(1 2 3) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen13 [ 
		"
		SwiftForth
		: test drop true if 1 else 2 then 3 .s ;
		"
		self assert: (forth eval: 'true if 1 else 2 then 3'; stackCopy) 
		equals: #(1 3) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen20 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4  5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2  3 then 4  5 then 6'; stackCopy) 
		equals: #(6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen21 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4 else 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2  3 then 4 else 5 then 6'; stackCopy) 
		equals: #(5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen210 [ 
		"
		SwiftForth
		: test drop true if 1 false if 2 else 3 then 4  5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4  5 then 6'; stackCopy) 
		equals: #(1 3 4 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen211 [ 
		"
		SwiftForth
		: test drop true if 1 false if 2 else 3 then 4 else 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4 else 5 then 6'; stackCopy) 
		equals: #(1 3 4 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen212 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2  3 then 4  5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4  5 then 6'; stackCopy) 
		equals: #(1 2 3 4 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen213 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2  3 then 4 else 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4 else 5 then 6'; stackCopy) 
		equals: #(1 2 3 4 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen214 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2 else 3 then 4  5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4  5 then 6'; stackCopy) 
		equals: #(1 2 4 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen215 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2 else 3 then 4 else 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4 else 5 then 6'; stackCopy) 
		equals: #(1 2 4 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen22 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2 else 3 then 4  5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4  5 then 6'; stackCopy) 
		equals: #(6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen23 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2 else 3 then 4 else 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4 else 5 then 6'; stackCopy) 
		equals: #(5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen24 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4  5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 true if 2  3 then 4  5 then 6'; stackCopy) 
		equals: #(6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen25 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4 else 5 then 6 .s ;
		"
		

		
		self assert: (forth eval: 'false if 1 true if 2  3 then 4 else 5 then 6'; stackCopy) 
		equals: #(5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen26 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4  5 then 6 .s ;
		"
		
	
		
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4  5 then 6'; stackCopy) 
		equals: #(6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen27 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4 else 5 then 6 .s ;
		"
		
		
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4 else 5 then 6'; stackCopy) 
		equals: #(5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen28 [ 
		"
		SwiftForth
		: test drop true if 1 false if 2  3 then 4  5 then 6 .s ;
		"
		
		
		
		self assert: (forth eval: 'true if 1 false if 2  3 then 4  5 then 6'; stackCopy) 
		equals: #(1 4 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen29 [ 
		"
		SwiftForth
		: test drop true if 1 false if 2  3 then 4 else 5 then 6 .s ;
		"
		
		
		self assert: (forth eval: 'true if 1 false if 2  3 then 4 else 5 then 6'; stackCopy) 
		equals: #(1 4 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen30 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
	
		
		self assert: (forth eval: 'false if 1 false if 2  3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen31 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		

		
		self assert: (forth eval: 'false if 1 false if 2  3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen310 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 false if 2  3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(5 6 7 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen311 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		

		
		self assert: (forth eval: 'false if 1 false if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(5 6 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen312 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2 else 3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"
		
	
		
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen313 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"
		
	
		
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen314 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"
		
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(5 6 7 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen315 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(5 6 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen316 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
		
		self assert: (forth eval: 'false if 1 true if 2  3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen317 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		
			
		self assert: (forth eval: 'false if 1 true if 2  3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen318 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"
		
		self assert: (forth eval: 'false if 1 true if 2  3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(5 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen319 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"

			
		self assert: (forth eval: 'false if 1 true if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(5 7 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen32 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 false if 2  3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(5 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen320 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"

		
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen321 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen322 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(5 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen323 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(5 7 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen324 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 true if 2  3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen325 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 true if 2  3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen326 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2  3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 true if 2  3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(5 6 7 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen327 [ 
		"
		SwiftForth
		: test false if 1 true if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 true if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(5 6 8 9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen328 [ 
		"
		SwiftForth
		: test false if 1 true if 2 else 3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen329 [ 
		"
		SwiftForth
		: test drop false if 1 true if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen33 [ 
		"
		SwiftForth
		: test false if 1 false if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen330 [ 
		"
		SwiftForth
		: test false if 1 true if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen331 [ 
		"
		SwiftForth
		: test false if 1 true if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 true if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen332 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen333 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen334 [ 
		"
		SwiftForth
		: test drop true if 1 false if 2  3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"
						
		self assert: (forth eval: 'true if 1 false if 2  3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #(1 4 9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen335 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen336 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen337 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen338 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen339 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen34 [ 
		"
		SwiftForth
		: test false if 1 false if 2 else 3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen340 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen341 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen342 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen343 [ 
		"
		SwiftForth
		: test true if 1 false if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen344 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen345 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen346 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen347 [ 
		"
		SwiftForth
		: test true if 1 false if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 false if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen348 [ 
		"
		SwiftForth
		: test true if 1 true if 2  3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen349 [ 
		"
		SwiftForth
		: test true if 1 true if 2  3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen35 [ 
		"
		SwiftForth
		: test false if 1 false if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen350 [ 
		"
		SwiftForth
		: test true if 1 true if 2  3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen351 [ 
		"
		SwiftForth
		: test true if 1 true if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen352 [ 
		"
		SwiftForth
		: test true if 1 true if 2 else 3 then 4  5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4  5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen353 [ 
		"
		SwiftForth
		: test true if 1 true if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4  5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen354 [ 
		"
		SwiftForth
		: test true if 1 true if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen355 [ 
		"
		SwiftForth
		: test true if 1 true if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen356 [ 
		"
		SwiftForth
		: test true if 1 true if 2  3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen357 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2  3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'true if 1 true if 2  3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(1 2 3 4 5 6 8 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen358 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2  3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'true if 1 true if 2  3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(1 2 3 4 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen359 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2  3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(1 2 3 4 9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen36 [ 
		"
		SwiftForth
		: test false if 1 false if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4 else 5 false if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen360 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2 else 3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(1 2 4 5 6 7 8 9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen361 [ 
		"
		SwiftForth
		: test true if 1 true if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen362 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #(1 2 4 9) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen363 [ 
		"
		SwiftForth
		: test drop true if 1 true if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'true if 1 true if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(1 2 4 9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen37 [ 
		"
		SwiftForth
		: test false if 1 false if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2 else 3 then 4 else 5 false if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThen38 [ 
		"
		SwiftForth
		: test false if 1 false if 2  3 then 4  5 true if 6  7 then 8 then 9 .s ;
		"
		self assert: (forth eval: 'false if 1 false if 2  3 then 4  5 true if 6  7 then 8 then 9'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThen39 [ 
		"
		SwiftForth
		: test drop false if 1 false if 2  3 then 4  5 true if 6 else 7 then 8 then 9 .s ;
		"

		self assert: (forth eval: 'false if 1 false if 2  3 then 4  5 true if 6 else 7 then 8 then 9'; stackCopy) 
		equals: #(9) reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX20 [ 
		"
		SwiftForth
		: test false if 1  2 false if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1  2 false if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX21 [ 
		"
		SwiftForth
		: test false if 1  2 false if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1  2 false if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX210 [ 
		"
		SwiftForth
		: test true if 1 else 2 false if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 else 2 false if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX211 [ 
		"
		SwiftForth
		: test true if 1 else 2 false if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 else 2 false if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX212 [ 
		"
		SwiftForth
		: test true if 1  2 true if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1  2 true if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX213 [ 
		"
		SwiftForth
		: test true if 1  2 true if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1  2 true if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX214 [ 
		"
		SwiftForth
		: test true if 1 else 2 true if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 else 2 true if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX215 [ 
		"
		SwiftForth
		: test true if 1 else 2 true if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1 else 2 true if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX22 [ 
		"
		SwiftForth
		: test false if 1 else 2 false if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 else 2 false if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX23 [ 
		"
		SwiftForth
		: test false if 1 else 2 false if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 else 2 false if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX24 [ 
		"
		SwiftForth
		: test false if 1  2 true if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1  2 true if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX25 [ 
		"
		SwiftForth
		: test false if 1  2 true if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1  2 true if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #'generated-test' }
ForthIfElseThenTest >> testIfElseThenX26 [ 
		"
		SwiftForth
		: test false if 1 else 2 true if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 else 2 true if 3  4 then 5 then 6'; stackCopy) 
		equals: #() reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThenX27 [ 
		"
		SwiftForth
		: test drop false if 1 else 2 true if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'false if 1 else 2 true if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #(2 3 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThenX28 [ 
		"
		SwiftForth
		: test drop true if 1  2 false if 3  4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1  2 false if 3  4 then 5 then 6'; stackCopy) 
		equals: #(1 2 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfElseThenX29 [ 
		"
		SwiftForth
		: test drop true if 1  2 false if 3 else 4 then 5 then 6 .s ;
		"
		self assert: (forth eval: 'true if 1  2 false if 3 else 4 then 5 then 6'; stackCopy) 
		equals: #(1 2 4 5 6) reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testIfThen [ 
	
	self assert: (forth eval: 'false if 1 2 3 swap then 4 5 6'; stackCopy) equals: #(6 5 4).
	self assert: forth stackCopy size equals: 3.
	self assert: (forth eval: 'true if 1 2 3 swap then 4 5 6'; stackCopy) equals: #(6 5 4 2 3 1).
	self assert: forth stackCopy size equals: 6.
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testIfThenElse [ 
	self should: [forth eval: 'false if 1 then 2 else'] raise: ForthUnpairingIfElseThen
	
]

{ #category : #tests }
ForthIfElseThenTest >> testIfTwoElseThen [ 
	self shouldnt: [forth eval: 'false if 1 else 2 then'] raise: ForthUnpairingIfElseThen.
	self should: [forth eval: 'false if 1 else 2 else 3 then'] raise: ForthUnpairingIfElseThen.
	self should: [forth eval: 'false if 1 else false if 2 else 3 then 4'] raise: ForthUnpairingIfElseThen  
	
]

{ #category : #tests }
ForthIfElseThenTest >> testIfWithoutThen [ 
	
	self should: [forth eval: 'true if 1 2 3 swap']  raise: ForthUnpairingIfElseThen.
	self should: [forth eval: 'false if 1 2 3 swap'] raise: ForthUnpairingIfElseThen
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen [ 
	
	self assert: (forth eval: 'false if false if 1 2 3 else 4 5 6 then 7 8 9 else 10 11 12 then'; 
	stackCopy) equals: #(12 11 10).
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen0 [
	| expr stack |
	
	"
	ForthInterpreterTest generateNestedIfsWith3IfsFor: 0
	"
	
	expr := 'false if 1 false if 2  3 then 4  5 false if 6  7 then 8 then 9'.
	stack := #(9).
	
	self assert: (forth eval: expr; stackCopy) equals: stack reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen1 [
	| expr stack |
	
	"
	ForthInterpreterTest generateNestedIfsWith3IfsFor: 1
	"
	
	expr := 'false if 1 false if 2  3 then 4  5 false if 6 else 7  then 8 then 9'.
	stack := #(9).
	
	self assert: (forth eval: expr; stackCopy) equals: stack reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen2 [ 
	
	self assert: (forth eval: 'false if true if 1 2 3 else 4 5 6 then 7 8 9 else 10 11 12 then'; 
	stackCopy) equals: #(12 11 10).
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen3 [
	
	self assert: (forth eval: 'true if false if 1 2 3 else 4 5 6 then 7 8 9 else 10 11 12 then'; 
	stackCopy) equals: #(4 5 6 7 8 9) reverse.
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen4 [
	
	self assert: (forth eval: 'true if true if 1 2 3 else 4 5 6 then 7 8 9 else 10 11 12 then'; 
	stackCopy) equals: #(1 2 3 7 8 9) reverse.
	
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen5 [ 
	| expr | 
	
	expr :=  '
	
		{1} if 1 else
		{2} if 2 else
		{3} if 3 else
		       4
		then then then
	
	'.
	
	self assert: (forth eval: (expr format: #(true false false)); top) equals: 1.
	self assert: (forth eval: (expr format: #(false true false)); top) equals: 2.
	self assert: (forth eval: (expr format: #(false false true)); top) equals: 3.
	self assert: (forth eval: (expr format: #(false false false)); top) equals: 4.
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen6 [
	| expr | 
	
	expr :=  '
	
	{1}	 if 1 else 2 
	{2} if 3 else 4 
	then 5 then 6
	
	'.
	
	self assert: (forth eval: (expr format: #(false false)); stackCopy) equals: #(2 4 5 6) reversed.
	self assert: (forth eval: (expr format: #(false true)); stackCopy) equals: #(2 3 5 6) reversed.
	self assert: (forth eval: (expr format: #(true false)); stackCopy) equals: #(1 6) reversed.
	self assert: (forth eval: (expr format: #(true true)); stackCopy) equals: #(1 6) reversed.
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen62 [
	| expr stack |
	
	"
	ForthInterpreterTest generateNestedIfsWith3IfsFor: 62
	"
	
	expr := 'true if 1 true if 2 else 3 then 4 else 5 true if 6  7 then 8 then 9'.
	stack := #(1 2 4 9).
	
	self assert: (forth eval: expr; stackCopy) equals: stack reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen63 [
	| expr stack |
	
	"
	ForthInterpreterTest generateNestedIfsWith3IfsFor: 63
	
	Swift Forth
	: test drop true if 1 true if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9 .s ;
	"
	expr := 'true if 1 true if 2 else 3 then 4 else 5 true if 6 else 7 then 8 then 9'.
	stack := #(1 2 4 9).
	
	self assert: (forth eval: expr; stackCopy) equals: stack reversed
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfElseThen6Bug3 [
	| expr | 
	
	expr :=  '
	
	{1}	 if 1 else 2 
	{2} if 3 else 4 
	then 5 then 6
	
	'.
	
	self assert: (forth eval: (expr format: #(true false)); stackCopy) equals: #(1 6) reversed
	
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfThen [ 
	
	self assert: (forth eval: 'false if false if 1 then 2 then 3'; stackCopy) equals: #(3).
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfThen2 [ 
	
	self assert: (forth eval: 'false if true if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7).
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfThen3 [
	
	self assert: (forth eval: 'true if false if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7 6 5 4).
	
]

{ #category : #tests }
ForthIfElseThenTest >> testNestedIfThen4 [
	
	self assert: (forth eval: 'true if true if 1 2 3 then 4 5 6 then 7 8 9'; stackCopy) equals: #(9 8 7 6 5 4 3 2 1).
	
]

{ #category : #tests }
ForthIfElseThenTest >> testTrueIfElseThen [ 
	
	self assert: (forth eval: 'true if 1 else 2 then 3'; stackCopy) equals: #(1 3) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testTrueIfFalseIfThenThen [ 
	
	self assert: (forth eval: 'true if 1 false if 2 then 3 then 4'; stackCopy) equals: #(1 3 4) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testTrueIfThen [ 
	
	self assert: (forth eval: 'true if 1 then 2'; stackCopy) equals: #(1 2) reversed.
	
]

{ #category : #tests }
ForthIfElseThenTest >> testTrueIfTrueIfThenThen [ 
	self assert: (forth eval: 'true if 1 true if 2 then 3 then 4'; stackCopy) equals: #(1 2 3 4) reversed.
	
]
