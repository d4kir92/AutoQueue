local _, AutoQueue = ...
local queueExists = false
local requeueBtn = nil
local requeueBtn2 = nil
function AutoQueue:UpdateReQueue()
	if requeueBtn == nil then return end
	if AutoQueue:GV(AQTAB, "REQUEUE", true) then
		requeueBtn:Show()
	else
		requeueBtn:Hide()
	end
end

function AutoQueue:UpdateReQueue2()
	if requeueBtn2 == nil then return end
	if AutoQueue:GV(AQTAB, "REQUEUE", true) then
		if queueExists then
			requeueBtn2:Show()
		else
			requeueBtn2:Hide()
		end
	else
		requeueBtn2:Hide()
	end
end

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

	LFGListFrame.ApplicationViewer.RemoveEntryButton:Click()
	queueExists = true
	AutoQueue:UpdateReQueue2()
end

function AutoQueue:ReQueue2(text)
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

	local btn = AutoQueue:CreateButton("ReQueue", LFGListFrame.ApplicationViewer.RemoveEntryButton)
	btn:SetSize(22, 22)
	btn:SetPoint("RIGHT", LFGListFrame.ApplicationViewer.EditButton, "RIGHT", 0, 0)
	btn:SetText("|T851904:0:0:0:0|t")
	btn:SetScript("OnClick", function()
		if LFGListFrame == nil then
			AutoQueue:ERR("Missing LFGListFrame")
			return
		end

		if LFGListFrame.ApplicationViewer.EntryName then AutoQueue:ReQueue(LFGListFrame.ApplicationViewer.EntryName:GetText()) end
	end)

	requeueBtn = btn
	local btn2 = AutoQueue:CreateButton("ReQueue", LFGListFrame.CategorySelection.FindGroupButton)
	btn2:SetSize(22, 22)
	btn2:SetPoint("RIGHT", LFGListFrame.ApplicationViewer.EditButton, "RIGHT", 0, 0)
	btn2:SetText("|T851904:0:0:0:0|t")
	btn2:SetScript("OnClick", function()
		if LFGListFrame == nil then
			AutoQueue:ERR("Missing LFGListFrame")
			return
		end

		if LFGListFrame.ApplicationViewer.EntryName then AutoQueue:ReQueue2(LFGListFrame.ApplicationViewer.EntryName:GetText()) end
	end)

	AutoQueue:UpdateReQueue()
	AutoQueue:UpdateReQueue2()
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
