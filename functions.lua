local ADDON_NAME, ns = ...

ns.update = function(self, elapsed)
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
    
ns.resetIcon = function(aura, spellID, stacks, expires)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: resetIcon ".. spellID .. " expires " .. expires) end
	
	local icon, cd, count = aura.icon, aura.cd, aura.count
    
    aura.nextUpdate = 0
    aura.expiryTime = expires
    aura.stacks = stacks
    
    aura:SetScript("OnUpdate", aura.update)
	
    aura:Show()
    icon:Show()
    cd:Show()
    count:Show()
    
	ns.active[spellID] = aura
	ns.passive[spellID] = nil
end

ns.expireIcon = function(aura, spellID)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: expireIcon ".. spellID) end
	
	local icon, cd, count = aura.icon, aura.cd, aura.count
    
    aura:Hide()
	icon:Hide()
    cd:Hide()
    count:Hide()
    
    cd:SetText("")
    count:SetText("")
    aura:SetScript("OnUpdate", nil)
	
    ns.active[spellID] = nil
	ns.passive[spellID] = aura
end

ns.OnAuraChanged = function(monitorFrame, event, unit)
	if ns.debug then ChatFrame1:AddMessage("AuraMonitor: ".. UnitName(unit)) end
	
	if not UnitIsUnit(unit, "player") then return end
	
	local index = 1
	local current = {}
	
	repeat 
		local name, _, _, count, _, _, expires, _, _, _, spellID = UnitAura(unit, index)
        
		if ns.debug and spellID then ChatFrame1:AddMessage("AuraMonitor: ".. name .. " - " .. spellID) end
        
		if ns.tracked[spellID] then
			tinsert(current, spellID, { count, expires })
		end
        
		index = index + 1
	until spellID == nil
	
	for spellID, aura in pairs(ns.active) do
		if not current[spellID] then
			ns.expireIcon(aura, spellID)
        else
            local count, expires = unpack(current[spellID])
            aura.stacks = count
            aura.expiryTime = expires
		end
	end
	
	for spellID, aura in pairs(ns.passive) do
		if current[spellID] then
			local count, expires = unpack(current[spellID])
			ns.resetIcon(aura, spellID, count, expires)
		end
	end 
end