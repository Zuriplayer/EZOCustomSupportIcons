EZOCustomSupportIcons = EZOCustomSupportIcons or {}
local ADDON = EZOCustomSupportIcons

local ADDON_NAME = "EZOCustomSupportIcons"
local LOGGER_TAG = ADDON_NAME
local INFO_HEADER_TEXTURE = "EsoUI/Art/Miscellaneous/help_icon.dds"
local FEEDBACK_URL = "https://discord.gg/ekw8zUAcRm"
local UPDATE_MS = 10
local SAVED_VARIABLES_NAME = "EZOCustomSupportIconsSV"
local SAVED_VARIABLES_VERSION = 1
local MIGRATION_MARKER = "__ezoPreferenceScopeMigrated"
local DEFAULTS = {
    headIconsEnabled = true,
    hideHeadIconsInCombat = false,
    headIconSize = 96,
}
local ICON_OFFSET_M = 2.8
local FADE_DISTANCE_M = 7.5
local ICONS = {
    ["@zuriplayer"] = "EZOCustomSupportIcons/icons/zuriplayer.dds",
}
local iconPacks = {}
local registeredPlayerIcons = {}
local TACTICAL_MARKERS = {
    {
        id = "follow",
        label = "Follow",
        texture = "esoui/art/lfg/lfg_leader_icon.dds",
    },
    {
        id = "heal",
        label = "Heal",
        texture = "esoui/art/lfg/gamepad/lfg_roleicon_healer.dds",
    },
    {
        id = "tank",
        label = "Tank",
        texture = "esoui/art/lfg/gamepad/lfg_roleicon_tank.dds",
    },
    {
        id = "focus",
        label = "Focus",
        texture = "esoui/art/lfg/gamepad/lfg_roleicon_dps.dds",
    },
    {
        id = "mechanic",
        label = "Mechanic",
        texture = "esoui/art/icons/mapkey/mapkey_groupboss.dds",
    },
}
local TACTICAL_MARKER_BY_ID = {}

for _, marker in ipairs(TACTICAL_MARKERS) do
    TACTICAL_MARKER_BY_ID[marker.id] = marker
end

local function DeepCopy(src)
    if type(src) ~= "table" then
        return src
    end

    local out = {}
    for key, value in pairs(src) do
        out[key] = DeepCopy(value)
    end
    return out
end

local function ApplyDefaults(target, defaults)
    if type(target) ~= "table" or type(defaults) ~= "table" then
        return
    end

    for key, value in pairs(defaults) do
        if target[key] == nil then
            target[key] = DeepCopy(value)
        elseif type(target[key]) == "table" and type(value) == "table" then
            ApplyDefaults(target[key], value)
        end
    end
end

local function CopySavedValues(target, source)
    if type(target) ~= "table" or type(source) ~= "table" then
        return
    end

    for key, value in pairs(source) do
        if key ~= MIGRATION_MARKER then
            target[key] = DeepCopy(value)
        end
    end
end

local function GetPreferenceScope()
    if EZOCore and type(EZOCore.GetPreferenceScope) == "function" then
        local ok, scope = pcall(function()
            return EZOCore:GetPreferenceScope("ezocustomsupporticons", "settings")
        end)
        if ok and scope == "character" then
            return "character"
        end
    end
    return "account"
end

local function LogInfo(message)
    if ADDON._debugLoggerUnavailable == true then
        return false
    end

    local lib = _G.LibDebugLogger
    if type(lib) ~= "function" and type(lib) ~= "table" then
        ADDON._debugLoggerUnavailable = true
        return false
    end

    if not ADDON._debugLogger and type(lib) == "function" then
        local ok, logger = pcall(lib, LOGGER_TAG)
        if ok then
            ADDON._debugLogger = logger
        end
    end
    if not ADDON._debugLogger and type(lib) == "table" and type(lib.Create) == "function" then
        local ok, logger = pcall(function()
            return lib:Create(LOGGER_TAG)
        end)
        if ok then
            ADDON._debugLogger = logger
        end
    end

    local logger = ADDON._debugLogger
    if logger and type(logger.Info) == "function" then
        ADDON._debugLoggerUnavailable = false
        return pcall(function()
            logger:Info(tostring(message or ""))
        end)
    end

    ADDON._debugLoggerUnavailable = true
    return false
