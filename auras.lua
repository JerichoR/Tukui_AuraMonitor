local ADDON_NAME, ns = ...

ns.auras = {
	PRIEST = {
		-- Shadow
        -- Holy
		--[139] = { index=3, show=15, red=4 }, -- Renew
		-- Discipline
		--[77613] = { index=4, show=16, red=6 }, -- Grace
	},
	PALADIN = {
        [90174] = { index=0, show=9, red=9 }, -- Divine Purpose
        -- Holy
        [54149] = { index=1, show=16, red=6 }, -- Infusion of Light
        -- Protection
        [20925] = { index=1, show=31, red=7 }, -- Sacred Shield
        [114637] = { index=2, show=21, red=5 }, -- Bastion of Glory
        [94686] = { index=3, show=9, red=9 }, -- Supplication
        -- Special
        [144359] = { index=4, show=21, red=21 }, -- Gift of the Titans
	},
    DEATHKNIGHT = {
        -- Frost
        [51124] = { index=0, show=11, red=6 }, -- Killing Machine
        [59052] = { index=1, show=16, red=6 }, -- Freezing Fog (Rime Proc)
        [101568] = { index=2, show=16, red=6 }, -- Dark Succor
    },
}