HyperAlerts = HyperAlerts or {}
local HA = HyperAlerts
local LH = LibHyper

function HA.EffectsUpdate()

    local now = GetGameTimeSeconds()
    local effectTable = {}
    local amountOfeffectsFilteredOut = 0

    for x = 1, 3 do
        for i = 1, 10 do
            local effectBackground = EffectsContainer:GetNamedChild('effectBackground' .. i + ((x - 1) * 10))
            effectBackground:SetHidden(true)
        end
    end

    for i = 1, GetNumBuffs('player') do
        local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo('player', i)
        effectTable[i] = {
            effectName = buffName,
            timeStarted = timeStarted,
            timeEnding = timeEnding,
            iconFilename = iconFilename,
            stackCount = stackCount,
            castByPlayer = castByPlayer,
            timer = timeEnding - now,
            abilityId = abilityId,
        }
    end

    local filteredeffectTable = {}
	
	for _, effect in pairs(effectTable) do
        if LH.inArray(HA.effectsData ,effect.abilityId) then
            table.insert(filteredeffectTable, effect)
            amountOfeffectsFilteredOut = amountOfeffectsFilteredOut + 1
        end
    end
	
    for _, pseudoEffect in pairs(HA.pseudoEffects) do
        if pseudoEffect.timeEnding > now then
            table.insert(filteredeffectTable, pseudoEffect)
            amountOfeffectsFilteredOut = amountOfeffectsFilteredOut + 1
        end
    end


    table.sort(filteredeffectTable, function(x, y)
        return (x and x.timer < y.timer)
    end)
    for i = 1, math.min(amountOfeffectsFilteredOut, 30) do
        local effectBackground = EffectsContainer:GetNamedChild('effectBackground' .. i)
        local effectIcon = effectBackground:GetNamedChild('effectIcon' .. i)
        local effectLabel = effectIcon:GetNamedChild('effectLabel' .. i)
        local effectStackLabel = effectIcon:GetNamedChild('effectStackLabel' .. i)

        effectIcon:SetTexture(filteredeffectTable[i].iconFilename)

        local remainingTime = filteredeffectTable[i].timeEnding - now
        local timerText = math.floor(remainingTime)
        if remainingTime <= 0 then
            timerText = '0.0'
        elseif remainingTime <= 3 then
            timerText = LH.processTimer(remainingTime)
        end

        effectLabel:SetText(timerText)
        if filteredeffectTable[i].stackCount > 0 then
            effectStackLabel:SetText(filteredeffectTable[i].stackCount)
        else
            effectStackLabel:SetText('')
        end
        effectBackground:SetHidden(false)

    end

    if HA.effectPreview and amountOfeffectsFilteredOut == 0 then
        local previewEffects = {
            [1] = 150078, --Deaths Touch
            [2] = 153179, --Abomination Bleed
            [3] = 153177, --Behemoth Burn
        }
        for k,abilityId in pairs(previewEffects) do
            HA.pseudoEffects[k] = {
                effectName = GetAbilityName(abilityId),
                timeStarted = GetGameTimeSeconds(),
                timeEnding = GetGameTimeSeconds()+(k*4),
                iconFilename = GetAbilityIcon(abilityId),
                stackCount = k,
                castByPlayer = true,
                timer = (k*4),
                abilityId = abilityId,
            }
        end
    end
end