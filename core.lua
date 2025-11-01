local _, AutoQueue = ...
local ts = 0.1
function AutoQueue:ReQueue(text)
	if LFGListFrame == nil then
		AutoQueue:ERR("Missing LFGListFrame")

		return
	end

	if LFGListFrame.ApplicationViewer == nil then
		AutoQueue:ERR("Missing ApplicationViewer")

		return
	end

	if LFGListFrame.ApplicationViewer.RemoveEntryButton == nil then
		AutoQueue:ERR("Missing RemoveEntryButton")

		return
	end

	AutoQueue:TryRun(
		function()
			LFGListFrame.ApplicationViewer.RemoveEntryButton:Click()
		end
	)

	AutoQueue:After(
		ts,
		function()
			if LFGListFrame.CategorySelection == nil then
				AutoQueue:ERR("Missing CategorySelection")

				return
			end

			if LFGListFrame.CategorySelection.StartGroupButton == nil then
				AutoQueue:ERR("Missing StartGroupButton")

				return
			end

			local startedGroup = AutoQueue:TryRun(
				function()
					LFGListFrame.CategorySelection.StartGroupButton:Click()
				end
			)

			if startedGroup then
				AutoQueue:After(
					ts,
					function()
						if LFGListFrame.EntryCreation == nil then
							AutoQueue:ERR("Missing EntryCreation")

							return
						end

						if LFGListFrame.EntryCreation.Name == nil then
							AutoQueue:ERR("Missing EntryCreation.Name")

							return
						end

						if false then
							LFGListFrame.EntryCreation.Name:SetText(text) -- Call is illegal when disabled by security settings.
						end

						if LFGListFrame.EntryCreation.ListGroupButton == nil then
							AutoQueue:ERR("Missing ListGroupButton")

							return
						end

						if false then
							LFGListFrame.EntryCreation.ListGroupButton:Click() -- tried to call the protected function 'CreateListing()'.
						end
					end, "Entry Details"
				)
			end
		end, "START"
	)
end

function AutoQueue:InitReQueue()
	if LFGListFrame == nil then
		AutoQueue:ERR("Missing LFGListFrame")

		return
	end

	if LFGListFrame.ApplicationViewer == nil then
		AutoQueue:ERR("Missing ApplicationViewer")

		return
	end

	if LFGListFrame.ApplicationViewer.RemoveEntryButton == nil then
		AutoQueue:ERR("Missing RemoveEntryButton")

		return
	end

	local btn = AutoQueue:CreateButton("ReQueue", LFGListFrame.ApplicationViewer.RemoveEntryButton)
	btn:SetSize(22, 22)
	btn:SetPoint("RIGHT", LFGListFrame.ApplicationViewer.EditButton, "RIGHT", 0, 0)
	btn:SetText("|T851904:0:0:0:0|t")
	btn:SetScript(
		"OnClick",
		function()
			if LFGListFrame == nil then
				AutoQueue:ERR("Missing LFGListFrame")

				return
			end

			if LFGListFrame.ApplicationViewer.EntryName then
				AutoQueue:ReQueue(LFGListFrame.ApplicationViewer.EntryName:GetText())
			end
		end
	)
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

local auf = CreateFrame("Frame")
AutoQueue:RegisterEvent(auf, "PLAYER_LOGIN")
AutoQueue:OnEvent(
	auf,
	function()
		AutoQueue:UnregisterEvent(auf, "PLAYER_LOGIN")
		AutoQueue:SetAddonOutput("AutoQueue", 136056)
		AutoQueue:SetVersion(136056, "1.0.10")
		if AQTAB == nil then
			AQTAB = AQTAB or {}
		end

		AutoQueue:SetDbTab(AQTAB)
		AutoQueue:InitAutoQueue()
		AutoQueue:InitReQueue()
	end, "AutoQueue"
)
