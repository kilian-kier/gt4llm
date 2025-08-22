Extension { #name : #GtPharoMethodCoderViewModel }

{ #category : #'*Gt4LlmCodeCompletion' }
GtPharoMethodCoderViewModel >> codeCompletion [
	^self coderModel attributeNamed: #codeCompletion
		ifAbsent: 
			[self coderModel attributeNamed: #codeCompletion
				put: (GtLlmCodeCompletionAssistant new codeCompletionOn: self)]
]
