Class {
	#name : #GtLlmCodeCompletionAssistantInstruction,
	#superclass : #GtLlmAssistantInstruction,
	#category : #Gt4LlmCodeCompletion
}

{ #category : #accessing }
GtLlmCodeCompletionAssistantInstruction >> asInstructionPiece [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self description;
		sections: self sections
]
