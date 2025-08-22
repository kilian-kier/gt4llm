Class {
	#name : #GtOllamaPushModelClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaPushModelClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaPushModelClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaPushModelClient >> request [
	^self client post: '/push' withEntity: {'model' -> self model} asDictionary
]

{ #category : #accessing }
GtOllamaPushModelClient >> serializationClass [
	^ GtOllamaStatusSteps
]
