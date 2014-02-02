local ADDON_NAME, ns = ...

ns.debug = false

local auras = ns.auras
local font = "Fonts\\FRIZQT__.TTF"
local config = ns.config
local myClass = select(2, UnitClass("player"))

if ns.debug then ChatFrame1:AddMessage("AuraMonitor loaded") end
local monitor = CreateFrame("Frame", "AuraMonitor", UIParent)

ns.tracked = {}
ns.active = {}
ns.passive = {}

if IsAddOnLoaded("Tukui") then
    local T, C, _ = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
    
    font = C.media.font
    
    local mover = CreateFrame("Frame", "AuraMonitorMover", UIParent)
    mover:SetSize(4 * ( config.aura.width + config.aura.spacing ) - config.aura.spacing, config.aura.height)
    mover:SetPoint(unpack(config.monitor.anchor))
    mover:SetTemplate("Default")
    mover:SetBackdropBorderColor(1, 0, 0, 1)
    mover:SetMovable(true)
    mover:Hide()

    mover.text = mover:CreateFontString(nil, "OVERLAY")
    mover.text:SetFont(font, 12)
    mover.text:SetPoint("CENTER")
    mover.text:SetText("AuraMonitor")
    mover.text.Show = function() mover:Show() end
    mover.text.Hide = function() mover:Hide() end

    monitor:SetAllPoints(mover)
    table.insert(T.AllowFrameMoving, mover)
else
    monitor:SetAllPoints("CENTER", UIParent, "CENTER", config.monitor.posx, config.monitor.posy)
end

if auras[myClass] then
    for spellID, settings in pairs(auras[myClass]) do
        local _, _, image = GetSpellInfo(spellID)
        
        local aura = CreateFrame("Frame", nil, monitor)
        aura:SetSize(config.aura.width, config.aura.height)
        aura:SetPoint("LEFT", monitor, "LEFT", (config.aura.width + config.aura.spacing) * settings.index, 0)
        aura.updatefreq = 0.3
        aura.treshhold_show = settings.show
        aura.treshhold_red = settings.red
        
        local icon = aura:CreateTexture(nil, "OVERLAY")
        icon:SetAllPoints(aura)
        icon:SetTexture(image)
        aura.icon = icon
        
        local cdConf = config.aura.cd
        local cd = aura:CreateFontString(nil, "OVERLAY")
        cd:SetFont(font, cdConf.fontSize, cdConf.fontFlag)
        cd:SetPoint(cdConf.position[1], aura, cdConf.position[2], cdConf.position[3], cdConf.position[4])
        aura.cd = cd
        
        local countConf = config.aura.count
        local count = aura:CreateFontString(nil, "OVERLAY")
        count:SetFont(font, countConf.fontSize, countConf.fontFlag)
        count:SetPoint(countConf.position[1], aura, countConf.position[2], countConf.position[3], countConf.position[4])
        aura.count = count
        
        aura.update = ns.update
        
        aura:Hide()
        icon:Hide()
        cd:Hide()
        count:Hide()
        
        ns.tracked[spellID] = true
        ns.passive[spellID] = aura
    end
end

ns.OnAuraChanged(monitor, "UNIT_AURA", "player")
monitor:RegisterEvent("UNIT_AURA")
monitor:SetScript("OnEvent", ns.OnAuraChanged)
