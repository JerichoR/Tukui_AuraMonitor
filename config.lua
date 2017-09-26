local ADDON_NAME, ns = ...
local T, C, L = Tukui:unpack()

C["AuraMonitor"] = {
    ["AuraSize"] = 40,
    ["Font"] = "Tukui",
    ["FontSize"] = 18,
    -- ["FontFlags"] = "THICKOUTLINE",
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
    -- ["FontFlags"] = {
    --     ["Name"] = "Font Flags",
    --     ["Desc"] = "Set font style for cooldown and stack count",
    -- },
}
