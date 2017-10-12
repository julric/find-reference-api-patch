Scriptname _frp_Quest_Search Extends Quest

ReferenceAlias Property Alias_CenterObject Auto
ReferenceAlias Property Alias_Result Auto

ObjectReference Function GetResult()

	ObjectReference result = none

	self.Start()

	while self.IsStarting()
		Utility.Wait(0.05)
	endwhile

	result = Alias_Result.GetReference()
	
	self.Stop()

	return result
	
EndFunction
