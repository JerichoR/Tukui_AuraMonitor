local ADDON_NAME, ns = ...

ns.config = {
	monitor = { 
        width = 40, 
        height = 40, 
        posx = 400, 
        posy = 50, 
		anchor = { "BOTTOMLEFT", "TukuiTarget", "TOP", 0, 460 }, -- for Tukui only
    },
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
	font = "Fonts\\FRIZQT__.TTF",
}