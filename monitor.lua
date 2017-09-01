local ADDON_NAME, ns = ...

ns.debug = false
if ns.debug then ChatFrame1:AddMessage("AuraMonitor loading") end

local config = ns.config

local monitor = CreateFrame("Frame", "AuraMonitor", UIParent)
monitor:SetPoint(unpack(config.anchor))

monitor.tracked = {}

monitor:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
monitor:RegisterEvent("PLAYER_LOGIN")
--monitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

ns.monitor = monitor