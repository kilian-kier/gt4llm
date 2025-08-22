Class {
	#name : #GtSourceCoderCodeCompletionShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #Gt4LlmCodeCompletion
}

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> description [
	^ 'Let an LLM complete the current method'
]

{ #category : #initialization }
GtSourceCoderCodeCompletionShortcut >> initialize [
	super initialize.

	combination := BlKeyCombinationBuilder new secondary enter build
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> name [
	^ 'LLM code completion'
]

{ #category : #evaluation }
GtSourceCoderCodeCompletionShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	(aBrTextEditor cursors isSingle and: [aBrTextEditor selection isEmpty])
		ifFalse: [^self].
	aRequester codeCompletion generateCompletionOnEditor: aBrTextEditor
		element: aBrEditorElement
]
