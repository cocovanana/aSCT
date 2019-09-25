local A, L = ...

L.top = {}

L.top.frame = CreateFrame("ScrollingMessageFrame", "aProc", UIParent)
L.top.frame:SetPoint(unpack(L.C.top.point))
L.top.frame:SetFont("Fonts\\FRIZQT__.TTF", L.C.top.fontSize, "OUTLINE")
L.top.frame:SetWidth(L.C.top.width)
L.top.frame:SetHeight(L.C.top.height)
L.top.frame:SetFadeDuration(L.C.top.procFadeDuration)
L.top.frame:SetTimeVisible(L.C.top.procDuration)
L.top.frame:Show()
L.top.activeProcs = {}
L.top.blacklistProcs = {}

function L.top.onEvent(self, event, ...)
	local unit = ...
	local removeProcs = {}

	for proc, exists in pairs(L.top.activeProcs) do
		removeProcs[proc] = true
	end

	if unit == "player" then
		for i=1,40 do
		  local name = UnitBuff(unit, i, "HELPFUL|PLAYER")
			if name then
				removeProcs[name] = nil
				if L.top.activeProcs[name] == nil and L.top.blacklistProcs[name] == nil then
					L.top.activeProcs[name] = true
					L.top.frame:AddMessage("+"..name, 0.3, 1, 0.3, L.top.chatInfo, 0.5)
				end
			end
		end

		for proc, exists in pairs(removeProcs) do
			L.top.activeProcs[proc] = nil
			L.top.frame:AddMessage("-"..proc, 1, 0.3, 0.3, L.C.chatInfo, 0.5)
		end
	end
end

for i, blacklisted in ipairs(L.C.top.blacklist) do
	L.top.blacklistProcs[blacklisted] = true
end

for i=1,40 do
	local name = UnitBuff("player", i, "HELPFUL|PLAYER")
	if name then
		L.top.activeProcs[name] = true
	end
end


L.top.frame:RegisterEvent("UNIT_AURA")
L.top.frame:RegisterEvent("PLAYER_DEAD")
L.top.frame:SetScript("OnEvent", L.top.onEvent)
