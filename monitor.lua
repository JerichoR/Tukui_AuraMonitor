local ADDON_NAME, ns = ...

ns.debug = false
if ns.debug then ChatFrame1:AddMessage("AuraMonitor loading") end

local config = ns.config

local monitor = CreateFrame("Frame", "AuraMonitor", UIParent)
monitor.tracked = {}

if IsAddOnLoaded("Tukui") then
    local T, C, _ = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
    
    config.font = C.media.font
    
    local mover = CreateFrame("Frame", "AuraMonitorMover", UIParent)
    mover:SetSize(4 * config.aura.width + 3 * config.aura.spacing, config.aura.height)
    mover:SetPoint(unpack(config.monitor.anchor))
    mover:SetTemplate("Default")
    mover:SetBackdropBorderColor(1, 0, 0, 1)
    mover:SetMovable(true)
    mover:Hide()

    mover.text = mover:CreateFontString(nil, "OVERLAY")
    mover.text:SetFont(config.font, 12)
    mover.text:SetPoint("CENTER")
    mover.text:SetText("AuraMonitor")
    mover.text.Show = function() mover:Show() end
    mover.text.Hide = function() mover:Hide() end

    monitor:SetAllPoints(mover)
    table.insert(T.AllowFrameMoving, mover)
else
    monitor:SetAllPoints("CENTER", UIParent, "CENTER", config.monitor.posx, config.monitor.posy)
end

monitor:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
monitor:RegisterEvent("PLAYER_LOGIN")
--monitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
