local _, gbl = ...

gbl.PE.toggle = {}
gbl.PE.rotation = {}

--wrapper for toggles
gbl.PE.toggle.create = function(key, icon, name, tooltip)
	gbl.Interface:AddToggle({
		key = key,
		name = name,
		text = tooltip,
		icon = icon,
	})
end

--wrapper for CR Add
gbl.PE.rotation.register_custom = function(id, name, incombat, outcombat, callback)
	gbl.CR:Add(id, {
		name = name,
		ic = incombat,
		ooc = outcombat,
		load = callback
	})
end