end

local function GetClientLanguage()
    if type(GetCVar) == "function" then
        local language = zo_strlower(tostring(GetCVar("language.2") or ""))
        local prefix = language:sub(1, 2)
        if prefix == "es" then return "es" end
        if prefix == "en" then return "en" end
    end

    return "en"
end

local function IsLanguageManagedByEZOCore()
    if not (EZOCore and type(EZOCore.IsLanguageGloballyManaged) == "function") then
        return false
    end

    local ok, managed = pcall(function()
        return EZOCore:IsLanguageGloballyManaged()
    end)

    return ok and managed == true
end

local function GetEffectiveLanguage()
    if IsLanguageManagedByEZOCore() then
        local ok, inherited = pcall(function()
            return EZOCore:GetLanguage()
        end)
        if ok and (inherited == "es" or inherited == "en") then
            return inherited
        end
    end

    return GetClientLanguage()
end

local function NormalizeDisplayName(displayName)
    if type(displayName) ~= "string" or displayName == "" then
        return nil
    end

    return string.lower(displayName)
end

local function NormalizePackId(packId)
    if type(packId) ~= "string" or packId == "" then
        return nil
    end

    return string.lower(packId)
end

local function NormalizeGuildName(guildName)
    if type(guildName) ~= "string" or guildName == "" then
        return nil
    end

    return string.lower(guildName)
end

local function IsIconPackEnabledForPlayer(packId)
    local pack = iconPacks[packId]
    if not pack or not pack.guilds or #pack.guilds == 0 then
        return true
    end

    local guildCount = GetNumGuilds and GetNumGuilds() or 0
    for guildIndex = 1, guildCount do
        local guildId = GetGuildId(guildIndex)
        local guildName = NormalizeGuildName(GetGuildName(guildId))
        if guildName and pack.guildLookup[guildName] then
            return true
        end
    end

    return false
end

local function IsTacticalMarkerAvailable(marker)
    return marker and (not marker.packId or IsIconPackEnabledForPlayer(marker.packId))
end

local function RegisterPlayerIcon(packId, displayName, texture)
    local normalizedName = NormalizeDisplayName(displayName)
    if not normalizedName or type(texture) ~= "string" or texture == "" then
        return
    end

    registeredPlayerIcons[normalizedName] = {
        texture = texture,
        packId = packId,
    }
end

local function RegisterAssignableIcon(packId, packName, iconId, iconData)
    local sourceId = NormalizePackId(iconId)
    local texture
    local label

    if type(iconData) == "string" then
        texture = iconData
        label = iconId
    elseif type(iconData) == "table" then
        sourceId = NormalizePackId(iconData.id or iconId)
        texture = iconData.texture
        label = iconData.label or iconData.name or iconData.id or iconId
    end

    if not sourceId or type(texture) ~= "string" or texture == "" then
        return
    end

    local markerId = packId .. ":" .. sourceId
    local marker = TACTICAL_MARKER_BY_ID[markerId]
    if not marker then
        marker = { id = markerId }
        table.insert(TACTICAL_MARKERS, marker)
    end

    marker.label = tostring(label or sourceId)
    marker.menuLabel = tostring(packName or packId) .. ": " .. marker.label
    marker.texture = texture
    marker.packId = packId
    TACTICAL_MARKER_BY_ID[markerId] = marker
end

