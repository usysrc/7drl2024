--
-- Map Class
--
-- Made for tilemaps

local Map = function()
	---@class Map
	local map = {
		data = {},
		init = function(self)
			self.data = {}
		end,
		set = function(self, i, j, what)
			self.data[i .. "," .. j] = what
		end,
		get = function(self, i, j)
			return self.data[i .. "," .. j]
		end,
		all = function(self)
			return self.data
		end,
		isBlocked = function(self, i, j)
			local t = self:get(i, j)
			return t and t.blocked
		end,
	}
	return map
end

return Map
