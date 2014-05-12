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
        self.nextUpdate = self.updatefreq or 0.5
        local remaining = self.expiryTime - GetTime()
        if remaining < self.treshhold_red then -- red color for timer < treshhold_red s
            self.cd:SetFormattedText("|cffff0000%d|r", remaining)
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
    
monitor.resetIcon = function(aura, spellID, stacks, expires)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: resetIcon ".. spellID .. " expires " .. expires) end
	
	local icon, cd, count = aura.icon, aura.cd, aura.count
    
    aura.nextUpdate = 0
    aura.expiryTime = expires
    aura.stacks = stacks
    
    aura:SetScript("OnUpdate", aura.updateTimer)
	
    aura:Show()
    icon:Show()
    cd:Show()
    count:Show()
    
	monitor.active[spellID] = aura
	monitor.passive[spellID] = nil
end

monitor.expireIcon = function(aura, spellID)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: expireIcon ".. spellID) end
	
	local icon, cd, count = aura.icon, aura.cd, aura.count
    
    aura:Hide()
	icon:Hide()
    cd:Hide()
    count:Hide()
    
    cd:SetText("")
    count:SetText("")
    aura:SetScript("OnUpdate", nil)
	
    monitor.active[spellID] = nil
	monitor.passive[spellID] = aura
end

monitor.UNIT_AURA = function(monitorFrame, event, unit)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: ".. UnitName(unit)) end
	
	if not UnitIsUnit(unit, "player") then return end
	
	local index = 1
	local current = {}
	
	repeat 
		local name, _, _, count, _, _, expires, _, _, _, spellID = UnitAura(unit, index)
        
		if ns.debug and spellID then ChatFrame1:AddMessage("AuraMonitor: ".. name .. " - " .. spellID) end
        
		if monitor.tracked[spellID] then
			tinsert(current, spellID, { count, expires })
		end
        
		index = index + 1
	until spellID == nil
	
	for spellID, aura in pairs(monitor.active) do
		if not current[spellID] then
			monitor.expireIcon(aura, spellID)
        else
            local count, expires = unpack(current[spellID])
            aura.stacks = count
            aura.expiryTime = expires
		end
	end
	
	for spellID, aura in pairs(monitor.passive) do
		if current[spellID] then
			local count, expires = unpack(current[spellID])
			monitor.resetIcon(aura, spellID, count, expires)
		end
	end 
end

monitor.ADDON_LOADED = function(monitorFrame, event, addon)
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
			
			aura.updateTimer = monitor.updateTimer
			
			aura:Hide()
			icon:Hide()
			cd:Hide()
			count:Hide()
			
			monitor.tracked[spellID] = true
			monitor.passive[spellID] = aura
		end
	end
	
	monitor:UNIT_AURA("UNIT_AURA", "player")
end