Class {
	#name : #GtLlmAssistantActionExamplesGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmAssistantActionExamplesGroup class >> fromThreadMessages: aMessageGroup [
	^ self
		withAll: ((aMessageGroup items groupsOf: 2)
				collect: [ :aPair | 
					| split |
					split := aPair first contentText lines.
					GtLlmAssistantActionExample new
						instruction: split first;
						input: (Character linefeed join: (split allButFirst: 3));
						output: aPair second contentText ])
]

{ #category : #accessing }
GtLlmAssistantActionExamplesGroup >> gtExamplesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Examples';
		priority: 1;
		items: [ self items ];
		column: 'Instruction'
			text: #instruction
			weight: 0.5;
		column: 'Input' text: #input;
		column: 'Output' text: #output
]
