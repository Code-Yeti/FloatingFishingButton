-- VARIABLES
local DefaultLootValue = 10 --Amount in silver
FFB_Conf = {};

-- Control Frame
local FFB = CreateFrame("Button",nil, UIParent, "SecureActionButtonTemplate");
FFB:SetSize(64,64);
FFB:SetPoint("CENTER",100,-200);


FFB.texture = FFB:CreateTexture(nil, "BACKGROUND")

FFB:SetAttribute("type", "spell");
FFB:SetAttribute("spell", "Fishing");

FFB:SetAttribute("type1", "macro") -- left click causes macro
FFB:SetAttribute("macrotext1", "/cast Fishing") -- text for macro on left click
FFB:RegisterForClicks("LeftButtonUp")

FFB.texture:SetTexture("Interface\\AddOns\\FloatingFishingButton\\button.tga")
FFB.texture:SetAllPoints(true)


FFB:SetMovable(true)
FFB:EnableMouse(true)
FFB:SetScript("OnMouseDown", function(self, button)
  if button == "RightButton" and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
  end
end)
FFB:SetScript("OnMouseUp", function(self, button)
  if button == "RightButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
   point, relativeTo, relativePoint, xOfs, yOfs = FFB:GetPoint();
   FFB_Conf.location.x = xOfs;
   FFB_Conf.location.y = yOfs;
   --DEFAULT_CHAT_FRAME:AddMessage("Location X=" . FFB_Conf.location.x . " Y=" . FFB_Conf.location.y);

  end
end)

FFB:Hide();

-- Register Loot Events
FFB:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
FFB:RegisterEvent("ADDON_LOADED");
FFB:RegisterEvent("BAG_UPDATE");
FFB:RegisterEvent("PLAYER_REGEN_ENABLED");



-- SLASH COMMANDS
-- SLASH_LOOTDADDY1 = '/ld';

local function checkRod()
    inLockdown = InCombatLockdown()
    if inLockdown == false then
        local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
        local _, _, _, _, _, _, itemType = GetItemInfo(mainHandLink)
        if itemType == "Fishing Poles" then
            FFB:Show();
        else
            FFB:Hide();
        end 
    end
end

FFB:SetScript("OnEvent", function(self,event,arg1)

    if event == "ADDON_LOADED" and arg1 == "FloatingFishingButton" then

        -- Load Settings
        if FFB_Conf.location == nil then 
            FFB_Conf.location = {};
            FFB_Conf.location.x = 100;
            FFB_Conf.location.y = -200;
        end
        FFB:SetPoint("CENTER",FFB_Conf.location.x,FFB_Conf.location.y);
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Floating Fishing Button|r Locked and Loaded!");
    end

    if event == "EQUIPMENT_SWAP_FINISHED" or event == "BAG_UPDATE" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "PLAYER_REGEN_ENABLED" then
        checkRod();
    end

end)

