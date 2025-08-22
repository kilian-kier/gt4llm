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

{ #category : #instructions }
GtLlmCodeCompletionAssistant >> exampleResponses [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Example responses';
		body: '# Regular code completion:
prompt: "factorial
	| nex nexnext acc |
	self < 3
		ifTrue: [ ^ self < 0
				ifTrue: [ self error: ''Not valid for negative integers'' ]
				ifFalse: [ self > 0
						ifTrue: [ self ]
						ifFalse: [ 1 ] ] ].
	acc := 2.
	nex := 2.
	nexnext := 10.

	self // 2 - 1
		timesRepeat: [ nex := nex + nexnext.
			nexnext := nexnext + 8.
			acc := acc * nex ]."

response: "self odd ifTrue: [ acc := acc * self ].
	^ acc"

# Fill-in-the-middle completion:
prompt: "<fim_prefix>factorial
	| nex nexnext acc |
	self < 3
		ifTrue: [ ^ self < 0
				ifTrue: [ self error: ''Not valid for negative integers'' ]
				ifFalse: [ self > 0
						ifTrue: [ self ]
						ifFalse: [ 1 ] ] ].
	acc := 2.
	nex := 2.
	nexnext := 10.

	<fim_suffix>
		timesRepeat: [ nex := nex + nexnext.
			nexnext := nexnext + 8.
			acc := acc * nex ].
	self odd ifTrue: [ acc := acc * self ].
	^ acc<fim_middle>"

	response: "self // 2 - 1"'
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
- Avoid unnecessary boilerplate. Keep your output focused and consistent across runs.
- Please don''t use any ``` ``` characters for indicating code snippets. Just output the code and nothing else'
]

{ #category : #accessing }
GtLlmCodeCompletionAssistant >> systemPrompt [
	^ self instruction asInstructionPiece instructionString
]
