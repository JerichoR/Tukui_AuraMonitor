local ADDON_NAME, ns = ...

ns.config = {
	anchor = { "TOPLEFT", UIParent, "RIGHT", -700, 60 },
    font = "Fonts\\FRIZQT__.TTF",
	aura = { 
        width = 40, 
        height = 40, 
        spacing = 2, 
        count = {
            fontSize = 18, 
            fontFlag = "THICKOUTLINE", 
            position = { "TOPLEFT", "TOPLEFT", -3, 2 },
        },
        cd = {
            fontSize = 18, 
            fontFlag = "THICKOUTLINE",
            position = { "BOTTOMRIGHT", "BOTTOMRIGHT", 7, -4 },
        },
    },
}

if IsAddOnLoaded("Tukui") then
    local T, C, L = Tukui:unpack()

    C["AuraMonitor"] = {
        ["AuraSize"] = 40,
        ["Font"] = "Tukui",
        ["FontSize"] = 18,
    }

    TukuiConfig["enUS"]["AuraMonitor"] = {
        ["AuraSize"] = {
            ["Name"] = "Aura Size",
            ["Desc"] = "Set size for an aura icon",
        },
        ["Font"] = {
            ["Name"] = "AuraMonitor Font",
            ["Desc"] = "Set a font for the AuraMonitor",
        },
        ["FontSize"] = {
            ["Name"] = "Font Size",
            ["Desc"] = "Set font size for cooldown and stack count",
        },
    }
end