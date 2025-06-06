Class {
	#name : #GtOpenAIGetFineTuningCheckpointsForJobAPIClient,
	#superclass : #GtOpenAIGetFineTuningJobAPIClient,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIGetFineTuningCheckpointsForJobAPIClient >> request [
	^ self client get: '/fine_tuning/jobs/' , self job , '/checkpoints'
]

{ #category : #accessing }
GtOpenAIGetFineTuningCheckpointsForJobAPIClient >> serializationClass [
	^ GtOpenAIFineTuningCheckpointsGroup
]
