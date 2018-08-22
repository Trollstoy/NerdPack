local _, gbl = ...

gbl.PE = {}

-- STOP if PE is actualy loaded
if ProbablyEngine then
  gbl.core:Print('Found ProbablyEngine, not attaching our wrapper.\nNeP can read ProbablyEngine\'s combat routines if you disable it.')
  return;
end

ProbablyEngine = gbl.PE
