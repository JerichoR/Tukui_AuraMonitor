local ADDON_NAME, ns = ...
local T, C, L = Tukui:unpack()

ns.debug = false
if ns.debug then ChatFrame1:AddMessage("AuraMonitor loading") end

local monitor = CreateFrame("Frame", "AuraMonitor", UIParent)
local auraSize = C.AuraMonitor.AuraSize
local font, _, fontFlags = T.GetFont(C.AuraMonitor.Font)


-- create mover
local mover = CreateFrame("Frame", "AuraMonitorMover", UIParent)
mover:SetSize(4 * auraSize + 3 * 2, auraSize)
mover:SetPoint("TOPLEFT", UIParent, "RIGHT", -700, 60)
mover:SetTemplate("Default")
mover:SetBackdropBorderColor(1, 0, 0, 1)
mover:SetMovable(true)
mover:Hide()

mover.text = mover:CreateFontString(nil, "OVERLAY")
mover.text:SetFont(font, 12, fontFlags)
mover.text:SetPoint("CENTER")
mover.text:SetText("AuraMonitor")
mover.text.Show = function() mover:Show() end
mover.text.Hide = function() mover:Hide() end

monitor:SetAllPoints(mover)
T.Movers:RegisterFrame(mover)


monitor.tracked = {}

monitor:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
monitor:RegisterEvent("PLAYER_LOGIN")
--monitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

ns.monitor = monitor