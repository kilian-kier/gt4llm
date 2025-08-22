Class {
	#name : #GtOllamaResponse,
	#superclass : #Object,
	#instVars : [
		'done',
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

{ #category : #accessing }
GtOllamaResponse >> done [
	^done
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

{ #category : #private }
GtOllamaResponse >> setString: aString [
	rawData := STONJSON fromString: aString.
	done := rawData at: 'done'.
	content := rawData at: 'response'
]
