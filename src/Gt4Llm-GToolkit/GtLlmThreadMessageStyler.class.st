Class {
	#name : #GtLlmThreadMessageStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'annotations'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmThreadMessageStyler >> annotations [
	^ annotations
]

{ #category : #accessing }
GtLlmThreadMessageStyler >> annotations: aListOfAnnotations [
	annotations := (aListOfAnnotations
			collect: [ :anAnnotation | anAnnotation text -> anAnnotation ]) asDictionary
]

{ #category : #accessing }
GtLlmThreadMessageStyler >> privateStyle: aText [
	| aString aParser |
	aString := aText asString.
	aParser := ('【' asPParser , '】' asPParser negate plus token , '】' asPParser)
			==> [ :tokens | 
				| annotation |
				annotation := self annotations
						at: '【' , tokens second value , '】'
						ifAbsent: [ nil ].
				(aText from: tokens second start - 1 to: tokens second stop + 1)
					highlight: (annotation
							ifNil: [ BrGlamorousColors paleErrorBackgroundColor ]
							ifNotNil: [ BrGlamorousColors newsBackgroundColor ]).
				annotation
					ifNotNil: [ (aText from: tokens second start - 1 to: tokens second stop + 1)
							attribute: (GtPlaygroundEvaluatedCodeButtonAttribute new result: annotation file) ] ].
	aParser sea star optimize parse: aString.
	^ aText
]

{ #category : #accessing }
GtLlmThreadMessageStyler >> style: aBlText [
	<return: #BlText>
	^ BlTextStylerTelemetry
		rootTimeSync: [ Processor activeProcess name , '  ' , self class name , ': '
				, (aBlText first: (20 min: aBlText size)) asString ]
		during: [ | aStyledText |
			aStyledText := self privateStyle: aBlText characters.
			aStyledText text ]
]
