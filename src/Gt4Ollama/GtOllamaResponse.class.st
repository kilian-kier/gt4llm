Class {
	#name : #GtOllamaResponse,
	#superclass : #Object,
	#instVars : [
		'isDone',
		'content',
		'rawData'
	],
	#category : #'Gt4Ollama-Streaming'
}

{ #category : #'as yet unclassified' }
GtOllamaResponse class >> fromString: aString [
	^self new setString: aString
]

{ #category : #accessing }
GtOllamaResponse >> content [
	^content
]

{ #category : #'as yet unclassified' }
GtOllamaResponse >> gtContentFor: aView [
	<gtView>
	^(aView forward)
		title: 'Content';
		priority: 1;
		object: [self content];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtOllamaResponse >> isDone [
	^ isDone
]

{ #category : #private }
GtOllamaResponse >> setString: aString [
	rawData := STONJSON fromString: aString.
	isDone := rawData at: 'done'.
	content := rawData at: 'response'
]
