Class {
	#name : #GtOllamaStream,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'stream',
		'announcer',
		'consumeFuture',
		'responses'
	],
	#category : #'Gt4Ollama-Streaming'
}

{ #category : #accessing }
GtOllamaStream >> addResponse: aResponse [
	responses nextPut: aResponse.
	self announce: (GtOllamaResponseAdded new response: aResponse)
]

{ #category : #announcer }
GtOllamaStream >> announcer [
	<return: #Announcer>
	^announcer ifNil: [announcer := Announcer new]
]

{ #category : #accessing }
GtOllamaStream >> consumeFuture [
	^GtOllamaConsumerFuture new stream: self
]

{ #category : #initialization }
GtOllamaStream >> initialize [
	super initialize.
	responses := SharedQueue new
]

{ #category : #accessing }
GtOllamaStream >> isAtEnd [
	^ self responses isEmpty not and: [ self responses itemArray last isDone ]
]

{ #category : #accessing }
GtOllamaStream >> isReadyForMore [
	^self stream peek notNil
]

{ #category : #accessing }
GtOllamaStream >> nextData [
	^(self stream upToAny: 
			{Character cr asInteger.
			Character lf asInteger})
		utf8Decoded
]

{ #category : #accessing }
GtOllamaStream >> nextResponse [
	^GtOllamaResponse fromString: self nextData
]

{ #category : #accessing }
GtOllamaStream >> responses [
	^responses
]

{ #category : #accessing }
GtOllamaStream >> responses: anObject [
	responses := anObject
]

{ #category : #accessing }
GtOllamaStream >> stream [
	^stream
]

{ #category : #accessing }
GtOllamaStream >> stream: aStream [
	stream := aStream.
	consumeFuture := self consumeFuture await
]
