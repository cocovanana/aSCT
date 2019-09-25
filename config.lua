local A, L = ...

L.C = {
  threshold = 0, --maximum amount to show damage for
  showIcons = true,
  iconSize = 16,
  chatInfo = ChatTypeInfo["RAID_WARNING"],
  critChar = "*",
  glanceChar = "~",
  crushChar = "<<",
  dmgChar = "-",
  healChar = "+",
  enableMana = true,
  enableOtherResources = false, --rage, energy
  manaChar = "+",
  top = {
    point = {"CENTER", UIParent, "CENTER", 0, 200},
    width = 400,
    height = 50,
    fontSize = 20,
    procDuration = 1,
    procFadeDuration = 0.5,
    blacklist = {
    	"Drenar alma",
      "Drain Soul",
      "Cauce de salud",
      "Health Funnel"
    }
  },
  left = {
    point = {"CENTER", UIParent, "CENTER", -160, 90},
    width = 100,
    height = 300,
    fontSize = 20,
    procDuration = 2,
    procFadeDuration = 1,
    align = "RIGHT"
  },
  right = {
    point = {"CENTER", UIParent, "CENTER", 160, 90},
    width = 100,
    height = 300,
    fontSize = 20,
    procDuration = 2,
    procFadeDuration = 1,
    align = "LEFT"
  }
}
