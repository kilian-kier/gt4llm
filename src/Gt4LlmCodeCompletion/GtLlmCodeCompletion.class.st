Class {
	#name : #GtLlmCodeCompletion,
	#superclass : #Object,
	#instVars : [
		'assistant',
		'coderViewModel',
		'textEditor',
		'editorElement',
		'provider'
	],
	#category : #Gt4LlmCodeCompletion
}

{ #category : #accessing }
GtLlmCodeCompletion >> assistant [
	^assistant
]

{ #category : #accessing }
GtLlmCodeCompletion >> assistant: aGtLlmAssistant [
	assistant := aGtLlmAssistant
]

{ #category : #actions }
GtLlmCodeCompletion >> callback: aString [
	GtTranscript default nextPutAll: aString.
	self editorElement
		enqueueTask: (BlTaskAction new action: 
					[(self editorElement inserter)
						at: self cursorPosition;
						string: aString;
						withoutSelectionUpdate;
						withoutSelectionDelete;
						insert])
]

{ #category : #accessing }
GtLlmCodeCompletion >> coderViewModel [
	^coderViewModel
]

{ #category : #accessing }
GtLlmCodeCompletion >> coderViewModel: aCoderViewModel [
	coderViewModel := aCoderViewModel
]

{ #category : #accessing }
GtLlmCodeCompletion >> cursorPosition [
	^self editorElement cursors first position
]

{ #category : #accessing }
GtLlmCodeCompletion >> editorElement [
	^editorElement
]

{ #category : #accessing }
GtLlmCodeCompletion >> editorElement: anObject [
	editorElement := anObject
]

{ #category : #actions }
GtLlmCodeCompletion >> generateCompletionOnEditor: aBrTextEditor element: aBrEditorElement [
	| text prefix suffix prompt streamedResponse |
	self textEditor: aBrTextEditor.
	self editorElement: aBrEditorElement.
	text := self textEditor text asString.
	prefix := text copyFrom: 1 to: self cursorPosition.
	suffix := text copyFrom: self cursorPosition + 1 to: text size.
	prompt := self promptFor: prefix and: suffix.
	streamedResponse := self generateResponseFor: prompt.
	streamedResponse callbackInstance: self
]

{ #category : #actions }
GtLlmCodeCompletion >> generateResponseFor: aPromptString [
	^self provider client
		generateStreamingResponseWithModel: self provider model
		andPrompt: aPromptString
		andSystem: self assistant systemPrompt
]

{ #category : #accessing }
GtLlmCodeCompletion >> middleToken [
	^'<fim_middle>'
]

{ #category : #accessing }
GtLlmCodeCompletion >> prefixToken [
	^'<fim_prefix>'
]

{ #category : #accessing }
GtLlmCodeCompletion >> promptFor: aPrefixString and: aSuffixString [
	aSuffixString trimAll ifEmpty: [^aPrefixString].
	^self prefixToken , aPrefixString , self suffixToken , aSuffixString
		, self middleToken
]

{ #category : #accessing }
GtLlmCodeCompletion >> provider [
	^provider
]

{ #category : #accessing }
GtLlmCodeCompletion >> provider: anObject [
	provider := anObject
]

{ #category : #accessing }
GtLlmCodeCompletion >> suffixToken [
	^'<fim_suffix>'
]

{ #category : #accessing }
GtLlmCodeCompletion >> textEditor [
	^textEditor
]

{ #category : #accessing }
GtLlmCodeCompletion >> textEditor: anObject [
	textEditor := anObject
]
