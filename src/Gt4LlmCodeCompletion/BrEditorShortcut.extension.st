Extension { #name : #BrEditorShortcut }

{ #category : #'*Gt4LlmCodeCompletion' }
BrEditorShortcut class >> deselectAll [
	^(self new)
		name: 'Deselect';
		description: 'Deselects any currently selected text.';
		combination: BlKeyCombination escape;
		performBlock: 
				[:aBrTextEditor |
				(aBrTextEditor model notNil
					and: [aBrTextEditor model hasPendingCodeCompletion])
						ifTrue: [aBrTextEditor model codeCompletion reject]
						ifFalse: [aBrTextEditor selectNone]];
		yourself
]

{ #category : #'*Gt4LlmCodeCompletion' }
BrEditorShortcut class >> shiftRight [
	^(self new)
		name: 'Shift right';
		description: 'Shift text at the cursor or if there is selection, the selected lines, one indetation to the right.';
		combination: BlKeyCombination tab;
		performBlock: 
				[:aBrTextEditor |
				(aBrTextEditor model notNil and: 
						[aBrTextEditor model hasPendingCodeCompletion
							and: [aBrTextEditor model codeCompletion isDone]])
					ifTrue: [aBrTextEditor model codeCompletion accept]
					ifFalse: 
						[aBrTextEditor selection isEmpty
							ifTrue: 
								[(aBrTextEditor inserter)
									atCursor;
									indentation;
									insert]
							ifFalse: 
								[(aBrTextEditor inserter)
									indentation;
									beforeSelectedLines;
									withoutSelectionDelete;
									insert]]];
		yourself
]
