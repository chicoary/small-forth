"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSmallForth,
	#superclass : #PackageManifest,
	#category : #'SmallForth-Manifest'
}

{ #category : #'code-critics' }
ManifestSmallForth class >> ruleRBGuardingClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ForthInterpreter #evalBetweenElseAndThen #false)) #'2019-05-28T17:37:54.046857-03:00') )
]
