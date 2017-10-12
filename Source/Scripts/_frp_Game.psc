Scriptname _frp_Game Hidden

ObjectReference Function FindClosestOfAnyTypeInList(FormList arBaseObjects, ObjectReference arCenter, float afRadius) global

	_frp_Quest_Main patch = Game.GetFormFromFile(0x0A0012CA, "FindRefAPIPatch.esp") as _frp_Quest_Main
	return patch.FindClosestOfAnyTypeInList(arBaseObjects, arCenter, afRadius)

EndFunction

ObjectReference Function FindClosestOfType(Form arBaseObject, ObjectReference arCenter, float afRadius) global

	_frp_Quest_Main patch = Game.GetFormFromFile(0x0A0012CA, "FindRefAPIPatch.esp") as _frp_Quest_Main
	return patch.FindClosestOfType(arBaseObject, arCenter, afRadius)

EndFunction
