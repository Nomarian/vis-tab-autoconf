
--[[
	Iterate through entire file, looking for indentation
	on first indentation is found, try to mimic it on settings
--]]

local vis = _G.vis
local M = {
	NAME = "tabautoconf"
	,DESC = "Inherits settings from current file and auto configure"

	,spacelimit = 8 -- tw is guessed from the file

	,search_limit = 500 -- lines to search
	-- set to math.huge to search completely
}

local string = string

-- win.options but because there's no win.options we have to remake it here
local acceptable_options = {
	expand=true, et=true
	,tabwidth=true, tw=true
}

local examine_modeline = function (line)
	line = line:match"^%g*%s*vim?:%s*(.+)"
		or line:match"^%g*%s*ex:%s+(.+)"
	if line==nil then return nil end
	if acceptable_options[ line:match"[^=%s]+" ]==nil then return nil end
	local result = false
	for word, key, val in line:gmatch"(([^=%s]+)=?([^=%s]*))" do
		if acceptable_options[key] then
			if val~="" then
				word = key .. " " .. val
			end
			vis:command("set " .. word)
			result = true
		end
	end
	return result
end

local examine_head = function (file)
	local NR = 0
	local search_limit = M.search_limit
	local tw = M.spacelimit
	for line in file:lines_iterator() do
		NR = NR + 1
		local indent = line:match"^%s+"
		if indent then
			local _, count = indent:gsub(" ", "")
			if count==0 then -- tab
				vis:command"set expandtab off"
				return true
			elseif count>0 then
				vis:command"set expandtab on"
				if count<=tw then
					vis:command("set tabwidth " .. count)
					return true
				end
			end
		end
		if NR>search_limit then
			break
		end
	end
	return false
end

local on_win_open = function (win)
	local file = win.file

	-- no name? new file, don't care.
	if file==nil or file.path==nil then return end

	local lines = file.lines
	if #lines==0 then return end

	local _ =
		examine_modeline(lines[#lines])
		or #lines>1 and examine_modeline(lines[2])
		or #lines>2 and examine_modeline(lines[3])
		or examine_head(file)
end
M.on_win_open = on_win_open

vis.events.subscribe(vis.events.WIN_OPEN, on_win_open)

return M
