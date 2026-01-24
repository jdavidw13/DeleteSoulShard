local _, NS = ...

-- Minimap button
local minimapButton = CreateFrame("Button", "DeleteSoulShardMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)
minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

-- Icon texture
local icon = minimapButton:CreateTexture(nil, "ARTWORK")
icon:SetTexture("Interface\\AddOns\\DeleteSoulShard\\dss")
icon:SetSize(20, 20)
icon:SetPoint("CENTER", minimapButton, "CENTER", 0, 0)

-- Border overlay
local border = minimapButton:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(56, 56)
border:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 0, 0)

-- Position around minimap
local function UpdatePosition(angle)
    local radius = 80
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Dragging functionality
local isDragging = false
minimapButton:SetMovable(true)
minimapButton:EnableMouse(true)
minimapButton:RegisterForClicks("LeftButtonUp")
minimapButton:RegisterForDrag("LeftButton")

minimapButton:SetScript("OnDragStart", function(self)
    isDragging = true
end)

minimapButton:SetScript("OnDragStop", function(self)
    isDragging = false
    -- Calculate and save angle
    local mx, my = Minimap:GetCenter()
    local px, py = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    px, py = px / scale, py / scale
    local angle = math.atan2(py - my, px - mx)
    DeleteSoulShardDB.minimapAngle = angle
    UpdatePosition(angle)
end)

minimapButton:SetScript("OnUpdate", function(self)
    if isDragging then
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        local angle = math.atan2(py - my, px - mx)
        UpdatePosition(angle)
    end
end)

-- Click to open options
minimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" and NS.optionsCategory then
        Settings.OpenToCategory(NS.optionsCategory:GetID())
    end
end)

-- Tooltip
minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Delete Soul Shard")
    GameTooltip:AddLine("Click to open options", 1, 1, 1)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Initialize position after saved variables are loaded
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "DeleteSoulShard" then
        if not DeleteSoulShardDB then
            DeleteSoulShardDB = {}
        end
        if DeleteSoulShardDB.minimapAngle == nil then
            DeleteSoulShardDB.minimapAngle = 2.5 -- Default position (upper left)
        end
        UpdatePosition(DeleteSoulShardDB.minimapAngle)
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Store reference in namespace
NS.minimapButton = minimapButton
