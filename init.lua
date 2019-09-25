local A, L = ...

L.DragFrames    = {}

SlashCmdList["asct"] = function(cmd)
	if (cmd:match"unlock") then
		L.U.UnlockDrag("|cff1a9fc0aSCT|r frames unlocked")
	elseif (cmd:match"lock") then
		L.U.LockDrag("|cff1a9fc0aSCT|r frames locked")
	elseif (cmd:match"reset") then
		L.U.ResetDrag("|cff1a9fc0aSCT|r frames reset")
	else
		print("|cff1a9fc0aSCT command list:|r")
		print("|cff1a9fc0\/asct lock|r, to lock all frames")
		print("|cff1a9fc0\/asct unlock|r, to unlock all frames")
		print("|cff1a9fc0\/asct reset|r, to reset all frames")
	end
end

_G["SLASH_asct1"] = "/asct"
print("|cff1a9fc0aSCT loaded.|r")
print("|cff1a9fc0asct|r to display the command list")

L.U.CreateDragFrame(L.left)
L.U.CreateDragFrame(L.right)
L.U.CreateDragFrame(L.top.frame)
