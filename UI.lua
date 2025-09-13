HyperAlerts = {
    name = 'HyperAlerts',
    pseudoEffects = {},
    effectPreview = false,
}
local HA = HyperAlerts
local LH = LibHyper
local SM = SCENE_MANAGER

local function onSceneChange(_, scene)
    if scene == SCENE_SHOWN or HA.effectPreview then
        EffectsContainer:SetHidden(false)
    else
        EffectsContainer:SetHidden(true)
    end
end

function HA.InitializeEffectsContainer()
    local WM = GetWindowManager()
    local EffectsContainer = WM:CreateTopLevelWindow("EffectsContainer")

    EffectsContainer:SetResizeToFitDescendents(true)
    EffectsContainer:SetMovable(true)
    EffectsContainer:SetMouseEnabled(true)
    EffectsContainer:SetClampedToScreen(true)
    EffectsContainer:SetHandler("OnMoveStop", function()
        HA.savedVariables.xOffset = math.floor(EffectsContainer:GetLeft())
        HA.savedVariables.yOffset = math.floor(EffectsContainer:GetTop())
    end)
    EffectsContainer:SetHidden(false)
    EffectsContainer:SetDrawTier(DT_HIGH)

    for x = 1, 3 do
        for i = 1, 10 do
            local effectBackground = WM:CreateControl("$(parent)effectBackground" .. i + ((x - 1) * 10), EffectsContainer, CT_BACKDROP, 4)
            effectBackground:SetDimensions(100, 100)
            effectBackground:SetAnchor(TOPLEFT, EffectsContainer, TOPLEFT, 102 * (i - 1), 2 + (102 * (x - 1)))
            effectBackground:SetCenterColor(unpack(LH.colors.transparentBlack))
            effectBackground:SetEdgeColor(unpack(LH.colors.black))
            effectBackground:SetHidden(true)
            effectBackground:SetDrawLayer(0)
            effectBackground:SetEdgeTexture("", 4, 4)

            local effectIcon = WM:CreateControl("$(parent)effectIcon" .. i + ((x - 1) * 10), effectBackground, CT_TEXTURE, 4)
            effectIcon:SetDimensions(96, 96)
            effectIcon:SetAnchor(CENTER, effectBackground, CENTER, 0, 0)
            effectIcon:SetHidden(false)
            effectIcon:SetDrawLayer(1)

            local effectLabel = WM:CreateControl("$(parent)effectLabel" .. i + ((x - 1) * 10), effectIcon, CT_LABEL)
            effectLabel:SetFont(HA.savedVariables.effect.fontStyle .. "|" .. HA.savedVariables.effect.fontSize .. "|" .. HA.savedVariables.effect.fontWeight)
            effectLabel:SetDrawLayer(2)
            effectLabel:SetAnchor(CENTER, effectIcon, CENTER, 0, 0)
            effectLabel:SetDimensions(96, 96)
            effectLabel:SetHidden(false)
            effectLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
            effectLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)

            local effectStackLabel = WM:CreateControl("$(parent)effectStackLabel" .. i + ((x - 1) * 10), effectIcon, CT_LABEL)
            effectStackLabel:SetFont(HA.savedVariables.effect.fontStyle .. "|" .. HA.savedVariables.effect.fontSize .. "|" .. HA.savedVariables.effect.fontWeight)
            effectStackLabel:SetDrawLayer(2)
            effectStackLabel:SetAnchor(CENTER, effectIcon, TOPRIGHT, -2, 2)
            effectStackLabel:SetDimensions(48, 48)
            effectStackLabel:SetHidden(false)
            effectStackLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
            effectStackLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
        end
    end

    EffectsContainer:ClearAnchors()
    EffectsContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, HA.savedVariables.xOffset, HA.savedVariables.yOffset)
    SM:GetScene("hud"):RegisterCallback("StateChange", onSceneChange)
    SM:GetScene("hudui"):RegisterCallback("StateChange", onSceneChange)
end