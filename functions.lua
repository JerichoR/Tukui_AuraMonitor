local ADDON_NAME, ns = ...

local monitor = ns.monitor
local auras = ns.auras
local config = ns.config
local font = config.font
local playerGUID

monitor.updateTimer = function(aura, elapsed)
    if aura.nextUpdate > 0 then
        aura.nextUpdate = aura.nextUpdate - elapsed
		return
    end
	
	aura.nextUpdate = aura.updatefreq
	
	if not aura.expirationTime then 
		_, _, _, aura.stacks, _, _, aura.expirationTime = UnitAura("player", aura.name, nil, aura.filter)
		if ns.debug then ChatFrame1:AddMessage("AuraMonitor: Timerinit: name " .. aura.name .. ", stacks " .. (aura.stacks or "na") .. ", expirationTime " .. (aura.expirationTime or "na")) end
		return
	end
	
	local remaining = aura.expirationTime - GetTime()
	if remaining < 0 then
		aura:hideAura()
	elseif remaining < aura.treshhold_red then -- red color for timer < treshhold_red s
		aura.cd:SetFormattedText("|cffff0000%2.1f|r", remaining)
		aura.nextUpdate = 0.1
	elseif remaining < aura.treshhold_show then -- default color 
		aura.cd:SetFormattedText("|cffffffff%d|r", remaining)
	else -- dont show timer > treshhold_show s
		aura.cd:SetText("")
	end
	if aura.stacks and aura.stacks > 0 then
		aura.count:SetFormattedText("|cffffffff%d|r", aura.stacks)
	end
end

monitor.hideAura = function(aura) 
	local icon, cd, count = aura.icon, aura.cd, aura.count
	aura:SetScript("OnUpdate", nil)
	aura:Hide()
	icon:Hide()
	cd:Hide()
	cd:SetText("")
	count:Hide()
	count:SetText("")
end

monitor.showAura = function(aura)
	if not aura:IsShown() then
		local icon, cd, count = aura.icon, aura.cd, aura.count
        aura:Show()
        icon:Show()
        cd:Show()
        count:Show()
		aura:SetScript("OnUpdate", aura.updateTimer)
	end
end

monitor.COMBAT_LOG_EVENT_UNFILTERED = function(self, event, timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, ...)
	if destGUID ~= playerGUID then return end
	local aura = self.tracked[spellId]
	if aura and monitor[subevent] then 
		monitor[subevent](aura)
	end
end

monitor.SPELL_AURA_APPLIED = function(aura) 
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: SPELL_AURA_APPLIED: " .. aura.name) end
	
	aura.nextUpdate = 0
	aura.expirationTime = nil
	aura:showAura()
end

monitor.SPELL_AURA_REMOVED = function(aura)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: SPELL_AURA_REMOVED: " .. aura.name) end
	aura:hideAura()
end

monitor.SPELL_AURA_APPLIED_DOSE = function(aura)
	monitor.SPELL_AURA_APPLIED(aura)
end

monitor.SPELL_AURA_REFRESH = function(aura) 
	monitor.SPELL_AURA_APPLIED(aura)
end

monitor.SPELL_AURA_REMOVED_DOSE = function(aura)
	monitor.SPELL_AURA_APPLIED(aura)
end 

monitor.createAura = function(self, spellId, settings, row) 
	local name, _, image = GetSpellInfo(spellId)
            
	local aura = CreateFrame("Frame", nil, self)
	aura:SetSize(config.aura.width, config.aura.height)
	aura:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", (config.aura.width + config.aura.spacing) * settings.index, (config.aura.height + config.aura.spacing) * row)
	aura.updatefreq = 0.3
	aura.treshhold_show = settings.show
	aura.treshhold_red = settings.red
	aura.filter = settings.filter
	
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
	
	aura.updateTimer = self.updateTimer
	aura.showAura = self.showAura
	aura.hideAura = self.hideAura
	aura.spellId = spellID
	aura.name = name
	
	aura:Hide()
	icon:Hide()
	cd:Hide()
	count:Hide()
	
	self.tracked[spellId] = aura
end

monitor.PLAYER_LOGIN = function(monitor, event)
	local myClass = select(2, UnitClass("player"))
	playerGUID = UnitGUID("player")

	if IsAddOnLoaded("Tukui") then
	    local T, C, L = Tukui:unpack()
	    
	    config.aura.width = C.AuraMonitor.AuraSize
	    config.aura.height = C.AuraMonitor.AuraSize
	    config.aura.count.fontSize = C.AuraMonitor.FontSize
	    config.aura.cd.fontSize = C.AuraMonitor.FontSize

	    -- extract font path
	    local deleteme = monitor:CreateFontString(nil, "BACKGROUND")
	    deleteme:SetFontObject(T.GetFont(C.AuraMonitor.Font))
	    deleteme:Hide()
	    config.font, _, _ = deleteme:GetFont()
	    
	    -- create mover
	    local mover = CreateFrame("Frame", "AuraMonitorMover", UIParent)
	    mover:SetSize(4 * config.aura.width + 3 * config.aura.spacing, config.aura.height)
	    mover:SetPoint(unpack(config.anchor))
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
	    T.Movers:RegisterFrame(mover)
	end

    if auras[myClass] then
        for spellId, settings in pairs(auras[myClass]) do
            monitor:createAura(spellId, settings, 0)
        end
		for spellId, settings in pairs(auras["RAID"]) do
			monitor:createAura(spellId, settings, 1)
		end
		monitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
