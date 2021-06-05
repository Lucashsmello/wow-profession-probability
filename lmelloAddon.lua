local _, core = ...;



function dumptable(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dumptable(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end



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
	local tradeskillName,curlevel,_ = GetTradeSkillLine();
	local TSLSF=_G["TradeSkillListScrollFrame"];
	--print("========On_TradeSkillUpdate called "..tradeskillName);
	--print(TradeSkillSkillName:IsVisible());
	--print(dumptable(TradeSkillSkillName))
	
	for i = 0,GetNumTradeSkills()-TSLSF.offset do
		local name, stype = GetTradeSkillInfo(i+TSLSF.offset);
		if (name and stype ~= "header") then
			local skillButton = _G["TradeSkillSkill"..i];
			--local skillButtonText = _G["TradeSkillSkill"..i.."Text"];
			if(skillButton) then
			    --print(name)
				local p=getProbability(curlevel,name,tradeskillName)
				if(not (p==nil)) then
					
					--local oie=skillButton:GetScript("OnClick");
					--oie(skillButton,"LeftButton",1);
					--skillButton:HookScript("OnClick",function ()
						--skillButton:SetText('dasdimbo');
					--end)
					
					skillButton:SetText(string.format("%s (%.0f%%)",skillButton:GetText(),p*100));
				end
				
			end
		end
	end
	
end

local function OnEvent(self, event, name, ...)
	--print("OnEvent " .. event);
	if(event == "ADDON_LOADED") then
		if(name == 'Blizzard_TradeSkillUI') then
			hooksecurefunc('TradeSkillFrame_Update', On_TradeSkillUpdate)
			--hooksecurefunc(TradeSkillFrame,'Show',On_TradeSkillUpdate)
		end
	end
	--if(event == "TRADE_SKILL_SHOW") then
	--	On_TradeSkillUpdate();
	--end
end

local events = CreateFrame("Frame");
--events:RegisterEvent("TRADE_SKILL_SHOW");
events:RegisterEvent('ADDON_LOADED')
events:SetScript("OnEvent", OnEvent);
