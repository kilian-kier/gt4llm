Extension { #name : #GtOllamaClient }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaClient >> delete: aString withEntity: anEntity [
	| aClient |
	aClient := ZnClient new.
	
	aClient
		timeout: 600;
		beOneShot;
		url: self baseUrl / aString;
		method: #DELETE;
		entity: (ZnEntity json: (STONJSON toString: anEntity));
		execute.

	history add: (aClient request -> aClient response).
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient timeout: 600.
	^ aClient
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaClient >> postStreaming: aString withEntity: anEntity [
	| aClient aResult |
	aClient := self initializeClient
			streaming: true;
			contentReader: nil.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	aResult := aClient post.
	history add: aClient request -> aClient response.
	^ aResult
]