function ADDON.RegisterIconPack(packIdOrData, maybeData)
    local packData = maybeData or packIdOrData
    if type(packData) ~= "table" then
        return false
    end

    local packId = NormalizePackId(maybeData and packIdOrData or packData.id)
    if not packId then
        return false
    end

    local packName = packData.name or packData.displayName or packId
    local pack = {
        id = packId,
        name = packName,
        version = packData.version,
        guilds = {},
        guildLookup = {},
    }

    local guilds = packData.guilds
    if type(guilds) == "string" then
        guilds = { guilds }
    elseif type(guilds) ~= "table" and type(packData.guildName) == "string" then
        guilds = { packData.guildName }
    end

    if type(guilds) == "table" then
        for _, guildName in ipairs(guilds) do
            local normalizedGuildName = NormalizeGuildName(guildName)
            if normalizedGuildName then
                table.insert(pack.guilds, guildName)
                pack.guildLookup[normalizedGuildName] = true
            end
        end
    end

    iconPacks[packId] = pack

    local players = packData.players or packData.uniqueIcons or packData.fixedIcons
    if type(players) == "table" then
        for key, value in pairs(players) do
            if type(value) == "table" then
                RegisterPlayerIcon(packId, value.displayName or key, value.texture)
            else
                RegisterPlayerIcon(packId, key, value)
            end
        end
    end

    local assignableIcons = packData.assignableIcons or packData.icons
    if type(assignableIcons) == "table" then
        for _, value in ipairs(assignableIcons) do
            RegisterAssignableIcon(packId, packName, value.id, value)
        end

        for key, value in pairs(assignableIcons) do
            if type(key) ~= "number" then
                RegisterAssignableIcon(packId, packName, key, value)
            end
        end
    end

    return true
end

local wm = WINDOW_MANAGER
local renderControl
local iconWindow
local iconPool = {}
local tacticalAssignments = {}
local LAM_STRINGS = {
    en = {
        panelDisplayName = "E|cB040FFZ|rOCustomSupportIcons",
        headIconsHeader = "Head icons",
        headIconsHeaderTooltip = "Controls the visual icon overlay above configured players and locally marked "
            .. "group members. These settings only affect display on your client.",
        showHeadIconsName = "Show head icons",
        showHeadIconsTooltip = "Show or hide all custom and tactical icons rendered above player characters.",
        headIconSizeName = "Head icon size",
        headIconSizeTooltip = "Sets the base size, in UI pixels, for icons rendered above player characters.",
        hideHeadIconsInCombatName = "Hide head icons in combat",
        hideHeadIconsInCombatTooltip = "Hide configured head icons while you are in combat. Dead players stay "
            .. "visible so they can be located.",
    },
    es = {
        panelDisplayName = "E|cB040FFZ|rOCustomSupportIcons",
        headIconsHeader = "Iconos sobre cabeza",
        headIconsHeaderTooltip = "Controla el overlay visual de iconos sobre jugadores configurados y miembros "
            .. "del grupo marcados localmente. Estos ajustes solo afectan a tu cliente.",
        showHeadIconsName = "Mostrar iconos sobre cabeza",
        showHeadIconsTooltip = "Muestra u oculta todos los iconos personalizados y tácticos renderizados sobre "
            .. "personajes jugadores.",
        headIconSizeName = "Tamaño de icono sobre cabeza",
        headIconSizeTooltip = "Define el tamaño base, en píxeles de interfaz, de los iconos renderizados sobre "
            .. "personajes jugadores.",
        hideHeadIconsInCombatName = "Ocultar iconos en combate",
        hideHeadIconsInCombatTooltip = "Oculta los iconos configurados sobre la cabeza mientras estás en combate. "
            .. "Los jugadores muertos siguen visibles para poder localizarlos.",
    },
}

local function GetLamStrings()
    local language = GetEffectiveLanguage()
    return LAM_STRINGS[language] or LAM_STRINGS.en
end

local function CreateInfoHeader(name, tooltip)
    return {
        type = "header",
        name = zo_strformat(
            "<<1>> |cB040FF|t26:26:<<2>>:inheritcolor|t|r",
            tostring(name or ""),
            INFO_HEADER_TEXTURE
        ),
        tooltip = tooltip,
    }
