HyperAlerts = HyperAlerts or {}
local LAM = LibAddonMenu2
local HA = HyperAlerts
local LH = LibHyper

local function updateFont()
    for i = 1, 30 do
        local effectBackground = EffectsContainer:GetNamedChild('effectBackground' .. i)
        local effectIcon = effectBackground:GetNamedChild('effectIcon' .. i)
        local effectLabel = effectIcon:GetNamedChild('effectLabel' .. i)
        local effectStackLabel = effectIcon:GetNamedChild('effectStackLabel' .. i)

        effectLabel:SetFont(HA.savedVariables.effect.fontStyle .. "|" .. HA.savedVariables.effect.fontSize .. "|" .. HA.savedVariables.effect.fontWeight)
        effectStackLabel:SetFont(HA.savedVariables.effect.fontStyle .. "|" .. HA.savedVariables.effect.fontSize .. "|" .. HA.savedVariables.effect.fontWeight)
    end
end

function HA.InitializeEffectSettings()
    local panelData = {
        type = "panel",
        name = "HyperAlerts - Effects",
        displayName = "HyperAlerts - Effects",
        author = "Hyperioxes",
        version = "0.1",
        registerForRefresh = true,
        registerForDefaults = false,
    }

    LAM:RegisterAddonPanel("HyperAlertsSettingsEffects", panelData)

    local optionsTable = {}

    table.insert(optionsTable, {
        type = "header",
        name = "Position",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "button",
        name = "Unlock and Preview UI",
        func = function()
            HA.effectPreview = not HA.effectPreview
            EffectsContainer:SetHidden(not HA.effectPreview)
            HA.pseudoEffects = {}
        end,
        width = "half",
    })

    table.insert(optionsTable, {
        type = "header",
        name = "Font",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Style:",
        choices = LH.getTableKeys(LH.fonts),
        choicesValues = LH.getTableValues(LH.fonts),
        getFunc = function()
            return HA.savedVariables.effect.fontStyle
        end,
        setFunc = function(var)
            HA.savedVariables.effect.fontStyle = var
            updateFont()
        end,
        --reference = "fontStyleDropdown",
    })
    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Weight:",
        choices = LH.fontWeights,
        getFunc = function()
            return HA.savedVariables.effect.fontWeight
        end,
        setFunc = function(var)
            HA.savedVariables.effect.fontWeight = var
            updateFont()
        end,
    })
    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Size:",
        choices = LH.fontSizes,
        getFunc = function()
            return HA.savedVariables.effect.fontSize
        end,
        setFunc = function(var)
            HA.savedVariables.effect.fontSize = var
            updateFont()
        end,
    })


    LAM:RegisterOptionControls("HyperAlertsSettingsEffects", optionsTable)

end