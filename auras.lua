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
        [54149] = { index=1, show=16, red=6, filter="HELPFUL" },  -- Infusion of Light
        [203538] = { index=2, show=16, red=6, filter="HELPFUL" },
        -- Protection
    },
    DEATHKNIGHT = {
        -- Frost
        [51124] = { index=0, show=11, red=6, filter="HELPFUL" },  -- Killing Machine
        [59052] = { index=1, show=16, red=6, filter="HELPFUL" },  -- Freezing Fog (Rime Proc)
        [101568] = { index=2, show=16, red=6, filter="HELPFUL" }, -- Dark Succor
    },
}