end

local function GetSettings()
    ADDON.sv = ADDON.sv or DEFAULTS
    return ADDON.sv
end

local function AreHeadIconsEnabled()
    return GetSettings().headIconsEnabled ~= false
end

local function IsHudSceneShowing()
    return SCENE_MANAGER
        and (SCENE_MANAGER:IsShowing("hud") or SCENE_MANAGER:IsShowing("hudui"))
end

local function ShouldHideHeadIconsInCombat()
    return GetSettings().hideHeadIconsInCombat == true
end

local function GetHeadIconSize()
    return tonumber(GetSettings().headIconSize) or DEFAULTS.headIconSize
end

local function GetIconForDisplayName(displayName)
    local normalizedName = NormalizeDisplayName(displayName)
    if not normalizedName then
        return nil
    end

    local registeredIcon = registeredPlayerIcons[normalizedName]
    if registeredIcon and IsIconPackEnabledForPlayer(registeredIcon.packId) then
        return registeredIcon.texture
    end

    return ICONS[normalizedName]
end

local function GetTacticalMarkerForDisplayName(displayName)
    if not IsUnitGrouped("player") then
        return nil
    end

    local normalizedName = NormalizeDisplayName(displayName)
    if not normalizedName then
        return nil
    end

    local marker = TACTICAL_MARKER_BY_ID[tacticalAssignments[normalizedName]]
    if IsTacticalMarkerAvailable(marker) then
        return marker
    end

    return nil
end

local function GetTacticalMarkerTextureForDisplayName(displayName)
    local marker = GetTacticalMarkerForDisplayName(displayName)
    return marker and marker.texture or nil
end

local function IsDisplayNameInCurrentGroup(displayName)
    local normalizedName = NormalizeDisplayName(displayName)
    if not normalizedName or not IsUnitGrouped("player") then
        return false
    end

    if NormalizeDisplayName(GetUnitDisplayName("player")) == normalizedName then
        return true
    end

    for i = 1, GROUP_SIZE_MAX do
        local unitTag = "group" .. i
        if DoesUnitExist(unitTag) and NormalizeDisplayName(GetUnitDisplayName(unitTag)) == normalizedName then
            return true
        end
    end

    return false
end

local function RefreshGroupLists()
    if GROUP_LIST and GROUP_LIST.RefreshData then
        GROUP_LIST:RefreshData()
    end

    if GROUP_LIST_GAMEPAD then
        if GROUP_LIST_GAMEPAD.RefreshData then
            GROUP_LIST_GAMEPAD:RefreshData()
        elseif GROUP_LIST_GAMEPAD.RefreshList then
            GROUP_LIST_GAMEPAD:RefreshList()
        end
    end
end

local function PruneTacticalAssignments()
    if not IsUnitGrouped("player") then
        tacticalAssignments = {}
        RefreshGroupLists()
        return
    end

    local activeNames = {}
    local playerDisplayName = NormalizeDisplayName(GetUnitDisplayName("player"))
    if playerDisplayName then
        activeNames[playerDisplayName] = true
    end

    for i = 1, GROUP_SIZE_MAX do
        local unitTag = "group" .. i
        if DoesUnitExist(unitTag) then
            local displayName = NormalizeDisplayName(GetUnitDisplayName(unitTag))
            if displayName then
                activeNames[displayName] = true
            end
        end
    end

    local changed = false
    for displayName in pairs(tacticalAssignments) do
        if not activeNames[displayName] then
            tacticalAssignments[displayName] = nil
            changed = true
        end
    end

    if changed then
        RefreshGroupLists()
    end
end

local function SetTacticalMarker(displayName, markerId)
    local normalizedName = NormalizeDisplayName(displayName)
    if not normalizedName or not TACTICAL_MARKER_BY_ID[markerId] or not IsDisplayNameInCurrentGroup(displayName) then
        return
    end

    tacticalAssignments[normalizedName] = markerId
    RefreshGroupLists()
