local _, NS = ...

-- Create the options panel
local optionsPanel = CreateFrame("Frame", "DeleteSoulShardOptionsPanel", UIParent)
optionsPanel.name = "DeleteSoulShard"

-- Title
local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Delete Soul Shard")

-- Horizontal rule
local hr = optionsPanel:CreateTexture(nil, "ARTWORK")
hr:SetHeight(1)
hr:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
hr:SetPoint("RIGHT", optionsPanel, "RIGHT", -16, 0)
hr:SetColorTexture(0.6, 0.6, 0.6, 0.8)

-- Slider label
local sliderLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
sliderLabel:SetPoint("TOPLEFT", hr, "BOTTOMLEFT", 0, -24)
sliderLabel:SetText("Minimum Shard(s) to Keep")

-- Slider
local slider = CreateFrame("Slider", "DeleteSoulShardMinShardsSlider", optionsPanel, "OptionsSliderTemplate")
slider:SetPoint("TOPLEFT", sliderLabel, "BOTTOMLEFT", 0, -16)
slider:SetWidth(200)
slider:SetHeight(20)
slider:SetMinMaxValues(0, 100)
slider:SetValueStep(1)
slider:SetObeyStepOnDrag(true)

-- Add slider background
local sliderBg = slider:CreateTexture(nil, "BACKGROUND")
sliderBg:SetPoint("TOPLEFT", slider, "TOPLEFT", 0, -8)
sliderBg:SetPoint("BOTTOMRIGHT", slider, "BOTTOMRIGHT", 0, 8)
sliderBg:SetColorTexture(0.15, 0.15, 0.15, 0.8)

-- Add slider track
local sliderTrack = slider:CreateTexture(nil, "ARTWORK")
sliderTrack:SetPoint("LEFT", slider, "LEFT", 4, 0)
sliderTrack:SetPoint("RIGHT", slider, "RIGHT", -4, 0)
sliderTrack:SetHeight(4)
sliderTrack:SetColorTexture(0.4, 0.4, 0.4, 1)

-- Slider min/max labels
_G[slider:GetName() .. "Low"]:SetText("0")
_G[slider:GetName() .. "High"]:SetText("100")
_G[slider:GetName() .. "Text"]:SetText("")

-- Info note
local infoNote = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
infoNote:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -16)
infoNote:SetTextColor(0.7, 0.7, 0.7)
infoNote:SetText("Keep at least this many shards when using /dss")

-- EditBox for direct input
local editBox = CreateFrame("EditBox", "DeleteSoulShardMinShardsEditBox", optionsPanel, "InputBoxTemplate")
editBox:SetPoint("LEFT", slider, "RIGHT", 16, 0)
editBox:SetSize(50, 20)
editBox:SetAutoFocus(false)
editBox:SetNumeric(true)
editBox:SetMaxLetters(3)

-- Slider OnValueChanged
slider:SetScript("OnValueChanged", function(self, value)
    local intValue = math.floor(value + 0.5)
    editBox:SetText(tostring(intValue))
    if DeleteSoulShardDB then
        DeleteSoulShardDB.minShardsToKeep = intValue
        NS.minShardsToKeep = intValue
    end
end)

-- EditBox OnEnterPressed
editBox:SetScript("OnEnterPressed", function(self)
    local value = tonumber(self:GetText()) or 0
    value = math.max(0, math.min(100, value))
    self:SetText(tostring(value))
    slider:SetValue(value)
    self:ClearFocus()
end)

-- EditBox OnEscapePressed
editBox:SetScript("OnEscapePressed", function(self)
    self:SetText(tostring(math.floor(slider:GetValue() + 0.5)))
    self:ClearFocus()
end)

-- EditBox loses focus
editBox:SetScript("OnEditFocusLost", function(self)
    local value = tonumber(self:GetText()) or 0
    value = math.max(0, math.min(100, value))
    self:SetText(tostring(value))
    slider:SetValue(value)
end)

-- Print Status label
local printStatusLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
printStatusLabel:SetPoint("TOPLEFT", infoNote, "BOTTOMLEFT", 0, -24)
printStatusLabel:SetText("Print Status Messages To Chat")

-- Checkbox for Print Status Messages
local printStatusCheckbox = CreateFrame("CheckButton", "DeleteSoulShardPrintStatusCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
printStatusCheckbox:SetPoint("LEFT", printStatusLabel, "RIGHT", 8, 0)
printStatusCheckbox.Text:SetText("")

printStatusCheckbox:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    if DeleteSoulShardDB then
        DeleteSoulShardDB.printStatus = isChecked
    end
    NS.printStatus = isChecked
end)

-- Show Minimap Button label
local showMinimapLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
showMinimapLabel:SetPoint("TOPLEFT", printStatusLabel, "BOTTOMLEFT", 0, -24)
showMinimapLabel:SetText("Show Minimap Button")

-- Checkbox for Show Minimap Button
local showMinimapCheckbox = CreateFrame("CheckButton", "DeleteSoulShardShowMinimapCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
showMinimapCheckbox:SetPoint("LEFT", showMinimapLabel, "RIGHT", 8, 0)
showMinimapCheckbox.Text:SetText("")

showMinimapCheckbox:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    if DeleteSoulShardDB then
        DeleteSoulShardDB.showMinimapButton = isChecked
    end
    NS.showMinimapButton = isChecked
    if NS.minimapButton then
        if isChecked then
            NS.minimapButton:Show()
        else
            NS.minimapButton:Hide()
        end
    end
end)

-- Initialize values when panel shows
optionsPanel:SetScript("OnShow", function(self)
    local currentValue = (DeleteSoulShardDB and DeleteSoulShardDB.minShardsToKeep) or 5
    slider:SetValue(currentValue)
    editBox:SetText(tostring(currentValue))

    local printStatusValue = (DeleteSoulShardDB and DeleteSoulShardDB.printStatus) or false
    printStatusCheckbox:SetChecked(printStatusValue)

    local showMinimapValue = (DeleteSoulShardDB and DeleteSoulShardDB.showMinimapButton)
    if showMinimapValue == nil then showMinimapValue = true end
    showMinimapCheckbox:SetChecked(showMinimapValue)
end)

-- Register with Interface Options (modern Settings API)
local category = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name)
Settings.RegisterAddOnCategory(category)

-- Store reference in namespace
NS.optionsPanel = optionsPanel
NS.optionsCategory = category
