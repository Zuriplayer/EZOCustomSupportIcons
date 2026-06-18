EZOCustomSupportIcons = EZOCustomSupportIcons or {}
local ADDON = EZOCustomSupportIcons

local ADDON_NAME = "EZOCustomSupportIcons"
local UPDATE_MS = 10
local DEFAULTS = {
    headIconsEnabled = true,
    headIconSize = 96,
}
local ICON_OFFSET_M = 2.8
local FADE_DISTANCE_M = 7.5
local ICONS = {
    ["@zuriplayer"] = "EZOCustomSupportIcons/icons/zuriplayer.dds",
}

local wm = WINDOW_MANAGER
local renderControl
local iconWindow
local iconPool = {}

local function GetSettings()
    ADDON.sv = ADDON.sv or DEFAULTS
    return ADDON.sv
end

local function AreHeadIconsEnabled()
    return GetSettings().headIconsEnabled ~= false
end

local function GetHeadIconSize()
    return tonumber(GetSettings().headIconSize) or DEFAULTS.headIconSize
end

local function GetIconForDisplayName(displayName)
    if type(displayName) ~= "string" or displayName == "" then
        return nil
    end

    return ICONS[string.lower(displayName)]
end

local function GetOrCreateIcon(unitTag)
    local icon = iconPool[unitTag]
    if icon then
        return icon
    end

    icon = wm:CreateControl("EZOCustomSupportIconsIcon" .. unitTag, iconWindow, CT_TEXTURE)
    icon:ClearAnchors()
    icon:SetAnchor(BOTTOM, iconWindow, CENTER, 0, 0)
    icon:SetDimensions(GetHeadIconSize(), GetHeadIconSize())
    icon:SetPixelRoundingEnabled(false)
    icon:SetHidden(true)

    iconPool[unitTag] = icon
    return icon
end

local function HideAllIcons()
    for _, icon in pairs(iconPool) do
        icon:SetHidden(true)
    end
end

local function CanShowUnit(unitTag)
    return DoesUnitExist(unitTag)
        and IsUnitPlayer(unitTag)
        and IsUnitOnline(unitTag)
        and IsGroupMemberInSameWorldAsPlayer(unitTag)
        and not IsGroupMemberInRemoteRegion(unitTag)
        and (IsGroupMemberInSameInstanceAsPlayer(unitTag) or IsActiveWorldBattleground())
end

local function CanShowPlayer()
    return DoesUnitExist("player") and IsUnitPlayer("player")
end

local function GetConfiguredTexture(unitTag)
    return GetIconForDisplayName(GetUnitDisplayName(unitTag))
end

local function ProjectUnit(unitTag, texture, camera)
    local _, worldX, worldY, worldZ = GetUnitRawWorldPosition(unitTag)
    worldY = worldY + ICON_OFFSET_M * 100

    local screenX = worldX * camera.i11 + worldY * camera.i21 + worldZ * camera.i31 + camera.i41
    local screenY = worldX * camera.i12 + worldY * camera.i22 + worldZ * camera.i32 + camera.i42
    local screenZ = worldX * camera.i13 + worldY * camera.i23 + worldZ * camera.i33 + camera.i43

    if screenZ <= 0 then
        return
    end

    local viewW, viewH = GetWorldDimensionsOfViewFrustumAtDepth(screenZ)
    local uiX = screenX * camera.uiW / viewW
    local uiY = -screenY * camera.uiH / viewH

    local icon = GetOrCreateIcon(unitTag)
    icon:ClearAnchors()
    icon:SetAnchor(BOTTOM, iconWindow, CENTER, uiX, uiY)
    icon:SetTexture(texture)
    local iconSize = GetHeadIconSize()
    icon:SetDimensions(iconSize, iconSize)

    local dx = worldX - camera.x
    local dy = worldY - camera.y
    local dz = worldZ - camera.z
    local distance = 1 + zo_sqrt(dx * dx + dy * dy + dz * dz)
    icon:SetScale(1000 / distance)
    icon:SetAlpha(zo_clampedPercentBetween(1, FADE_DISTANCE_M * 100, distance))
    icon:SetHidden(false)
end

local function GetCamera()
    Set3DRenderSpaceToCurrentCamera(renderControl:GetName())

    local cameraX, cameraY, cameraZ = GuiRender3DPositionToWorldPosition(renderControl:Get3DRenderSpaceOrigin())
    local forwardX, forwardY, forwardZ = renderControl:Get3DRenderSpaceForward()
    local rightX, rightY, rightZ = renderControl:Get3DRenderSpaceRight()
    local upX, upY, upZ = renderControl:Get3DRenderSpaceUp()
    local uiW, uiH = GuiRoot:GetDimensions()

    return {
        x = cameraX,
        y = cameraY,
        z = cameraZ,
        uiW = uiW,
        uiH = uiH,
        i11 = -(upY * forwardZ - upZ * forwardY),
        i12 = -(rightZ * forwardY - rightY * forwardZ),
        i13 = -(rightY * upZ - rightZ * upY),
        i21 = -(upZ * forwardX - upX * forwardZ),
        i22 = -(rightX * forwardZ - rightZ * forwardX),
        i23 = -(rightZ * upX - rightX * upZ),
        i31 = -(upX * forwardY - upY * forwardX),
        i32 = -(rightY * forwardX - rightX * forwardY),
        i33 = -(rightX * upY - rightY * upX),
        i41 = -(upZ * forwardY * cameraX + upY * forwardX * cameraZ + upX * forwardZ * cameraY - upX * forwardY * cameraZ - upY * forwardZ * cameraX - upZ * forwardX * cameraY),
        i42 = -(rightX * forwardY * cameraZ + rightY * forwardZ * cameraX + rightZ * forwardX * cameraY - rightZ * forwardY * cameraX - rightY * forwardX * cameraZ - rightX * forwardZ * cameraY),
        i43 = -(rightZ * upY * cameraX + rightY * upX * cameraZ + rightX * upZ * cameraY - rightX * upY * cameraZ - rightY * upZ * cameraX - rightZ * upX * cameraY),
    }
