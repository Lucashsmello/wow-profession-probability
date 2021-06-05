local _, core = ...;

local function getProbability(player_skill, recipe_name, tradeskillName)
	local item=core.DATA:getData(recipe_name,tradeskillName);
	--print(recipe_name..":"..item.b.." "..item.e);
	if(item==nil) then
		return nil
	end
	if(player_skill<=item.b) then
		return 1;
	end
	if(player_skill>=item.e) then
		return 0;
	end
	return (item.e-player_skill)/(item.e-item.b);
end

local function On_TradeSkillUpdate()
	--print("========On_TradeSkillUpdate called "..GetNumTradeSkills());
	local tradeskillName,curlevel,_ = GetTradeSkillLine();
	local TSLSF=_G["TradeSkillListScrollFrame"];
	for i = 0,GetNumTradeSkills()-TSLSF.offset do --Check RecipeRadar code for more information about crafting
		local name, stype = GetTradeSkillInfo(i+TSLSF.offset);
		if (name and stype ~= "header") then
			local skillButton = _G["TradeSkillSkill"..i];
			local skillButtonText = _G["TradeSkillSkill"..i.."Text"];
			if(skillButton) then
				local p=getProbability(curlevel,name,tradeskillName)
				if(not (p==nil)) then
					--local oie=skillButton:GetScript("OnClick");
					--oie(skillButton,"LeftButton",1);
					--skillButton:HookScript("OnClick",function ()
						--skillButton:SetText('dasdimbo');
						--skillButtonText:SetText('dasdimbo');
					--end)
					skillButton:SetText(string.format("%s (%.0f%%)",skillButton:GetText(),p*100));
					--skillButtonText:SetText('dasdimbo');
				end
				
			end
		end
	end
	
end

local function OnEvent(self, event, name, ...)
	--print("OnEvent " .. event);
	--if(event == "TRADE_SKILL_UPDATE") then
	--	On_TradeSkillUpdate()
	--end
	if(event == "ADDON_LOADED") then
		if(name == 'Blizzard_TradeSkillUI') then
			hooksecurefunc('TradeSkillFrame_Update', On_TradeSkillUpdate)
		end
	end
end

local events = CreateFrame("Frame");
--events:RegisterEvent("TRADE_SKILL_UPDATE");
events:RegisterEvent('ADDON_LOADED')
events:SetScript("OnEvent", OnEvent);
