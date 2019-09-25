local A, L = ...

L.core = CreateFrame("Frame")

L.left = CreateFrame("ScrollingMessageFrame", "aProc", UIParent)
L.left:SetPoint(unpack(L.C.left.point))
L.left:SetFont("Fonts\\FRIZQT__.TTF", L.C.left.fontSize, "OUTLINE")
L.left:SetWidth(L.C.left.width)
L.left:SetHeight(L.C.left.height)
L.left:SetFadeDuration(L.C.left.procFadeDuration)
L.left:SetTimeVisible(L.C.left.procDuration)
L.left:SetJustifyV("MIDDLE")
L.left:SetJustifyH(L.C.left.align)
L.left:Show()

L.right = CreateFrame("ScrollingMessageFrame", "aProc", UIParent)
L.right:SetPoint(unpack(L.C.right.point))
L.right:SetFont("Fonts\\FRIZQT__.TTF", L.C.right.fontSize, "OUTLINE")
L.right:SetWidth(L.C.right.width)
L.right:SetHeight(L.C.right.height)
L.right:SetFadeDuration(L.C.right.procFadeDuration)
L.right:SetTimeVisible(L.C.right.procDuration)
L.right:SetJustifyV("MIDDLE")
L.right:SetJustifyH(L.C.right.align)
L.right:Show()


function L.core.onEvent(self, event, ...)
  local targetFrame = L.left
  local text, color, texture
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, additionalReturns = CombatLogGetCurrentEventInfo()
  local eventType = L.U.eventTypes[event]
  if not eventType then return end

--  if (event == "SPELL_DAMAGE" and sourceName == destName and CombatLog_Object_IsA(destFlags, L.U.isHostile)) then
--    --isReflect
--    return
--  end

  local toPlayer, fromPlayer, toPet, fromPet
  if (sourceName and not CombatLog_Object_IsA(sourceFlags, L.U.isNone) ) then
    fromPlayer = CombatLog_Object_IsA(sourceFlags, L.U.isMine)
    fromPet = CombatLog_Object_IsA(sourceFlags, L.U.isMyPet)
  end
  if (destName and not CombatLog_Object_IsA(destFlags, L.U.isNone) ) then
    toPlayer = CombatLog_Object_IsA(destFlags, L.U.isMine)
    toPet = CombatLog_Object_IsA(destFlags, L.U.isMyPet)
  end

  if not fromPlayer and not toPlayer and not fromPet and not toPet then return end

  if eventType == "DAMAGE" then
    if event == "SWING_DAMAGE" then
      amount, overDamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
    elseif event == "ENVIRONMENTAL_DAMAGE" then
      environmentalType, amount, overDamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
    else
      spellId, spellName, spellSchool, amount, overDamage, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
      texture = select(3, GetSpellInfo(spellId))
    end

    if amount <= L.C.threshold then return end

    text = amount
    if critical then text = amount..L.C.critChar end
    if crushing then text = amount..L.C.crushChar end
    if glancing then text = amount..L.C.glanceChar end
    if absorbed then text = "A("..amount..")" end
    if blocked  then text = "B("..amount..")" end
    if resisted then text = "R("..amount..")" end

    if toPlayer then
      text = "-"..text
      if event == "SWING_DAMAGE" then
        color = L.U.schoolColors[-1]
      else
        color = L.U.schoolColors[school]
      end
    end

    if toPet then
      text = L.C.dmgChar..text
      color = L.U.schoolColors[-3]
    end

    if fromPlayer then
      targetFrame = L.right
      if event == "SWING_DAMAGE" then
        color = L.U.schoolColors[0]
      else
        color = L.U.schoolColors[school]
      end
    end

    if fromPet then
      targetFrame = L.right
      if event == "SWING_DAMAGE" then
        color = L.U.schoolColors[-3]
      else
        color = L.U.schoolColors[school]
      end
    end

    if (texture and L.C.showIcons) then
      text = text.." |T"..texture..":"..L.C.iconSize.."|t"
    end

    targetFrame:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)

  elseif eventType == "HEAL" then
    local texture, text
    local color = L.U.schoolColors[-2]

    spellId, spellName, spellSchool, amount, overHeal, absorbed, critical = select(12, CombatLogGetCurrentEventInfo())
    if amount < L.C.threshold then return end

    if overHeal > 0 then
      text = L.C.healChar..amount-overHeal.." {"..overHeal.."}"
    else
      text = L.C.healChar..amount
    end
    texture = select(3, GetSpellInfo(spellId))

    if toPlayer then
      L.left:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    elseif toPet then
      color = L.U.schoolColors[-5]
      L.left:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    elseif fromPlayer then
      L.right:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    elseif fromPet then
      color = L.U.schoolColors[-5]
      L.right:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    end

  elseif eventType == "MISS" then
    local color = L.U.schoolColors[-4]
    local missType, texture, text

    if event == "SWING_MISSED" or event == "RANGE_MISSED" then
      missType = select(12, CombatLogGetCurrentEventInfo())
    else
      spellId, spellName, spellSchool, missType = select(12, CombatLogGetCurrentEventInfo())
      texture = select(3, GetSpellInfo(spellId))
    end

    text = _G[missType]

    if toPlayer then
      L.left:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    elseif fromPlayer then
      L.right:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    end

  elseif eventType == "POWER" then
    local texture, text
    local color = L.U.schoolColors[-6]

    spellId, spellName, spellSchool, amount, totalAmount, powerType = select(12, CombatLogGetCurrentEventInfo())
    if amount <= L.C.threshold then return end
    if (powerType == 0 and not L.C.enableMana) then return end
    if (powerType ~= 0 and not L.C.enableOtherResources) then return end

    texture = select(3, GetSpellInfo(spellId))
    text = L.C.manaChar..amount

    if toPlayer then
      L.left:AddMessage(text, color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    end

  elseif eventType == "INTERRUPT" then
    spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool = select(12, CombatLogGetCurrentEventInfo())
    if toPlayer then
      local color = L.U.schoolColors[-4]
      L.left:AddMessage("I!", color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
      --L.left:AddMessage("I! |T"..extraSpellId..":"..L.C.left.fontSize.."|t", 0.3, 0.3, 1, L.C.chatInfo, 0.5)
    end

  elseif eventType == "DISPEL" then
    spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool, auraType = select(12, CombatLogGetCurrentEventInfo())
    if fromPlayer then
      local color = L.U.schoolColors[-4]
      L.right:AddMessage("D!", color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
      --L.right:AddMessage("D! |T"..extraSpellId..":"..L.C.right.fontSize.."|t", 0.3, 0.3, 1, L.C.chatInfo, 0.5)
    end

  elseif eventType == "DEATH" then
    if fromPlayer then
      local color = L.U.schoolColors[-4]
      L.right:AddMessage("K!", color[1]/255, color[2]/255, color[3]/255, L.C.chatInfo, 0.5)
    end
  end
end

L.core:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
L.core:SetScript("OnEvent", L.core.onEvent)
