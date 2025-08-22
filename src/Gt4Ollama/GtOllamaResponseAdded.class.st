Class {
	#name : #GtOllamaResponseAdded,
	#superclass : #Announcement,
	#instVars : [
		'response'
	],
	#category : #'Gt4Ollama-Streaming'
}

{ #category : #accessing }
GtOllamaResponseAdded >> response [
	^response
]

{ #category : #accessing }
GtOllamaResponseAdded >> response: anObject [
	response := anObject
]
