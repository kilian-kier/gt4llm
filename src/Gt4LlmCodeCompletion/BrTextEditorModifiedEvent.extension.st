Extension { #name : #BrTextEditorModifiedEvent }

{ #category : #'*Gt4LlmCodeCompletion' }
BrTextEditorModifiedEvent >> isDueToDeletion [
	^(reason isKindOf: BlTextsDeleted)
		or: [editCommand isKindOf: BrTextEditorHistoryDeletionCommand]
]

{ #category : #'*Gt4LlmCodeCompletion' }
BrTextEditorModifiedEvent >> isDueToInsertion [
	^(reason isKindOf: BlTextStringsInserted)
		or: [editCommand isKindOf: BrTextEditorHistoryInsertionCommand]
]
