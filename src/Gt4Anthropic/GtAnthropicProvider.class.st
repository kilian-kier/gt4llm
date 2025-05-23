Class {
	#name : #GtAnthropicProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'tools',
		'maxTokens',
		'instructions'
	],
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> providerName [
	^ 'Anthropic'
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtAnthropicClient apiKeyFileContents
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtAnthropicProvider >> client [
	^ client
]

{ #category : #accessing }
GtAnthropicProvider >> client: anObject [
	client := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> defaultMaxTokens [
	^ 4096
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> initialize [
	super initialize.

	assistantWorking := false.
	
	self initializeClient.
	
	tools := GtLlmToolsGroup new.
	maxTokens := self defaultMaxTokens
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> initializeClient [
	client := GtAnthropicClient new
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> instructions [
	^ instructions
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtAnthropicProvider >> maxTokens [
	^ maxTokens
]

{ #category : #accessing }
GtAnthropicProvider >> maxTokens: anObject [
	maxTokens := anObject
]

{ #category : #accessing }
GtAnthropicProvider >> model [
	^ model
]

{ #category : #accessing }
GtAnthropicProvider >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> performToolCallsFor: aResult [
	aResult toolCalls
		do: [ :aToolCall | 
			| toolOutput |
			toolOutput := tools performToolCall: aToolCall.
			chat
				addMessage: (GtAnthropicToolMessage new
						id: aToolCall id;
						contentText: toolOutput) ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> sendAssistantMessage: aMessage [
	userMessageClass adoptInstance: aMessage.
	aMessage role: 'user'.
	self chat addMessage: aMessage.

	[ self triggerAssistant ] asAsyncPromise
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> triggerAssistant [
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.

	[ result := self client
			completeChatWithModel: self model
			messages: self chat messages
			maxTokens: self maxTokens
			system: instructions
			andTools: tools.


	self chat addMessage: result.

	self performToolCallsFor: result ] doWhileTrue: [ result toolCalls isNotEmpty ].

	self chat signalRunIsDone.

	assistantWorking := false
]
