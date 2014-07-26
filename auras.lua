local ADDON_NAME, ns = ...

ns.auras = {
	RAID = {
		[147207] = { index=0, show=60, red=10, filter="HARMFUL" }, -- Weakened Resolve (Sha of Pride)
		[144359] = { index=1, show=20, red=20, filter="HARMFUL" }, -- Gift of Titans Healer (Sha of Pride) 
		[146594] = { index=1, show=20, red=20, filter="HARMFUL" }, -- Gift of Titans DPS (Sha of Pride)
		[147029] = { index=0, show=7, red=7, filter="HARMFUL" },   -- Flames of Galakrond (Galakras)
		[144089] = { index=0, show=30, red=10, filter="HARMFUL" }, -- Toxic Mist (Dark Shamans)
		[144330] = { index=1, show=60, red=10, filter="HARMFUL" }, -- Iron Prison (Dark Shamans)
		[145987] = { index=0, show=15, red=5, filter="HARMFUL" },  -- Set to Blow (Spoils of Pandaria)
		[139] = { index=4, show=10, red=4, filter="HELPFUL" }, -- Renew
	},
    PRIEST = {
        -- Shadow
		[137590] = { index=3, show=11, red=11, filter="HELPFUL" }, -- Tempus Repit
        -- Holy
        -- Discipline
        [81700] = { index=0, show=19, red=6, filter="HELPFUL" },  -- Archangel
        [109964] = { index=1, show=11, red=11, filter="HELPFUL" }, -- Spirit Shell
        [137323] = { index=3, show=4, red=4, filter="HELPFUL" }, -- Lucidity (LMG Proc)
        -- Test
        --[139] = { index=4, show=15, red=4, filter="HELPFUL" }, -- Renew
        --[77613] = { index=4, show=16, red=6, filter="HELPFUL" }, -- Grace
    },
    PALADIN = {
        [90174] = { index=0, show=9, red=9, filter="HELPFUL" }, -- Divine Purpose
        -- Holy
        [54149] = { index=1, show=16, red=6, filter="HELPFUL" }, -- Infusion of Light
        -- Protection
        [20925] = { index=1, show=31, red=7, filter="HELPFUL" }, -- Sacred Shield
        [114637] = { index=2, show=21, red=5, filter="HELPFUL" }, -- Bastion of Glory
        [94686] = { index=3, show=9, red=9, filter="HELPFUL" }, -- Supplication
    },
    DEATHKNIGHT = {
        -- Frost
        [51124] = { index=0, show=11, red=6, filter="HELPFUL" }, -- Killing Machine
        [59052] = { index=1, show=16, red=6, filter="HELPFUL" }, -- Freezing Fog (Rime Proc)
        [101568] = { index=2, show=16, red=6, filter="HELPFUL" }, -- Dark Succor
    },
}