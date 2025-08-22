Class {
	#name : #GtOllamaConsumerFuture,
	#superclass : #Object,
	#traits : 'TAsyncFuture',
	#classTraits : 'TAsyncFuture classTrait',
	#instVars : [
		'stream',
		'delay'
	],
	#category : #'Gt4Ollama-Streaming'
}

{ #category : #accessing }
GtOllamaConsumerFuture >> defaultDelay [
	^50 milliseconds
]

{ #category : #initialization }
GtOllamaConsumerFuture >> initialize [
	super initialize.
	delay := self defaultDelay
]

{ #category : #'api - future' }
GtOllamaConsumerFuture >> poll: anAsynchronousContext [
	<return: #AsyncPoll>
	self stream isAtEnd ifTrue: [^AsyncPoll ready: self stream].
	[self stream isReadyForMore]
		whileTrue: [self stream addResponse: self stream nextResponse].
	TaskAtQueue default
		schedule: [anAsynchronousContext waker wakeUp]
		at: DateAndTime now + delay
		entryIdentifier: self.
	^AsyncPoll pending
]

{ #category : #accessing }
GtOllamaConsumerFuture >> stream [
	^stream
]

{ #category : #accessing }
GtOllamaConsumerFuture >> stream: anObject [
	stream := anObject
]
