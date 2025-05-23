Extension { #name : #GtLlmActionsGroup }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmActionsGroup >> gtActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Actions';
		priority: 1;
		items: [ self items ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						self remove: anItem.
						anItem removeFromSystem.
						aButton phlow fireToolUpdateWish ] ]
			width: 70
]
