-- OPTIONAL!
-- List of all elements can be found at:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-Interface
local GUI = {
     {type = 'text', text = 'nothing here yet...'},
}

-- OPTIONAL!
local GUI_ST = {
    title='[NeP] Humter - Marksmanship',
    --width='256',
    --height='300',
    --color='A330C9'
}

-- This is executed on load
-- OPTIONAL!
local ExeOnLoad = function()
     -- This will print a message everytime the user selects your CR.
     NeP.Core:Print('Hello User!\nThanks for using [NeP] Humter - Marksmanship\nRemember this is just a basic routine.')
end

-- this is executed on unload
-- OPTIONAL!
local ExeOnUnload = function()
     -- This will print a message everytime the user selects your CR.
     NeP.Core:Print('Goodbye :(')
end

--CR for in-combat
--[[
Hunter's Mark maintain at all times (if selected).
Explosive Shot when available (if selected).
Arcane Shot to consume Precise Shots procs.
Aimed Shot with 2 charges.
Rapid Fire when available and <= 70 Focus.
Barrage on cooldown (if selected).
Steady Focus maintain at all times (if selected).
Piercing Shot when available (if selected).
Aimed Shot when available.
Arcane Shot to dump Focus.
Steady Shot to build Focus.
]]
local InCombat = {
     {'Hunter\'s Mark', '!debuff', 'target'},
     {'Explosive Shot', nil, 'target'},
     {'Arcane Shot', 'player.buff(Precise Shots)', 'target'},
     {'Aimed Shot', 'spell.charges>=2', 'target'},
     {'Rapid Fire', 'player.focus<=70', 'target'},
     {'Barrage', nil, 'target'},
     {'Aimed Shot', nil, 'target'},
     {'Piercing Shot', nil, 'target'},
     {'Arcane Shot', 'player.focus>40', 'target'},
     {'Steady Shot', nil, 'target'},
}

--CR for out of combat
-- OPTIONAL!
local OutCombat = {
     -- OCC CR.
}

-- Enter name and ID
-- this allows your cr to work on any language and at the same time remain readable
-- OPTIONAL!
local spell_ids = {}

local buffsBlacklist = {}
local debuffsBlacklist = {}

-- These are blacklisting exemples
-- (### means number)
-- OPTIONAL!
local blacklist = {
     units = {},
     buffs = buffsBlacklist,
     debuff = debuffsBlacklist,
}

-- SPEC_ID can be found on:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-&-Spec-IDs
NeP.CR:Add(254, {
     wow_ver = "8.0", -- Optional!
     nep_ver = "1.11", -- Optional!
     name = '[NeP] Humter - Marksmanship',
     ic = InCombat, -- Optional!
     ooc= OutCombat, -- Optional!
     load = ExeOnLoad, -- Optional!
     unload = ExeOnUnload, -- Optional!
     gui= GUI, -- Optional!
     gui_st = GUI_ST, -- Optional!
     ids = spell_ids, -- Optional!
     blacklist = blacklist, -- Optional!
     pooling = true, -- Optional! [[This makes nep wait for a spell if the conditions are true but the spell is on cooldown.]]
})
