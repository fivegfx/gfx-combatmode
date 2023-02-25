Config = {
    combatModeTriggerWeapons = {
        [`weapon_rpg`] = true,
        [`weapon_grenadelauncher`] = true,
        [`weapon_hominglauncher`] = true,
    },
    CombatModeTimer = 3, --seconds
    ClearInventory = function(source)
        exports["gfx-inventory"]:ClearInventory(source, "inventory")
    end
}