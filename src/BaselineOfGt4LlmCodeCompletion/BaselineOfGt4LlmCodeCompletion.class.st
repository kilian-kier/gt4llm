Class {
	#name : #BaselineOfGt4LlmCodeCompletion,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4LlmCodeCompletion
}

{ #category : #baseline }
BaselineOfGt4LlmCodeCompletion >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4LlmCore'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec package: 'Gt4LlmCodeCompletion' with: [ spec requires: #('Gt4LlmCore') ] ]
]
