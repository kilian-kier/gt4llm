Extension { #name : #ZnChunkedReadStream }

{ #category : #'*Gt4LlmCodeCompletion' }
ZnChunkedReadStream >> upToAny: aCollection [
	^ self collectionSpecies
		streamContents: [ :out | 
			| element |
			[ self atEnd or: [ aCollection includes: (element := self next) ] ]
				whileFalse: [ out nextPut: element ] ]
]
