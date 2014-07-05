local ADDON_NAME, ns = ...

ns.auras = {
	RAID = {
		[147207] = { index=0, show=60, red=10 }, -- Weakened Resolve (Sha of Pride)
		[144359] = { index=1, show=20, red=20 }, -- Gift of Titans Healer (Sha of Pride) 
		[146594] = { index=1, show=20, red=20 }, -- Gift of Titans DPS (Sha of Pride)
		[147029] = { index=0, show=7, red=7 },   -- Flames of Galakrond (Galakras)
		[144089] = { index=0, show=30, red=10 }, -- Toxic Mist (Dark Shamans)
		[144330] = { index=1, show=60, red=10 }, -- Iron Prison (Dark Shamans)
		--[139] = { index=4, show=10, red=4 }, -- Renew
	},
    PRIEST = {
        -- Shadow
		[137590] = { index=3, show=11, red=11 }, -- Tempus Repit
        -- Holy
        -- Discipline
        [81700] = { index=0, show=19, red=6 },  -- Archangel
        [109964] = { index=1, show=11, red=11 }, -- Spirit Shell
        [137323] = { index=3, show=4, red=4 }, -- Lucidity (LMG Proc)
        -- Test
        --[139] = { index=4, show=15, red=4 }, -- Renew
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
    },
    DEATHKNIGHT = {
        -- Frost
        [51124] = { index=0, show=11, red=6 }, -- Killing Machine
        [59052] = { index=1, show=16, red=6 }, -- Freezing Fog (Rime Proc)
        [101568] = { index=2, show=16, red=6 }, -- Dark Succor
    },
}