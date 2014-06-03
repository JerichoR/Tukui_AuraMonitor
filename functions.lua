local ADDON_NAME, ns = ...

local monitor = AuraMonitor
local auras = ns.auras
local myClass = select(2, UnitClass("player"))
local config = ns.config
local font = config.font

monitor.updateTimer = function(self, elapsed)
    if self.nextUpdate > 0 then
        self.nextUpdate = self.nextUpdate - elapsed
    else
        self.nextUpdate = self.updatefreq
        local remaining = self.expirationTime - GetTime()
		if remaining < 0 then
			if self:IsShown() then
				local icon, cd, count = self.icon, self.cd, self.count
				
				self:Hide()
				icon:Hide()
				cd:Hide()
				cd:SetText("")
				count:Hide()
				count:SetText("")
			end
			self:SetScript("OnUpdate", nil)
			return
        elseif remaining < self.treshhold_red then -- red color for timer < treshhold_red s
            self.cd:SetFormattedText("|cffff0000%2.1f|r", remaining)
            self.nextUpdate = 0.1
        elseif remaining < self.treshhold_show then -- default color 
            self.cd:SetFormattedText("|cffffffff%d|r", remaining)
        else -- dont show timer > treshhold_show s
            self.cd:SetText("")
        end
        if self.stacks > 0 then
            self.count:SetFormattedText("|cffffffff%d|r", self.stacks)
        end
    end
end
    
monitor.updateAura = function(aura, stacks, expirationTime)
    if ns.debug then ChatFrame1:AddMessage("AuraMonitor: updateAura ".. aura.name .. " expires " .. expirationTime) end
    
    aura.nextUpdate = 0
    aura.expirationTime = expirationTime
    aura.stacks = stacks
    aura:SetScript("OnUpdate", aura.updateTimer)
	
    if not aura:IsShown() then
        local icon, cd, count = aura.icon, aura.cd, aura.count
        
		aura:SetScript("OnUpdate", aura.updateTimer)
		
        aura:Show()
        icon:Show()
        cd:Show()
        count:Show()
    end
end

monitor.UNIT_AURA = function(monitorFrame, event, unit)
    if ns.debug then ChatFrame1:AddMessage("AuraMonitor: ".. UnitName(unit)) end
    
    if not UnitIsUnit(unit, "player") then return end
	
    for name, aura in pairs(monitor.tracked) do
        local _, _, _, count, _, _, expirationTime, _, _, _, _ = UnitAura("player", name)
		if expirationTime and expirationTime > GetTime() then
			monitor.updateAura(aura, count, expirationTime)
		end
    end
end

monitor.ADDON_LOADED = function(monitorFrame, event, addon)
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
    end
    
    monitor:UNIT_AURA("UNIT_AURA", "player")
end