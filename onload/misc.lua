local n_name, NeP = ...

NeP.Listener:Add(n_name..'_misc', 'LFG_PROPOSAL_SHOW', function()
  if NeP.Interface:Fetch(n_name..'_Settings', 'LFG_acp', false) then
    _G.C_Timer.After(math.random(3, 8), _G.AcceptProposal)
  end
end)

local function ScanNewTalent(row)
  local active_talent, new_talent;
  -- scans
  for col=1, 3 do
    local talent_id, _,_, active = _G.GetTalentInfo(row, col, 1)
    if active then
      active_talent = talent_id
    end
    if _G.IsMouseButtonDown(1)
    and _G.MouseIsOver(_G["PlayerTalentFrameTalentsTalentRow"..row.."Talent"..col]) then
      new_talent = talent_id
    end
  end
  -- if we found a new talent, force learn
  if new_talent
  and active_talent
  and active_talent ~= new_talent then
    _G.RemoveTalent(active_talent)
    _G.RemoveTalent(active_talent)
    _G.C_Timer.After(0.5, function()
      _G.LearnTalent(new_talent)
    end)
  end
end

_G.C_Timer.NewTicker(0.1, function()
  if _G.PlayerTalentFrame
  and _G.PlayerTalentFrame:IsVisible()
  and not _G.IsResting()
  and NeP.Interface:Fetch(n_name..'_Settings', 'talents_exp', false) then
    for row=1, 7 do
      ScanNewTalent(row)
    end
  end
end)
