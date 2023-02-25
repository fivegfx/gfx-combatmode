local combatMode = false
AddEventHandler('gameEventTriggered', function(name, eventData)
    if name == "CEventNetworkEntityDamage" then
        local ped, victim, killer, isFatal, weaponHash = PlayerPedId(), eventData[1], eventData[2], eventData[6] == 1, tonumber(eventData[7])
        local killerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer))
        local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim)) or tostring(victim==-1 and " " or victim)
        if ped == victim and isFatal then
            if isPlayerInZone and zoneIndex then
                TriggerServerEvent("gfx-combatmode:playerKilled", zoneIndex, killerId, victimId)
            end
        end
        if ped == killer and weaponHash ~= -544306709 then
            if (IsEntityAPed(victim) and IsPedAPlayer(victim)) or (IsEntityAVehicle(victim) --[[and IsAnyPlayerInVehicle(victim)]]) then
                if not combatMode then
                    TriggerEvent("chat:addMessage", { args = { "^1KORZ PVP", "^1You are in combatmode!"}})
                end
                combatMode = GetGameTimer()
                thread = CombatModeThread()
                TriggerServerEvent("gfx-combatmode:CombatMode")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
        if Config.combatModeTriggerWeapons[weapon] then
            if IsPedShooting(ped) then
                if not combatMode then
                    TriggerEvent("chat:addMessage", { args = { "^1KORZ PVP", "^1You are in combatmode!"}})
                end
                combatMode = GetGameTimer()
                thread = CombatModeThread()
                TriggerServerEvent("gfx-combatmode:CombatMode")
            end
        end
    end
end)

function CombatModeThread()
    if thread then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if (GetGameTimer() - combatMode) > Config.CombatModeTimer * 1000 then
                combatMode = false
                thread = nil
                TriggerEvent("chat:addMessage", { args = { "^1KORZ PVP", "^1You are not in combatmode anymore!"}})
                break
            end
        end
    end)
end
