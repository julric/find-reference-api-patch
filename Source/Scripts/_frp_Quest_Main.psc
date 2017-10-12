;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _frp_Quest_Main Extends Quest Hidden

;BEGIN ALIAS PROPERTY CenterObject_0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_0 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_7
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_7 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_9
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_9 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_6
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_6 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_8
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_8 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterObject_5
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterObject_5 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; STAGE 0 FRAGMENT
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto
{The player.}

; Message Property _frp_FormListInfo  Auto
; {A diagnostic message showing FormList ID, number of items and assigned cache slot.}
; (FormList %.0f, %.0f items, cache slot %.0f)

FormList[] Property FormListCache  Auto
{Cached copies of formlists passed to the API.}

int[] Property CacheKey  Auto
{FormID values of source formlists, used as cache keys.}

ReferenceAlias[] Property CenterObject  Auto
{Reference aliases to arCenter objects passed to the API.}

GlobalVariable[] Property SearchRadius  Auto
{Global variables that hold the value of afRadius passed to the API.}

Quest[] Property SearchQuests  Auto
{Quests that implement the fallback search behavior that mimics the API.}

int[] Property LeastRecentlyUsed  Auto
{Age values that help identify the Least Recently Used cache slot.}

int kCacheKeyNone = 0
int kCacheKeyAtom = -1

ObjectReference Function FindClosestOfAnyTypeInList(FormList arBaseObjects, ObjectReference arCenter, float afRadius)
;	Debug.Notification("FindClosestOfAnyTypeInList")

	int slot = GetSlot(arBaseObjects)

	CenterObject[Slot].ForceRefTo(arCenter)
	SearchRadius[slot].SetValue(afRadius)

	_frp_Quest_Search search = SearchQuests[slot] as _frp_Quest_Search

	return search.GetResult()

EndFunction

ObjectReference Function FindClosestOfType(Form arBaseObject, ObjectReference arCenter, float afRadius)
;	Debug.Notification("FindClosestOfType")

	int slot = GetSlotForSingleBaseObject(arBaseObject)

	CenterObject[Slot].ForceRefTo(arCenter)
	SearchRadius[slot].SetValue(afRadius)

	_frp_Quest_Search search = SearchQuests[slot] as _frp_Quest_Search

	return search.GetResult()

EndFunction

int Function GetSlot(FormList arBaseObjects)
;	Bump up all of the Least Recently Used counters
	int i = 0
	while i < LeastRecentlyUsed.Length
		if LeastRecentlyUsed[i] < 999999
			LeastRecentlyUsed[i] = LeastRecentlyUsed[i] + 1
		endif
		i += 1
	endwhile

;	Search for a match in the formlist cache
	i = 0
	while i < CacheKey.Length
		if CacheKey[i] == arBaseObjects.GetFormID()
			if arBaseObjects.GetSize() == FormListCache[i].GetSize()
				LeastRecentlyUsed[i] = 0
				return i
			else
				CacheKey[i] = kCacheKeyNone
			endif
		endif
		i += 1
	endwhile

;	No match, so choose next unused OR least recently used slot
	int age = 0
	int lruSlot = 0
	i = 0
	while i < CacheKey.Length
		if CacheKey[i] == kCacheKeyNone
			LeastRecentlyUsed[i] = 0
			CacheKey[i] = arBaseObjects.GetFormID()
			FillFormList(arBaseObjects, FormListCache[i], i)
			return i
		endif
		if age < LeastRecentlyUsed[i]
			age = LeastRecentlyUsed[i]
			lruSlot = i
		endif
		i += 1
	endwhile

;	Recycle the least recently used slot.
	LeastRecentlyUsed[lruSlot] = 0
	CacheKey[lruSlot] = arBaseObjects.GetFormID()
	FillFormList(arBaseObjects, FormListCache[lruSlot], lruSlot)
	return lruSlot

EndFunction

Function FillFormList(FormList sourceList, FormList targetList, int slot)
;	_frp_FormListInfo.Show(sourceList.GetFormID(), sourceList.GetSize(), slot)

	targetList.Revert()
	int size = sourceList.GetSize()
	int i = 0
	while i<size
		Form f = sourceList.GetAt(i)
		targetList.AddForm(f)
		i += 1
	endwhile
EndFunction

int Function GetSlotForSingleBaseObject(Form arBaseObject)
	int age = 0
	int lruSlot = 0
	int i = 0
	while i < CacheKey.Length
		if age < LeastRecentlyUsed[i]
			age = LeastRecentlyUsed[i]
			lruSlot = i
		endif
		i += 1
	endwhile

	LeastRecentlyUsed[lruSlot] = 0
	CacheKey[lruSlot] = kCacheKeyAtom
	FillFormListWithBaseObject(arBaseObject, FormListCache[lruSlot], lruSlot)
	return lruSlot

EndFunction

Function FillFormListWithBaseObject(Form arBaseObject, FormList targetList, int slot)
;	_frp_FormListInfo.Show(arBaseObject.GetFormID(), 1, slot)

	targetList.Revert()
	targetList.AddForm(arBaseObject)
EndFunction
