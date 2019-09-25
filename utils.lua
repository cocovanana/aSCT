local A, L = ...

L.U = {}

L.U.CombatLog_Object_IsA = CombatLog_Object_IsA

L.U.isNone = COMBATLOG_OBJECT_NONE
L.U.isMine = COMBATLOG_FILTER_MINE
L.U.isMyPet = COMBATLOG_FILTER_MY_PET
L.U.isHostile = bit.bor(
            COMBATLOG_FILTER_HOSTILE_PLAYERS,
            COMBATLOG_FILTER_HOSTILE_UNITS
          )
L.U.isPlayer = bit.bor(
            COMBATLOG_OBJECT_AFFILIATION_MASK,
            COMBATLOG_OBJECT_REACTION_MASK,
            COMBATLOG_OBJECT_TYPE_PLAYER,
            COMBATLOG_OBJECT_CONTROL_PLAYER
          )

L.U.eventTypes = {
  ["SWING_DAMAGE"]                      = "DAMAGE",
  ["RANGE_DAMAGE"]                      = "DAMAGE",
  ["SPELL_DAMAGE"]                      = "DAMAGE",
  ["SPELL_PERIODIC_DAMAGE"]             = "DAMAGE",
  ["ENVIRONMENTAL_DAMAGE"]              = "DAMAGE",
  ["DAMAGE_SHIELD"]                     = "DAMAGE",
  ["DAMAGE_SPLIT"]                      = "DAMAGE",
  ["SPELL_HEAL"]                        = "HEAL",
  ["SPELL_PERIODIC_HEAL"]               = "HEAL",
  ["SWING_MISSED"]                      = "MISS",
  ["RANGE_MISSED"]                      = "MISS",
  ["SPELL_MISSED"]                      = "MISS",
  ["SPELL_PERIODIC_MISSED"]             = "MISS",
  ["DAMAGE_SHIELD_MISSED"]              = "MISS",
  ["SPELL_DRAIN"]                       = "DRAIN",
  ["SPELL_LEECH"]                       = "DRAIN",
  ["SPELL_PERIODIC_DRAIN"]              = "DRAIN",
  ["SPELL_PERIODIC_LEECH"]              = "DRAIN",
  ["SPELL_ENERGIZE"]                    = "POWER",
  ["SPELL_PERIODIC_ENERGIZE"]           = "POWER",
  ["SPELL_INTERRUPT"]                   = "INTERRUPT",
  ["PARTY_KILL"]                        = "DEATH",
  ["UNIT_DIED"]                         = "DEATH",
  ["UNIT_DESTROYED"]                    = "DEATH",
  ["SPELL_AURA_APPLIED"]                = "BUFF",
  ["SPELL_PERIODIC_AURA_APPLIED"]       = "BUFF",
  ["SPELL_AURA_APPLIED_DOSE"]           = "BUFF",
  ["SPELL_PERIODIC_AURA_APPLIED_DOSE"]  = "BUFF",
  ["SPELL_AURA_REMOVED"]                = "FADE",
  ["SPELL_PERIODIC_AURA_REMOVED"]       = "FADE",
  ["SPELL_AURA_REMOVED_DOSE"]           = "FADE",
  ["SPELL_PERIODIC_AURA_REMOVED_DOSE"]  = "FADE",
  ["ENCHANT_APPLIED"]                   = "ENCHANT_APPLIED",
  ["ENCHANT_REMOVED"]                   = "ENCHANT_REMOVED",
  ["SPELL_SUMMON"]                      = "SUMMON",
  ["SPELL_CREATE"]                      = "SUMMON",
  ["SPELL_DISPEL"]                      = "DISPEL",
  ["SPELL_STOLEN"]                      = "DISPEL",
  ["SPELL_CAST_START"]                  = "CAST",
  ["SPELL_CAST_SUCCESS"]                = "CAST"
}

