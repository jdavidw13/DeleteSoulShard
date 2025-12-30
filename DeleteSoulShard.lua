local _, NS = ...

SLASH_DSS1 = "/dss"

local YELLOW = "FFFF00"

-- per https://wowpedia.fandom.com/wiki/API_DeleteCursorItem DeleteCursorItem() can only be called once per hardware event, this addon is now effectively useless.
--  cleaning up to only delete 1 shard per invoke

--[[
returns the input msg with escape sequences applied to add color to it in the UI
@param msg - the input string
@param color - the color to apply in hex format RRGGBB
]]--
local function colorize(msg, color)
    return "|cFF"..color..msg.."|r"
end

--[[
returns usage string
]]--
local function getUsageString()
    local cmd = "/dss"
    local usage = colorize("DeleteSoulShard Usage: ", YELLOW)..cmd.."\n"
    return usage
end

SlashCmdList["DSS"] = function(msg, editBox)
    local toDelete = 1

    ClearCursor()
    local deleted = 0
    local breakOuter = false
    for bagId = 0, NUM_BAG_SLOTS, 1 do
        local bagSize = C_Container.GetContainerNumSlots(bagId)
        for bagSlotId = 1, bagSize, 1 do
            local info = C_Container.GetContainerItemInfo(bagId, bagSlotId);
            if (info) then
                local itemID = info["itemID"];
                local name = GetItemInfo(itemID)
                if (name == "Soul Shard") then
                    editBox.chatFrame:AddMessage("Deleting shard from bag "..bagId.." slot "..bagSlotId)
                    C_Container.PickupContainerItem(bagId, bagSlotId)
                    DeleteCursorItem()
                    deleted = deleted + 1
                end
            end

            if (deleted >= toDelete) then
                breakOuter = true
                break
            end
        end

        if (breakOuter) then
            break
        end
    end

    editBox.chatFrame:AddMessage("Deleted "..deleted.." shard")
end

print(getUsageString())
