Class {
	#name : #GtLlmCodeCompletionAssistant,
	#superclass : #GtLlmAssistant,
	#instVars : [
		'provider'
	],
	#classInstVars : [
		'instance'
	],
	#category : #Gt4LlmCodeCompletion
}

{ #category : #'instance creation' }
GtLlmCodeCompletionAssistant class >> instance [
	^ instance ifNil: [ instance := self basicNew initialize ]
]

{ #category : #instructions }
GtLlmCodeCompletionAssistant >> codeStyle [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Respect user''s style and context';
		body: '- Adhere to Smalltalk formatting and naming conventions (e.g., meaningful identifiers, consistent indentation).
- Keep code simple, maintainable, and structured for readability.'
]

{ #category : #instructions }
GtLlmCodeCompletionAssistant >> completionModes [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Support two completion modes';
		body: '- Regular code completion: Generate only the next logical lines or segment.
- Fill-in-the-middle tasks: When given surrounding code, respond exclusively with the missing **middle** part. Do not repeat or alter existing code.'
]

{ #category : #instructions }
GtLlmCodeCompletionAssistant >> defaultDescription [
	^ 'You are a **Pharo Smalltalk code completion assistant**, trained for precision, clarity, and reliability.'
]

{ #category : #actions }
GtLlmCodeCompletionAssistant >> generateResponseFor: aPromptString [
	^ self provider client
		generateResponseWithModel: self provider model
		andPrompt: aPromptString
		andSystem: self systemPrompt
]

{ #category : #views }
GtLlmCodeCompletionAssistant >> gtActionsFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #views }
GtLlmCodeCompletionAssistant >> gtFormatComponentsFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #initialization }
GtLlmCodeCompletionAssistant >> initialize [
	super initialize.
	connection := GtLlmConnectionRegistry instance defaultConnection.
	provider := self buildProvider
]

{ #category : #instructions }
GtLlmCodeCompletionAssistant >> initializeInstruction [
	instruction := GtLlmCodeCompletionAssistantInstruction new.
	instruction sections: self collectSections
]

{ #category : #accessing }
GtLlmCodeCompletionAssistant >> model [
	^ model
]

{ #category : #accessing }
GtLlmCodeCompletionAssistant >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmCodeCompletionAssistant >> provider [
	^ provider
]

{ #category : #accessing }
GtLlmCodeCompletionAssistant >> provider: anObject [
	provider := anObject
]

{ #category : #instructions }
GtLlmCodeCompletionAssistant >> strictCodeOutput [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Respond strictly with valid Pharo Smalltalk code.';
		body: '- Do not include any natural language (no comments, explanations, or narrative).
- Only output syntactically correct Pharo code.
- Avoid unnecessary boilerplate. Keep your output focused and consistent across runs.'
]

{ #category : #accessing }
GtLlmCodeCompletionAssistant >> systemPrompt [
	^ self instruction asInstructionPiece instructionString
]
