Class {
	#name : #GtOllamaStreamedResponseMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'stream',
		'callbackInstance'
	],
	#category : #'Gt4Ollama-StreamingStreaming'
}

{ #category : #accessing }
GtOllamaStreamedResponseMessage class >> from: aStream [
	^self new stream: (GtOllamaStream new stream: aStream)
]

{ #category : #accessing }
GtOllamaStreamedResponseMessage >> callbackInstance [
	^callbackInstance
]

{ #category : #accessing }
GtOllamaStreamedResponseMessage >> callbackInstance: anObject [
	callbackInstance := anObject.
	self notifyCallback
]

{ #category : #actions }
GtOllamaStreamedResponseMessage >> notifyCallback [
	| responses |
	responses := stream responses nextAllOrEmpty.
	responses ifEmpty: [ ^ self ].
	callbackInstance
		callback: ('' join: (responses collect: [ :e | e content ]))
		isDone: responses last isDone
]

{ #category : #accessing }
GtOllamaStreamedResponseMessage >> onOutput: anAnnouncement [
	callbackInstance ifNil: [^self].
	self notifyCallback
]

{ #category : #accessing }
GtOllamaStreamedResponseMessage >> stream [
	^stream
]

{ #category : #accessing }
GtOllamaStreamedResponseMessage >> stream: aStream [
	stream := aStream.
	self subscribeToStream
]

{ #category : #accessing }
GtOllamaStreamedResponseMessage >> subscribeToStream [
	self stream when: GtOllamaResponseAdded send: #onOutput: to: self
]
