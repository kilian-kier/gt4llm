Class {
	#name : #GtCodeCompletionStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #Gt4LlmCodeCompletion
}

{ #category : #accessing }
GtCodeCompletionStyler >> visitMethod: aMethodNode [
	| codeCompletion |
	super visitProgram: aMethodNode.

	codeCompletion := self coderViewModel coderModel
			attributeNamed: #codeCompletion.

	self
		attributes: {BlFontWeightAttribute light.
				BlFontItalicAttribute new}
		from: codeCompletion startPosition
		to: codeCompletion stopPosition.
	codeCompletion isDone
		ifTrue: [ self
				attribute: (GtButtonAttribute new beAppend
						stencil: [ BrButton new
								aptitude: BrGlamorousButtonWithIconAptitude;
								beTinySize;
								label: 'Accept this completion';
								icon: BrGlamorousVectorIcons accept;
								action: [ :aButtonElement :aButtonModel :anEvent | codeCompletion accept ];
								yourself ])
				from: codeCompletion stopPosition
				to: codeCompletion stopPosition ].
	self
		attribute: (GtButtonAttribute new beAppend
				stencil: [ BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude;
						beTinySize;
						label: 'Reject this completion';
						icon: BrGlamorousVectorIcons cancel;
						action: [ :aButtonElement :aButtonModel :anEvent | codeCompletion reject ];
						yourself ])
		from: codeCompletion stopPosition
		to: codeCompletion stopPosition
]
