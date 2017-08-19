local _, NeP = ...

NeP.Debug = {}
NeP.Debug.Profiles = {}

SetCVar("scriptProfile", "1")

local GetFunctionCPUUsage = GetFunctionCPUUsage
local ResetCPUUsage = ResetCPUUsage
local C_Timer = C_Timer

function NeP.Debug:Add(name, func, subroutines)
	table.insert(self.Profiles, {
		name = name,
		func = func,
		subroutines = subroutines,
    max = 0,
    min = 0
	})
end

local tbl = NeP.Debug.Profiles
C_Timer.NewTicker(1, function()
  tbl.Total_Usage = 0
	for i=1, #tbl do
		local usage, calls = GetFunctionCPUUsage(tbl[i].func, tbl[i].subroutines)
		tbl[i].cpu_time = usage
		tbl[i].calls = calls
    tbl[i].max = tbl[i].max > usage and tbl[i].max or usage
    tbl[i].min = tbl[i].min < usage and tbl[i].min or usage
    tbl.Total_Usage = tbl.Total_Usage + usage
	end
	ResetCPUUsage()
end, nil)

NeP.Globals.Debug = NeP.Debug