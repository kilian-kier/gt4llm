Class {
	#name : #GtOpenAIResponseProvider,
	#superclass : #GtOpenAIProvider,
	#instVars : [
		'tools',
		'instructions'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider class >> providerName [
	^ 'OpenAI Responses'
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> defaultAssistantMessageClass [
	^ GtOpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> defaultTools [
	^ GtLlmToolsGroup new
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> defaultUserMessageClass [
	^ GtOpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tools';
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> handleToolCall: aToolCall [
	| toolOutput |
	chat removeLastMessage.
	chat
		addMessage: (GtOpenAIRawToolMessage new
				toolCall: aToolCall;
				rawData: aToolCall rawData).
	toolOutput := tools performToolCall: aToolCall.
	chat
		addMessage: (GtLlmToolMessage new
				toolCall: aToolCall;
				output: toolOutput).

	self chat signalRunHasUpdated.

	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> initialize [
	super initialize.

	tools := self defaultTools
]

{ #category : #accessing }
GtOpenAIResponseProvider >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIResponseProvider >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIResponseProvider >> performToolCallsIn: result [
	| toolOutputs |
	toolOutputs := result toolCalls
			collect: [ :aToolCall | 
				| toolOutput |
				chat
					addMessage: (GtOpenAIRawToolMessage new
							toolCall: aToolCall;
							rawData: aToolCall rawData).
				toolOutput := tools performToolCall: aToolCall.
				chat
					addMessage: (GtLlmToolMessage new
							toolCall: aToolCall;
							output: toolOutput) ].
	
	self chat signalRunHasUpdated.

	^ self executeWait
]

{ #category : #accessing }
GtOpenAIResponseProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIResponseProvider >> tools: anObject [
	tools := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> triggerAssistant [
	self chat signalRunHasStarted.
	assistantWorking := true.

	self executeWait
]
