local HashTable = {}
HashTable.__index = HashTable

function HashTable.new(size)
	local self = setmetatable({}, HashTable)
	self.size = size
	self.items = {}
	return self
end

function HashTable:hash(key)
	local value = 0
	for i = 1, #key do
		value = value + string.byte(key, i)
	end
	return value % self.size
end

function HashTable:set(key, value)
	local index = self:hash(key)
	self.items[index] = { key = key, value = value }
end

function HashTable:get(key)
	local index = self:hash(key)
	if self.items[index] then
		return self.items[index].value
	else
		return nil
	end
end

function HashTable:remove(key)
	local index = self:hash(key)
	self.items[index] = nil
end
