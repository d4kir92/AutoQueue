local _, AutoQueue = ...
local queueExists = false
local delistBtn = nil
local relistBtn = nil
function AutoQueue:UpdateDelistBtn()
	if delistBtn == nil then return end
	if AutoQueue:GV(AQTAB, "REQUEUE", true) then
		delistBtn:Show()
	else
		delistBtn:Hide()
	end
end

function AutoQueue:UpdateRelistBtn()
	if relistBtn == nil then return end
	if AutoQueue:GV(AQTAB, "REQUEUE", true) then
		if queueExists then
			relistBtn:Show()
		else
			relistBtn:Hide()
		end
	else
		relistBtn:Hide()
	end
end

function AutoQueue:Delist(text)
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

	LFGListFrame.ApplicationViewer.RemoveEntryButton:Click()
	queueExists = true
	AutoQueue:UpdateRelistBtn()
end

function AutoQueue:Relist(text)
	if LFGListFrame.CategorySelection == nil then
		AutoQueue:ERR("Missing CategorySelection")
		return
	end

	if LFGListFrame.CategorySelection.StartGroupButton == nil then
		AutoQueue:ERR("Missing StartGroupButton")
		return
	end

	LFGListFrame.CategorySelection.StartGroupButton:Click()
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

	if LFGListFrame.CategorySelection == nil then
		AutoQueue:ERR("Missing CategorySelection")
		return
	end

	if LFGListFrame.CategorySelection.FindGroupButton == nil then
		AutoQueue:ERR("Missing FindGroupButton")
		return
	end

	delistBtn = AutoQueue:CreateButton("AutoQueueDelistBtn", LFGListFrame.ApplicationViewer.RemoveEntryButton)
	delistBtn:SetSize(22, 22)
	delistBtn:SetPoint("RIGHT", LFGListFrame.ApplicationViewer.EditButton, "RIGHT", 0, 0)
	delistBtn:SetText("|T851904:0:0:0:0|t")
	delistBtn:SetScript("OnClick", function()
		if LFGListFrame == nil then
			AutoQueue:ERR("Missing LFGListFrame")
			return
		end

		if LFGListFrame.ApplicationViewer.EntryName then AutoQueue:Delist(LFGListFrame.ApplicationViewer.EntryName:GetText()) end
	end)

	relistBtn = AutoQueue:CreateButton("AutoQueueRelistBtn", LFGListFrame.CategorySelection.FindGroupButton)
	relistBtn:SetSize(22, 22)
	relistBtn:SetPoint("RIGHT", LFGListFrame.ApplicationViewer.EditButton, "RIGHT", 0, 0)
	relistBtn:SetText("|T851904:0:0:0:0|t")
	relistBtn:SetScript("OnClick", function()
		if LFGListFrame == nil then
			AutoQueue:ERR("Missing LFGListFrame")
			return
		end

		if LFGListFrame.ApplicationViewer.EntryName then AutoQueue:Relist(LFGListFrame.ApplicationViewer.EntryName:GetText()) end
	end)

	AutoQueue:UpdateDelistBtn()
	AutoQueue:UpdateRelistBtn()
end

function AutoQueue:ThinkLFD()
	if LFDRoleCheckPopup and LFDRoleCheckPopup:IsVisible() then
		CompleteLFGRoleCheck(true)
		AutoQueue:After(0.2, function() AutoQueue:ThinkLFD() end, "VISIBLE LFD")
	else
		AutoQueue:After(0.4, function() AutoQueue:ThinkLFD() end, "HIDDEN LFD")
	end
end

function AutoQueue:InitAutoQueue()
	local aq = CreateFrame("Frame")
	AutoQueue:RegisterEvent(aq, "LFG_ROLE_CHECK_SHOW")
	AutoQueue:OnEvent(aq, function(event) if event ~= "OPTIONS" then AutoQueue:After(0.01, function() CompleteLFGRoleCheck(true) end, "CompleteLFGRoleCheck") end end, "LFG_ROLE_CHECK_SHOW")
	AutoQueue:ThinkLFD()
end

local auf = CreateFrame("Frame")
AutoQueue:RegisterEvent(auf, "PLAYER_LOGIN")
AutoQueue:OnEvent(auf, function()
	AutoQueue:UnregisterEvent(auf, "PLAYER_LOGIN")
	AutoQueue:SetAddonOutput("AutoQueue", 136056)
	if AQTAB == nil then AQTAB = AQTAB or {} end
	AutoQueue:SetDbTab(AQTAB)
	AutoQueue:InitSettings()
	AutoQueue:InitAutoQueue()
	AutoQueue:InitReQueue()
end, "AutoQueue")
