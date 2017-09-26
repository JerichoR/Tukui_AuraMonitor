local ADDON_NAME, ns = ...

ns.auras = {
	RAID = {
		--[139] = { index=4, show=10, red=4, filter="HELPFUL" },     -- Renew
	},
    PRIEST = {
        -- Shadow
        -- Holy
        -- Discipline
        [109964] = { index=1, show=11, red=11, filter="HELPFUL" }, -- Spirit Shell
        [137323] = { index=3, show=4, red=4, filter="HELPFUL" },   -- Lucidity (LMG Proc)
        -- Test
        -- [139] = { index=4, show=15, red=4, filter="HELPFUL" }, -- Renew
        -- [17] = { index=0, show=10, red=3, filter="HELPFUL" }, -- pw shield
    },
    PALADIN = {
        -- Holy
        [54149] = { index=0, show=16, red=6, filter="HELPFUL" },  -- Infusion of Light
        [216411] = { index=1, show=10, red=10, filter="HELPFUL" }, -- Divine Purpose
        [214202] = { index=2, show=10, red=10, filter="HELPFUL" }, -- Rule of Law
        -- Protection
        [132403] = { index=0, show=5, red=4, filter="HELPFUL" }, -- Shield of the Righteous
        -- Retribution
        [223819] = { index=0, show=12, red=4, filter="HELPFUL" }, -- Divine Purpose
    },
    DEATHKNIGHT = {
        -- Frost
        [51124] = { index=0, show=11, red=6, filter="HELPFUL" },  -- Killing Machine
        [59052] = { index=1, show=16, red=6, filter="HELPFUL" },  -- Freezing Fog (Rime Proc)
        [101568] = { index=2, show=16, red=6, filter="HELPFUL" }, -- Dark Succor
    },
}