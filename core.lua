local _, AutoQueue = ...
function AutoQueue:InitAutoQueue()
	local aq = CreateFrame("Frame")
	AutoQueue:RegisterEvent(aq, "LFG_ROLE_CHECK_SHOW")
	AutoQueue:OnEvent(
		aq,
		function(event)
			if event ~= "OPTIONS" then
				AutoQueue:After(
					0.01,
					function()
						CompleteLFGRoleCheck(true)
					end, "CompleteLFGRoleCheck"
				)
			end
		end, "LFG_ROLE_CHECK_SHOW"
	)

	AutoQueue:ThinkLFD()
end

function AutoQueue:ThinkLFD()
	if LFDRoleCheckPopup and LFDRoleCheckPopup:IsVisible() then
		CompleteLFGRoleCheck(true)
		AutoQueue:After(
			0.2,
			function()
				AutoQueue:ThinkLFD()
			end, "VISIBLE LFD"
		)
	else
		AutoQueue:After(
			0.4,
			function()
				AutoQueue:ThinkLFD()
			end, "HIDDEN LFD"
		)
	end
end

local auf = CreateFrame("Frame")
AutoQueue:RegisterEvent(auf, "PLAYER_LOGIN")
AutoQueue:OnEvent(
	auf,
	function()
		AutoQueue:UnregisterEvent(auf, "PLAYER_LOGIN")
		AutoQueue:SetAddonOutput("AutoQueue", 136056)
		AutoQueue:SetVersion(136056, "1.0.3")
		if AQTAB == nil then
			AQTAB = AQTAB or {}
		end

		AutoQueue:SetDbTab(AQTAB)
		AutoQueue:InitAutoQueue()
	end, "AutoQueue"
)
