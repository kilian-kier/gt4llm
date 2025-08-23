Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4LlmCodeCompletion' }
GtPharoMethodCoder >> addCodeCompletionFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 5>
	coderAddOns addShortcut: GtSourceCoderCodeCompletionShortcut new.
	coderAddOns addStyler: GtCodeCompletionStyler new
]
