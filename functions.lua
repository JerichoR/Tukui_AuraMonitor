local ADDON_NAME, ns = ...

local monitor = AuraMonitor
local auras = ns.auras
local config = ns.config
local font = config.font
local playerGUID

monitor.updateTimer = function(self, elapsed)
    if self.nextUpdate > 0 then
        self.nextUpdate = self.nextUpdate - elapsed
		return
    end
	
	if not self.expirationTime then 
		_, _, _, self.stacks, _, _, self.expirationTime, _, _, _, _ = UnitAura("player", self.name)
		self.nextUpdate = 0.1
		return
	end
	
	self.nextUpdate = self.updatefreq
	
	local remaining = self.expirationTime - GetTime()
	if remaining < self.treshhold_red then -- red color for timer < treshhold_red s
		self.cd:SetFormattedText("|cffff0000%2.1f|r", remaining)
		self.nextUpdate = 0.1
	elseif remaining < self.treshhold_show then -- default color 
		self.cd:SetFormattedText("|cffffffff%d|r", remaining)
	else -- dont show timer > treshhold_show s
		self.cd:SetText("")
	end
	if self.stacks and self.stacks > 0 then
		self.count:SetFormattedText("|cffffffff%d|r", self.stacks)
	end
end

monitor.COMBAT_LOG_EVENT_UNFILTERED = function(self, event, timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, auraType, amount)
	if sourceGUID ~= playerGUID then return end
	local aura = self.tracked[spellName]
	if aura and monitor[subevent] then 
		monitor[subevent](aura)
	end
end

monitor.SPELL_AURA_APPLIED = function(aura) 
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: SPELL_AURA_APPLIED: " .. aura.name) end
	
	aura.nextUpdate = 0
	aura.expirationTime = nil
	
	if not aura:IsShown() then
		local icon, cd, count = aura.icon, aura.cd, aura.count
        aura:Show()
        icon:Show()
        cd:Show()
        count:Show()
		aura:SetScript("OnUpdate", aura.updateTimer)
	end
end

monitor.SPELL_AURA_APPLIED_DOSE = function(aura)
	monitor.SPELL_AURA_APPLIED(aura)
end

monitor.SPELL_AURA_REFRESH = function(aura)
	monitor.SPELL_AURA_APPLIED(aura)
end

monitor.SPELL_AURA_REMOVED = function(aura)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: SPELL_AURA_REMOVED: " .. aura.name) end
	
	local icon, cd, count = aura.icon, aura.cd, aura.count
	aura:SetScript("OnUpdate", nil)
	aura:Hide()
	icon:Hide()
	cd:Hide()
	cd:SetText("")
	count:Hide()
	count:SetText("")
end

monitor.SPELL_AURA_REMOVED_DOSE = function(aura)
	monitor.SPELL_AURA_APPLIED(aura)
end

monitor.ADDON_LOADED = function(monitorFrame, event, addon)
	local myClass = select(2, UnitClass("player"))
	playerGUID = UnitGUID("player")
    if auras[myClass] then
        for spellId, settings in pairs(auras[myClass]) do
            local name, _, image = GetSpellInfo(spellId)
            
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
            
            aura.updateTimer = monitor.updateTimer
            aura.spellId = spellID
            aura.name = name
            
            aura:Hide()
            icon:Hide()
            cd:Hide()
            count:Hide()
            
            monitor.tracked[name] = aura
        end
		monitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end