HyperAlerts = HyperAlerts or {}
local function registerPseudoEffectEvent(abilityID, data)
    EVENT_MANAGER:RegisterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, function(_, result, _, abilityName, abilityGraphic,
                                                                                   _, sourceName, _, targetName, targetType, hitValue, _, _, _, _, _, _)

        local previousStacks = 0
        if HyperAlerts.pseudoEffects[abilityID] then
            previousStacks = HyperAlerts.pseudoEffects[abilityID].stackCount or 0
            if HyperAlerts.pseudoEffects[abilityID].timeEnding < GetGameTimeSeconds() then
                previousStacks = 0
            end
        end

        HyperAlerts.pseudoEffects[abilityID] = {
            effectName = abilityName,
            timeStarted = GetGameTimeSeconds(),
            timeEnding = GetGameTimeSeconds()+data.duration,
            iconFilename = GetAbilityIcon(abilityID),
            stackCount = previousStacks + 1,
            castByPlayer = true,
            timer = 5,
            abilityId = abilityID,
        }


    end)
    EVENT_MANAGER:AddFilterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
    EVENT_MANAGER:AddFilterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DAMAGE)
    EVENT_MANAGER:AddFilterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
end

HyperAlerts.pseudoEffectData = {
    [150002] = {duration = 5}, --Abo Slam AoE
	[152515] = {duration = 5}, --Melee Trash Poison AoE
}

HyperAlerts.effectsData = {
    --Rockgrove
    150078, --Deaths Touch
    153179, --Abomination Bleed
    153177, --Behemoth Burn

    --Sanity's Edge
    185316, --Yaseyla Bleed
    162365, --Rattled
    186561, --Armor Shred
    165972, --Hindered


    199235, --Circuit Charge
    184280, --Arctic Shred

    199234, --Gaping Wound
    140661, --Infected Wound

    --Halls of Fabrication
    90854, -- Gaping Wound
    93669, -- Greater Defile
}

function HyperAlerts.RegisterPseudoEffectEvents()
    for k,v in pairs(HyperAlerts.pseudoEffectData) do
        registerPseudoEffectEvent(k,v)
    end
end