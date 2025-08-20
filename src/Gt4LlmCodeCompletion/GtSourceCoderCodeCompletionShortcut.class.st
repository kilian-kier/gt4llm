Class {
	#name : #GtSourceCoderCodeCompletionShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #Gt4LlmCodeCompletion
}

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> description [
	^ 'Let an LLM complete the current method'
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> fillInTheMiddlePromptBetween: aPrefixString and: aSuffixString [
	^ self prefixToken , aPrefixString , self suffixToken , aSuffixString
		, self middleToken
]

{ #category : #initialization }
GtSourceCoderCodeCompletionShortcut >> initialize [
	super initialize.

	combination := BlKeyCombinationBuilder new secondary enter build
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> middleToken [
	^ '<fim_middle>'
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> name [
	^ 'LLM code completion'
]

{ #category : #evaluation }
GtSourceCoderCodeCompletionShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	| text cursorPosition prefix suffix prompt assistant response |
	(aBrTextEditor cursors isSingle and: [ aBrTextEditor selection isEmpty ])
		ifFalse: [ ^ self ].
	text := aBrTextEditor text asString.
	cursorPosition := aBrEditorElement cursors first position.
	prefix := text copyFrom: 1 to: cursorPosition.
	suffix := text copyFrom: cursorPosition + 1 to: text size.
	prompt := self fillInTheMiddlePromptBetween: prefix and: suffix.
	assistant := GtLlmCodeCompletionAssistant instance.
	response := assistant generateResponseFor: prompt.
	nil halt
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> prefixToken [
	^ '<fim_prefix>'
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> suffix [
	^ '<fim_suffix>'
]

{ #category : #accessing }
GtSourceCoderCodeCompletionShortcut >> suffixToken [
	^ '<fim_suffix>'
]
