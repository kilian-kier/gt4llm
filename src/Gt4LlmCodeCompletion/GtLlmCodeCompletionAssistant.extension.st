Extension { #name : #GtLlmCodeCompletionAssistant }

{ #category : #'*Gt4LlmCodeCompletion' }
GtLlmCodeCompletionAssistant >> codeCompletionOn: aCoderViewModel [
	^(GtLlmCodeCompletion new)
		assistant: self;
		provider: self buildProvider;
		coderViewModel: aCoderViewModel
]