L.U.schoolColors = {
  [-6]  = {0,    0,  255}, --mana
  [-5]  = {0,  128,  0  }, --pet heal
  [-4]  = {85,  85,  255}, --resists, absorbs, misses, etc.
  [-3]  = {128, 128, 128}, --pet swings
  [-2]  = {0,   255, 0  }, --heal
  [-1]  = {255, 0,   0  }, --received melee hits
  [0]   = {255, 255, 255}, --melee white hits
  [1]   = {255, 255, 0  }, --physical
  [2]   = {255, 230, 128}, --holy
  [4]   = {255, 128, 0  }, --fire
  [8]   = {77,  255, 77 }, --nature
  [16]  = {128, 255, 255}, --frost
  [32]  = {128, 128, 255}, --shadow
  [64]  = {255, 128, 255}, --arcane
  [3]   = {0,   255, 0  }, --holystrike
  [5]   = {0,   255, 0  }, --flamestrike
  [6]   = {255, 128, 0  }, --radiant
  [9]   = {0,   255, 0  }, --stormstrike
  [10]  = {0,   255, 0  }, --holystorm
  [12]  = {220, 220, 0  }, --firestorm
  [17]  = {0,   255, 0  }, --froststrike
  [18]  = {0,   255, 0  }, --holyfrost
  [20]  = {210, 80, 120},  --frostfire
  [24]  = {0,   255, 0  }, --froststorm
  [33]  = {210, 210, 255}, --shadowstrike
  [34]  = {170, 138, 170}, --twillight
  [36]  = {127, 0,   63 }, --shadowflame
  [40]  = {0,   90,  0  }, --plague
  [48]  = {210, 128, 160}, --shadowfrost
  [65]  = {0,   255, 0  }, --spellstrike
  [66]  = {255, 207, 160}, --divine
  [68]  = {0,   255, 0  }, --spellfire
  [72]  = {0,   255, 128}, --astral
  [80]  = {0,   255, 0  }, --spellfrost
  [96]  = {180, 120, 210}, --spellshadow
  [28]  = {90,  90,  255}, --elemental
  [124] = {163, 48,  201}, --chromatic
  [126] = {163, 48,  201}, --magic
  [127] = {163, 48,  201}  --chaos
}

function L.U.GetPoint(frame)
  if not frame then return end
  local point = {}
  point.a1, point.af, point.a2, point.x, point.y = frame:GetPoint()
  if point.af and point.af:GetName() then
    point.af = point.af:GetName()
  end
  return point
end

function L.U.ResetPoint(frame)
  if not frame then return end
  if not frame.defaultPoint then return end
  if InCombatLockdown() then return end
  local point = frame.defaultPoint
  frame:ClearAllPoints()
  if point.af and point.a2 then
    frame:SetPoint(point.a1 or "CENTER", point.af, point.a2, point.x or 0, point.y or 0)
  elseif point.af then
    frame:SetPoint(point.a1 or "CENTER", point.af, point.x or 0, point.y or 0)
  else
    frame:SetPoint(point.a1 or "CENTER", point.x or 0, point.y or 0)
  end
end

local function OnDragStart(self, button)
  if button == "LeftButton" then
    self:GetParent():StartMoving()
  end
end

local function OnDragStop(self)
  self:GetParent():StopMovingOrSizing()
end

function L.U.CreateDragFrame(parent)
  if not parent then return end

  parent.defaultPoint = L.U.GetPoint(parent)
  table.insert(L.DragFrames, parent)

  local df = CreateFrame("Frame", nil, parent)
  df:SetAllPoints(parent)
  df:SetFrameStrata("HIGH")
  df:EnableMouse(true)
  df:RegisterForDrag("LeftButton")
  df:SetScript("OnDragStart", OnDragStart)
  df:SetScript("OnDragStop", OnDragStop)
  df:Hide()

  local t = df:CreateTexture(nil, "OVERLAY", nil, 6)
  t:SetAllPoints(df)
  t:SetColorTexture(1,1,1)
  t:SetVertexColor(0,1,0)
  t:SetAlpha(0.3)
  df.texture = t

  parent.dragFrame = df
  parent:SetMovable(true)
  parent:SetUserPlaced(true)
end

function L.U.UnlockDrag(str)
  for i, frame in ipairs(L.DragFrames) do
    if frame:IsUserPlaced() then
      if frame.frameVisibility then
        if frame.frameVisibilityFunc then
          UnregisterStateDriver(frame, frame.frameVisibilityFunc)
        end
        RegisterStateDriver(frame, "visibility", "show")
      end
    end
    frame.dragFrame:Show()
  end
  print(str)
end

function L.U.LockDrag(str)
  for i, frame in ipairs(L.DragFrames) do
    if frame:IsUserPlaced() then
      if frame.frameVisibility then
        if frame.frameVisibilityFunc then
          UnregisterStateDriver(frame, "visibility")
          --hack to make it refresh properly, otherwise if you had state n (no vehicle exit button) it would not update properly because the state n is still in place
          RegisterStateDriver(frame, frame.frameVisibilityFunc, "zorkwashere")
          RegisterStateDriver(frame, frame.frameVisibilityFunc, frame.frameVisibility)
        else
          RegisterStateDriver(frame, "visibility", frame.frameVisibility)
        end
      end
    end
    frame.dragFrame:Hide()
  end
  print(str)
end

function L.U.ResetDrag(str)
  if InCombatLockdown() then
    print("|c00FF0000ERROR:|r "..str.." not allowed while in combat!")
    return
  end
  for i, frame in ipairs(L.DragFrames) do
    L.U.ResetPoint(frame)
  end
  print(str)
end
