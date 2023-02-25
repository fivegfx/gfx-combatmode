
local CombatMode = {}
RegisterServerEvent("gfx-combatmode:CombatMode", function()
    local identifier = GetIdent(source)
    if CombatMode[identifier] == nil then
        CombatMode[identifier] = os.time()
    end
end)

AddEventHandler("playerDropped", function()
    local identifier = GetIdent(source)
    if CombatMode[identifier] ~= nil and (os.time() - CombatMode[identifier] <= Config.CombatModeTimer) then
        CombatMode[identifier] = nil
        Config.ClearInventory(source)
    end
end)

RegisterCommand("dropped", function(source, args)
    local identifier = GetIdent(source)
    if CombatMode[identifier] ~= nil and (os.time() - CombatMode[identifier] <= Config.CombatModeTimer) then
        CombatMode[identifier] = nil
        Config.ClearInventory(source)
    end
end)

function GetIdent(source, idType)
    if source ~= 0 then
        idType = idType ~= nil and idType or "steam"
        local identifiers = GetPlayerIdentifiers(source)
        for i = 1, #identifiers do
            if identifiers[i]:match(idType) then
                return identifiers[i]
            end
        end
    else
        return 0
    end
end