end

local function ClearTacticalMarker(displayName)
    local normalizedName = NormalizeDisplayName(displayName)
    if not normalizedName then
        return
    end

    tacticalAssignments[normalizedName] = nil
    RefreshGroupLists()
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

local function ShouldShowHeadIconForUnit(unitTag)
    if not ShouldHideHeadIconsInCombat() or not IsUnitInCombat("player") then
        return true
    end

    return IsUnitDead(unitTag)
end

local function GetConfiguredTexture(unitTag)
    local displayName = GetUnitDisplayName(unitTag)
    return GetTacticalMarkerTextureForDisplayName(displayName) or GetIconForDisplayName(displayName)
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

    if not IsHudSceneShowing() then
        return
    end

    if not AreHeadIconsEnabled() then
        return
    end

    local playerTexture = GetConfiguredTexture("player")
    local camera = GetCamera()

    if playerTexture and CanShowPlayer() and ShouldShowHeadIconForUnit("player") then
        ProjectUnit("player", playerTexture, camera)
    end

    if not IsUnitGrouped("player") then
        return
    end

    for i = 1, GROUP_SIZE_MAX do
        local unitTag = "group" .. i
        if not AreUnitsEqual("player", unitTag) and CanShowUnit(unitTag) and ShouldShowHeadIconForUnit(unitTag) then
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

    local strings = GetLamStrings()
    local panelId = ADDON_NAME .. "Options"
    local panelData = {
        type = "panel",
        name = ADDON_NAME,
        displayName = strings.panelDisplayName,
        author = "@Zuriplayer",
        version = ADDON.ADDON_VERSION,
        ezoStage = "development",
        feedback = FEEDBACK_URL,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local options = {
        CreateInfoHeader(strings.headIconsHeader, strings.headIconsHeaderTooltip),
        {
            type = "checkbox",
            name = strings.showHeadIconsName,
            tooltip = strings.showHeadIconsTooltip,
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
            name = strings.headIconSizeName,
            tooltip = strings.headIconSizeTooltip,
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
        {
            type = "checkbox",
            name = strings.hideHeadIconsInCombatName,
            tooltip = strings.hideHeadIconsInCombatTooltip,
            getFunc = function()
                return ShouldHideHeadIconsInCombat()
            end,
            setFunc = function(value)
                GetSettings().hideHeadIconsInCombat = value
                if value and IsUnitInCombat("player") then
                    HideAllIcons()
                end
            end,
            default = DEFAULTS.hideHeadIconsInCombat,
            disabled = function()
                return not AreHeadIconsEnabled()
            end,
        },
    }

    if EZOCore and type(EZOCore.RegisterSettingsPanel) == "function" then
        local registered = EZOCore:RegisterSettingsPanel(ADDON_NAME, panelId, panelData, options)
        if registered then
            ADDON.ezoSettingsRegistered = true
            return
        end
    end

    ADDON._lamPanel = LAM:RegisterAddonPanel(panelId, panelData)
    LAM:RegisterOptionControls(panelId, options)
end

function ADDON.RegisterGroupContextMenu()
    local LCM = LibCustomMenu
    if not LCM or ADDON.groupContextMenuRegistered then
        return
    end

    ADDON.groupContextMenuRegistered = true

    local function AddItems(data)
        local displayName = data and data.displayName
        if not IsDisplayNameInCurrentGroup(displayName) then
            return
        end

        for _, marker in ipairs(TACTICAL_MARKERS) do
            if IsTacticalMarkerAvailable(marker) then
                local markerId = marker.id
                local markerLabel = marker.menuLabel or marker.label
                AddCustomMenuItem("EZO marker: " .. markerLabel, function()
                    SetTacticalMarker(displayName, markerId)
                end)
            end
        end

        if GetTacticalMarkerForDisplayName(displayName) then
            AddCustomMenuItem("EZO marker: Clear", function()
                ClearTacticalMarker(displayName)
            end)
        end
    end

    LCM:RegisterGroupListContextMenu(AddItems, LCM.CATEGORY_LATE)
end

function ADDON.HookGroupList()
    if not GROUP_LIST or not GROUP_LIST.SetupGroupEntry or ADDON.groupListHooked then
        return
    end

    ADDON.groupListHooked = true

    local setupGroupEntry = GROUP_LIST.SetupGroupEntry
    function GROUP_LIST:SetupGroupEntry(control, data)
        setupGroupEntry(self, control, data)

        local texture = GetTacticalMarkerTextureForDisplayName(data and data.displayName)
        local icon = control and control.leaderIcon
        if not texture or not icon then
            return
        end

        icon:SetTexture(texture)
        icon:SetDesaturation(data.online and 0 or 1)
        icon:SetColor(1, 1, 1, 1)
        icon:SetHidden(false)
    end
end

function ADDON.HookGamepadGroupList()
    if not GROUP_LIST_GAMEPAD or not GROUP_LIST_GAMEPAD.SetupRow or ADDON.gamepadGroupListHooked then
        return
    end

    ADDON.gamepadGroupListHooked = true

    local setupRow = GROUP_LIST_GAMEPAD.SetupRow
    function GROUP_LIST_GAMEPAD:SetupRow(control, data, selected)
        setupRow(self, control, data, selected)

        local texture = GetTacticalMarkerTextureForDisplayName(data and data.displayName)
        if not texture then
            return
        end

        local nameControl = control and control:GetNamedChild("DisplayName")
        if nameControl then
            nameControl:SetText(zo_iconTextFormat(texture, 32, 32, ZO_FormatUserFacingDisplayName(data.displayName)))
        end
    end
end

function ADDON.RegisterGroupEvents()
    local function OnGroupChanged()
        zo_callLater(PruneTacticalAssignments, 100)
    end

    if EVENT_GROUP_UPDATE then
        EVENT_MANAGER:RegisterForEvent(ADDON_NAME .. "GroupUpdate", EVENT_GROUP_UPDATE, OnGroupChanged)
    end

    if EVENT_GROUP_MEMBER_JOINED then
        EVENT_MANAGER:RegisterForEvent(ADDON_NAME .. "GroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, OnGroupChanged)
    end

    if EVENT_GROUP_MEMBER_LEFT then
        EVENT_MANAGER:RegisterForEvent(ADDON_NAME .. "GroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, OnGroupChanged)
    end
end

function ADDON.Initialize()
    local scope = GetPreferenceScope()
    ADDON.preferenceScope = scope

    if scope == "character" then
        ADDON.sv = ZO_SavedVars:NewCharacterIdSettings(
            SAVED_VARIABLES_NAME,
            SAVED_VARIABLES_VERSION,
            nil,
            DEFAULTS)
        if type(ADDON.sv) == "table" and ADDON.sv[MIGRATION_MARKER] ~= true then
            local accountSv = ZO_SavedVars:NewAccountWide(
                SAVED_VARIABLES_NAME,
                SAVED_VARIABLES_VERSION,
                nil,
                nil)
            CopySavedValues(ADDON.sv, accountSv)
            ADDON.sv[MIGRATION_MARKER] = true
        end
    else
        ADDON.sv = ZO_SavedVars:NewAccountWide(SAVED_VARIABLES_NAME, SAVED_VARIABLES_VERSION, nil, DEFAULTS)
    end
    ApplyDefaults(ADDON.sv, DEFAULTS)
    ADDON.LogInfo = LogInfo
    ADDON.DebugLog = LogInfo
    LogInfo("Initialized.")

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
    ADDON.RegisterGroupContextMenu()
    ADDON.HookGroupList()
    ADDON.HookGamepadGroupList()
    ADDON.RegisterGroupEvents()
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
