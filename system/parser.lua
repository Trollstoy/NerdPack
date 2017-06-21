local _, NeP = ...
NeP.Parser   = {}

-- Local stuff for speed
local GetTime              = GetTime
local UnitBuff             = UnitBuff
--local IsMounted            = IsMounted
local UnitCastingInfo      = UnitCastingInfo
local UnitChannelInfo      = UnitChannelInfo
local UnitExists           = ObjectExists or UnitExists
local UnitIsVisible        = UnitIsVisible
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetSpellCooldown     = GetSpellCooldown
local IsUsableSpell        = IsUsableSpell
local SpellStopCasting     = SpellStopCasting
local UnitIsDeadOrGhost    = UnitIsDeadOrGhost
local SecureCmdOptionParse = SecureCmdOptionParse
local InCombatLockdown     = InCombatLockdown
local C_Timer              = C_Timer

--Fake CR so the parser dosent error of no CR is selected
local noop_t = {{(function() NeP.Core:Print("No CR Selected...") end)}}
NeP.Compiler:Iterate(noop_t, "FakeCR")

--This is used by the ticker
--Its used to determin if we should iterate or not
--Returns true if we're not mounted or in a castable mount
local function IsMountedCheck()
	--Figure out if we're mounted on a castable mount
	for i = 1, 40 do
		local mountID = select(11, UnitBuff('player', i))
		if mountID and NeP.ByPassMounts(mountID) then
			return true
		end
	end
	--return boolean (true if mounted)
	return (SecureCmdOptionParse("[overridebar][vehicleui][possessbar,@vehicle,exists][mounted]true")) ~= "true"
end

--This is used by the parser.spell
--Returns if we're casting/channeling anything, its remaning time and name
--Also used by the parser for (!spell) if order to figure out if we should clip
local function castingTime()
	local time = GetTime()
	local name, _,_,_,_, endTime = UnitCastingInfo("player")
	if not name then name, _,_,_,_, endTime = UnitChannelInfo("player") end
	return (name and (endTime/1000)-time) or 0, name
end

local function _exe(eval, endtime, cname)
	local spell, cond = eval[1], eval[2]
	-- Evaluate conditions
	eval.spell = eval.spell or spell.spell
	if NeP.DSL.Parse(cond, eval.spell, eval.target)
	and NeP.Helpers:Check(eval.spell, eval.target) then
		-- (!spell) this clips the spell
		if spell.interrupts then
			if cname == eval.spell then
				return true
			elseif endtime > 0 then
				SpellStopCasting()
			end
		end
		--Set vars
		NeP.Parser.LastCast = eval.spell
		NeP.Parser.LastGCD = (not eval.nogcd and eval.spell) or NeP.Parser.LastGCD
		NeP.Parser.LastTarget = eval.target
		--Update the actionlog and master toggle icon
		NeP.ActionLog:Add(spell.token, eval.spell, spell.icon, eval.target)
		NeP.Interface:UpdateIcon('mastertoggle', spell.icon)
		--Execute
		return eval.exe(eval)
	end
end

--This works on the current parser target.
--This function takes care of psudo units (fakeunits).
--Returns boolean (true if the target is valid).
function NeP.Parser.Target(eval)
	-- This is to alow casting at the cursor location where no unit exists
	if eval[3].cursor then
		return true
	-- Target is returned from a function
	elseif eval[3].func then
		eval[3].target = eval[3].func()
	end
	-- Eval if the unit is valid
	return UnitExists(eval.target) and UnitIsVisible(eval.target)
	and NeP.Protected.LineOfSight('player', eval.target)
end

--This is the actual Parser...
--Reads and figures out what it should execute from the CR
--The Cr when it reaches this point must be already compiled and be ready to run.
function NeP.Parser.Parse(eval)
	local spell, cond, target = eval[1], eval[2], eval[3]
	local endtime, cname = castingTime()
	-- Its a table
	if spell.is_table then
		if NeP.DSL.Parse(cond) then
			for i=1, #spell do
				local res = NeP.Parser.Parse(spell[i])
				if res then return res end
			end
		end
	-- Normal
	elseif (spell.bypass or endtime == 0)
	and NeP.Actions:Eval(spell.token)(eval) then
		--Target is an array
		local _target = NeP.FakeUnits:Filter(target.target)
		if type(_target) == 'table' then
			for i=1, #_target do
				eval.target = _target[i]
				if _exe(eval, endtime, cname) then return true end
			end
		else
			eval.target = _target
			return _exe(eval, endtime, cname)
		end
	end
end

-- Delay until everything is ready
NeP.Core:WhenInGame(function()

C_Timer.NewTicker(0.1, (function()
	--Hide Faceroll frame
	NeP.Faceroll:Hide()
	--Only run if mastertoggle is enabled, not dead and valid mount situation
	if NeP.DSL:Get('toggle')(nil, 'mastertoggle')
	and not UnitIsDeadOrGhost('player') and IsMountedCheck() then
		--Run the Queue (If it returns true, end)
		if NeP.Queuer:Execute() then return end
		--Iterate the CR (If it returns true, end)
		local table = NeP.CR.CR[InCombatLockdown()] or noop_t
		for i=1, #table do
			local res = NeP.Parser.Parse(table[i])
			if res then return res end
		end
	end
end), nil)

end, 99)