end

function ADDON.OnUpdate()
    HideAllIcons()

    if not AreHeadIconsEnabled() then
        return
    end

    local playerTexture = GetConfiguredTexture("player")
    local camera = GetCamera()

    if playerTexture and CanShowPlayer() then
        ProjectUnit("player", playerTexture, camera)
    end

    if not IsUnitGrouped("player") then
        return
    end

    for i = 1, GROUP_SIZE_MAX do
        local unitTag = "group" .. i
        if not AreUnitsEqual("player", unitTag) and CanShowUnit(unitTag) then
            local texture = GetConfiguredTexture(unitTag)
            if texture then
                ProjectUnit(unitTag, texture, camera)
            end
        end
    end
end

function ADDON.RegisterSettingsPanel()
    local LAM = LibAddonMenu2
    if not LAM then
        return
    end

    local panelId = ADDON_NAME .. "Options"
    local panelData = {
        type = "panel",
        name = ADDON_NAME,
        displayName = "E|cB040FFZ|rOCustomSupportIcons",
        author = "@Zuriplayer",
        version = ADDON.ADDON_VERSION,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    LAM:RegisterAddonPanel(panelId, panelData)
    LAM:RegisterOptionControls(panelId, {
        {
            type = "header",
            name = "Head icons",
        },
        {
            type = "checkbox",
            name = "Show head icons",
            tooltip = "Show configured custom icons above player characters.",
            getFunc = function()
                return AreHeadIconsEnabled()
            end,
            setFunc = function(value)
                GetSettings().headIconsEnabled = value
                if not value then
                    HideAllIcons()
                end
            end,
            default = DEFAULTS.headIconsEnabled,
        },
        {
            type = "slider",
            name = "Head icon size",
            tooltip = "Size of custom icons shown above player characters.",
            min = 32,
            max = 256,
            step = 1,
            getFunc = function()
                return GetHeadIconSize()
            end,
            setFunc = function(value)
                GetSettings().headIconSize = tonumber(value) or DEFAULTS.headIconSize
            end,
            default = DEFAULTS.headIconSize,
            disabled = function()
                return not AreHeadIconsEnabled()
            end,
        },
    })
end

function ADDON.Initialize()
    ADDON.sv = ZO_SavedVars:NewAccountWide("EZOCustomSupportIconsSV", 1, nil, DEFAULTS)

    renderControl = wm:CreateControl("EZOCustomSupportIconsRenderControl", GuiRoot, CT_CONTROL)
    renderControl:SetAnchorFill(GuiRoot)
    renderControl:Create3DRenderSpace()
    renderControl:SetHidden(true)

    iconWindow = wm:CreateTopLevelWindow("EZOCustomSupportIconsWindow")
    iconWindow:SetAnchorFill(GuiRoot)
    iconWindow:SetMouseEnabled(false)
    iconWindow:SetDrawLayer(DL_OVERLAY)
    iconWindow:SetHidden(false)

    EVENT_MANAGER:RegisterForUpdate(ADDON_NAME .. "Update", UPDATE_MS, ADDON.OnUpdate)
    ADDON.RegisterSettingsPanel()
end

function ADDON.HookGuildRoster()
    if not GUILD_ROSTER_MANAGER or ADDON.guildRosterHooked then
        return
    end

    ADDON.guildRosterHooked = true

    local setupEntry = GUILD_ROSTER_MANAGER.SetupEntry
    function GUILD_ROSTER_MANAGER:SetupEntry(control, data, selected)
        setupEntry(self, control, data, selected)

        local icon = control and control:GetNamedChild("StatusIcon")
        if not icon then
            return
        end

        local texture = GetIconForDisplayName(data and data.displayName)
        local overlay = icon:GetNamedChild("EZOCustomSupportIconsOverlay")
        if texture then
            if overlay then
                overlay:SetHidden(true)
            end

            icon:SetTexture(texture)
            icon:SetDesaturation(data.online and 0 or 1)
            icon:SetColor(1, 1, 1, 1)
            icon:SetDrawLayer(2)
        else
            if overlay then
                overlay:SetHidden(true)
            end
        end
    end

    if GUILD_ROSTER_MANAGER.RefreshData then
        GUILD_ROSTER_MANAGER:RefreshData()
    end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, function(_, addonName)
    if addonName ~= ADDON_NAME then return end
    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
    ADDON.Initialize()
    ADDON.HookGuildRoster()
end)
