Class {
	#name : #GtLlmNewThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLlmWithThreadMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'toolbar',
		'imagesElement'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #factory }
GtLlmNewThreadMessageElement class >> newForChatList [
	^ self new
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		background: Color white;
		addAptitude: BrGlamorousFocusableShadowAptitude new;
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5)
]

{ #category : #'initialization ' }
GtLlmNewThreadMessageElement >> buildAttachButton [
	^ BrButton new
		fitContent;
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude new
				+ (BrGlamorousWithExplicitDropdownAptitude
						handle: [ BrButton new
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2
										- BrGlamorousButtonExteriorAptitude;
								icon: BrGlamorousVectorIcons changes ]
						content: [ BrFileSelector new
								folder: FileLocator home;
								padding: (BlInsets all: 8);
								fileFilterBlock: [ :aFileReference | 
									aFileReference isFile
										and: [ (FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ];
								okAction: [ :aFile :anOkButton | 
									self threadMessageViewModel attachFile: aFile.
									self updateImagesElement.
									anOkButton fireEvent: BrDropdownHideWish new ] ]);
		label: 'Attach';
		icon: BrGlamorousVectorIcons changes;
		margin: (BlInsets all: 3);
		constraintsDo: [ :c | 
			c linear vertical alignBottom.
			c linear horizontal alignLeft ]
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageElement >> buildProviderButton [
	| aButton |
	^ aButton := BrButton new beSmallSize
			aptitude: BrGlamorousButtonWithLabelAptitude new
					+ (BrGlamorousWithExplicitDropdownAptitude
							handle: [ BrButton new beSmallSize
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self threadMessageViewModel connectionString ]
							content: [ | aList |
								aList := BrSimpleList new fitContent
										id: #'provider-list';
										items: self threadMessageViewModel connectionRegistry connectableConnections;
										itemStencil: [ BrLabel new
												aptitude: BrGlamorousLabelAptitude new
														+ (BrStyleCommonAptitude new
																selected: [ :aStyle | aStyle background: BrGlamorousColors selectedListItemColor ];
																hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredListItemColor ]);
												padding: (BlInsets all: 5) ];
										itemDataBinder: [ :aLabel :anItem | aLabel text: anItem connectionString ];
										when: BrSelectionChanged
											do: [ :anEvent | 
												self threadMessageViewModel
													provider: (self threadMessageViewModel connectionRegistry connections
															at: anEvent indices first) buildProvider.
												aButton label: self threadMessageViewModel connectionString.
												aList fireEvent: BrDropdownHideWish new ] ]);
			label: self threadMessageViewModel connectionString
]

{ #category : #'initialization ' }
GtLlmNewThreadMessageElement >> buildSendButton [
	^ BrButton new
		fitContent;
		beSmallSize;
		id: #send;
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: 'Send';
		icon: BrGlamorousVectorIcons accept;
		action: [ :aButton | self sendMessageFrom: aButton ];
		margin: (BlInsets all: 3);
		constraintsDo: [ :c | 
			c linear vertical alignBottom.
			c linear horizontal alignLeft ]
]

{ #category : #initialization }
GtLlmNewThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
GtLlmNewThreadMessageElement >> initialize [
	super initialize.

	self initializeContentsElement.
	self initializeImagesElement.
	self initializeToolbar.
	self addChild: contentsElement as: #contents.
	self addChild: imagesElement as: #images.
	self addChild: toolbar as: #toolbar.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmNewThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude.

	contentsElement editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self updateContents: anEvent text ].

	contentsElement
		addShortcut: (BrEditorShortcut new
				name: 'Send message';
				description: 'Send message to the OpenAI assistant chat';
				combination: BlKeyCombination primaryReturn;
				performBlock: [ :aBrTextEditor | self sendMessage ];
				yourself)
]

{ #category : #'initialization ' }
GtLlmNewThreadMessageElement >> initializeImagesElement [
	imagesElement := BrHorizontalPane new fitContent clipChildren: false
]

{ #category : #'initialization ' }
GtLlmNewThreadMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - announcement handling' }
GtLlmNewThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtLlmNewThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLlmNewThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - actions' }
GtLlmNewThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLlmNewThreadMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLlmNewThreadMessageElement >> subscribeToThreadMessageViewModel [
	self threadMessage
		when: GtLlmNewThreadMessageContentsChanged
		send: #onThreadMessageContentsChanged:
		to: self.

	self threadMessageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
		send: #onThreadMessageViewModelChanged:
		to: self
]

{ #category : #'private - hooks' }
GtLlmNewThreadMessageElement >> unsubscribeFromThreadMessageViewModel [
	self threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
GtLlmNewThreadMessageElement >> updateContents: aBlText [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtLlmNewThreadMessageElement >> updateContentsElement [
	contentsElement
		text: threadMessageViewModel contents;
		styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmNewThreadMessageElement >> updateElement [
	self updateContentsElement.
	self updateImagesElement.
	self updateToolbar
]

{ #category : #'private - updating' }
GtLlmNewThreadMessageElement >> updateImagesElement [
	imagesElement removeChildren.

	self threadMessageViewModel files
		do: [ :aFile | 
			imagesElement
				addChild: (BrDeletableFileWidget new
						vExact: 100;
						hExact: 100;
						isDeletable: true;
						file: aFile;
						onDeletion: [ :aFileForDeletion | 
							self threadMessageViewModel files remove: aFileForDeletion.
							self updateImagesElement ]) ]
]

{ #category : #'private - updating' }
GtLlmNewThreadMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItem: self buildSendButton.
	toolbar addItem: self buildAttachButton.
	toolbar addItem: self buildProviderButton
]
