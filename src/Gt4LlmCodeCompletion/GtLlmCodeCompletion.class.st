Class {
	#name : #GtLlmCodeCompletion,
	#superclass : #Object,
	#instVars : [
		'assistant',
		'coderViewModel',
		'textEditor',
		'editorElement',
		'provider',
		'startPosition',
		'stopPosition',
		'isDone',
		'streamedResponse'
	],
	#category : #Gt4LlmCodeCompletion
}

{ #category : #actions }
GtLlmCodeCompletion >> accept [
	self coderViewModel coderModel removeAttributeNamed: #codeCompletion.
	self textEditor styleText
]

{ #category : #accessing }
GtLlmCodeCompletion >> assistant [
	^assistant
]

{ #category : #accessing }
GtLlmCodeCompletion >> assistant: aGtLlmAssistant [
	assistant := aGtLlmAssistant
]

{ #category : #actions }
GtLlmCodeCompletion >> callback: aString isDone: aBoolean [
	GtTranscript default
		nextPutAll: 'LLM code completion: ';
		nextPutAll: aString;
		nextPutAll: ' (done: ';
		nextPutAll: aBoolean;
		nextPutAll: ')';
		cr.
	self editorElement
		enqueueTask: (BlTaskAction new
				action: [ self editorElement inserter
						at: self cursorPosition;
						string: aString;
						withoutSelectionUpdate;
						withoutSelectionDelete;
						insert.
					self stopPosition: self stopPosition + aString size.
					self isDone: aBoolean.
					self textEditor styleText ])
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
	| text prefix suffix prompt |
	self textEditor: aBrTextEditor.
	self editorElement: aBrEditorElement.
	self startPosition: self cursorPosition.
	self stopPosition: self cursorPosition.
	text := self textEditor textSnapshot asString.
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
GtLlmCodeCompletion >> isDone [
	^ isDone
]

{ #category : #accessing }
GtLlmCodeCompletion >> isDone: anObject [
	isDone := anObject
]

{ #category : #accessing }
GtLlmCodeCompletion >> middleToken [
	^'<|fim_middle|>'
]

{ #category : #accessing }
GtLlmCodeCompletion >> prefixToken [
	^'<|fim_prefix|>'
]

{ #category : #accessing }
GtLlmCodeCompletion >> promptFor: aPrefixString and: aSuffixString [
	aSuffixString trimBoth ifEmpty: [ ^ aPrefixString ].
	^ self prefixToken , aPrefixString , self suffixToken , aSuffixString
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

{ #category : #actions }
GtLlmCodeCompletion >> reject [
	streamedResponse callbackInstance: nil.
	self editorElement deleter
		from: self startPosition to: self stopPosition;
		withoutSelectionUpdate;
		delete.
	self coderViewModel coderModel removeAttributeNamed: #codeCompletion.
	self textEditor styleText
]

{ #category : #accessing }
GtLlmCodeCompletion >> startPosition [
	^ startPosition
]

{ #category : #accessing }
GtLlmCodeCompletion >> startPosition: anObject [
	startPosition := anObject
]

{ #category : #accessing }
GtLlmCodeCompletion >> stopPosition [
	^ stopPosition
]

{ #category : #accessing }
GtLlmCodeCompletion >> stopPosition: anObject [
	stopPosition := anObject
]

{ #category : #accessing }
GtLlmCodeCompletion >> suffixToken [
	^'<|fim_suffix|>'
]

{ #category : #accessing }
GtLlmCodeCompletion >> test [
	"assert that 1 + 1 is equal to 2, 1 + 2 is equal to 3 and 2 + 2 is equal to 4"

	self assert: 1 + 1 equals: 2.
	self assert: 2 + 2 equals: 4
]

{ #category : #accessing }
GtLlmCodeCompletion >> textEditor [
	^ textEditor
]

{ #category : #accessing }
GtLlmCodeCompletion >> textEditor: anObject [
	textEditor := anObject
]
