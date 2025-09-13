HyperAlerts = HyperAlerts or {}
local HA = HyperAlerts
function OnAddOnLoaded(_, addonName)
    if addonName ~= HA.name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(HA.name, EVENT_ADD_ON_LOADED)
    HA.savedVariables = {}
    HA.defaultSavedVariables = {
        effect = {
            fontStyle = 'LibHyper/fonts/BarlowSemiCondensed-SemiBold.otf',
            fontWeight = 'outline',
            fontSize = 18,
        },
    }
    --Initialize saved variables
    HA.savedVariables = ZO_SavedVars:NewAccountWide("HyperAlertsSV", 1, nil, HA.defaultSavedVariables)
    --Initialize UIs
    HA.InitializeEffectsContainer()
    --Initialize settings
    HA.InitializeEffectSettings()
    --Register events that will update UI
    EVENT_MANAGER:RegisterForUpdate("HA.EffectsUpdate", 50, HA.EffectsUpdate)

    --register events
    HA.RegisterPseudoEffectEvents()
end

EVENT_MANAGER:RegisterForEvent(HA.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)