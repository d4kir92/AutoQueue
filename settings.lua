-- By D4KiR
local _, AutoQueue = ...
local aqset = nil
local DEFAULT_WIDTH = 420
local DEFAULT_HEIGHT = 320
function AutoQueue:ToggleSettings()
	if aqset == nil then return end
	aqset:Toggle()
end

local function GetCollapsed(key)
	if key == nil then return nil end
	if type(AQTAB) ~= "table" then return nil end
	if type(AQTAB["COLLAPSED"]) ~= "table" then return nil end
	return AQTAB["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	if key == nil then return end
	if type(AQTAB) ~= "table" then return end
	if type(AQTAB["COLLAPSED"]) ~= "table" then AQTAB["COLLAPSED"] = {} end
	if collapsed then
		AQTAB["COLLAPSED"][key] = true
	else
		AQTAB["COLLAPSED"][key] = nil
	end
end

local function AddCategory(key, level)
	aqset:AddCategory({
		["label"] = "LID_" .. key,
		["key"] = key,
		["search"] = key,
		["level"] = level
	})
end

local function AddCheckbox(key, default, func)
	aqset:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = AutoQueue:GV(AQTAB, key, default),
		["func"] = function(value)
			AutoQueue:SV(AQTAB, key, value)
			if func then func(value) end
		end
	})
end

function AutoQueue:InitSettings()
	AQTAB = AQTAB or {}
	AutoQueue:SetVersion(136056, "1.0.36")
	AutoQueue:AddSlash("aq", AutoQueue.ToggleSettings)
	AutoQueue:AddSlash("autoqueue", AutoQueue.ToggleSettings)
	aqset = AutoQueue:CreateUIWindow({
		["name"] = "AutoQueueSettings",
		["pTab"] = {"CENTER"},
		["width"] = AutoQueue:GV(AQTAB, "WINDOWWIDTH", DEFAULT_WIDTH),
		["height"] = AutoQueue:GV(AQTAB, "WINDOWHEIGHT", DEFAULT_HEIGHT),
		["minWidth"] = 360,
		["minHeight"] = 240,
		["onResize"] = function(width, height)
			AutoQueue:SV(AQTAB, "WINDOWWIDTH", width)
			AutoQueue:SV(AQTAB, "WINDOWHEIGHT", height)
		end,
		["getCollapsed"] = function(key) return GetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
		["title"] = format("|T136056:16:16:0:0|t AutoQueue v%s", AutoQueue:GetVersion())
	})

	aqset:SuspendLayout()
	aqset:AddSearch()
	AddCategory("GENERAL")
	AddCheckbox("MMBTN", AutoQueue:GetWoWBuild() ~= "RETAIL", function(value)
		if value then
			AutoQueue:ShowMMBtn("AutoQueue")
		else
			AutoQueue:HideMMBtn("AutoQueue")
		end
	end)

	AddCheckbox("REQUEUE", true, function() AutoQueue:UpdateReQueue() end)
	aqset:ResumeLayout()
	AutoQueue:CreateMinimapButton({
		["name"] = "AutoQueue",
		["icon"] = 136056,
		["dbtab"] = AQTAB,
		["vTT"] = {{"|T136056:16:16:0:0|t AutoQueue", "v" .. AutoQueue:GetVersion()}, {AutoQueue:Trans("LID_LEFTCLICK"), AutoQueue:Trans("LID_OPENSETTINGS")}, {AutoQueue:Trans("LID_SHIFTRIGHTCLICK"), AutoQueue:Trans("LID_HIDEMINIMAPBUTTON")}},
		["funcL"] = function() AutoQueue:ToggleSettings() end,
		["funcSR"] = function()
			AutoQueue:SV(AQTAB, "MMBTN", false)
			AutoQueue:MSG("Minimap Button is now hidden.")
			AutoQueue:HideMMBtn("AutoQueue")
		end,
		["dbkey"] = "MMBTN"
	})
end
