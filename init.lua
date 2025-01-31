
--[[
	Iterate through entire file, looking for indentation
	on first indentation is found, try to mimic it on settings
--]]

local vis = _G.vis
local M = {
	NAME = "tabautoconf"
	,DESC = "Inherits settings from current file and auto configure"

	,limit = 500 -- lines to search
	-- set to math.huge to search completely
}

local string = string

local on_win_open = function (win)
	local file = win.file

	-- no name? new file, don't care.
	if file==nil or file.path==nil then return end

	-- Examine file
	local NR = 0
	for line in file:lines_iterator() do
		NR = NR + 1
		local indent = line:match"^%s+"
		if indent then
			local expandtab = "off"
			local _, count = indent:gsub(" ", "")
			if count>0 then
				expandtab = "on"
				vis:command("set tabwidth " .. count)
			end
			vis:command("set expandtab " .. expandtab)
			return true
		end
		-- don't want to examine the entire file
		if NR>M.limit then
			break
		end
	end
	return false
end

vis.events.subscribe(vis.events.WIN_OPEN, on_win_open)

return M
