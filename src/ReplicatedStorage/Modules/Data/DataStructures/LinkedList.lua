local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.new()
	local self = setmetatable({}, LinkedList)
	self.head = nil
	self.tail = nil
	return self
end

function LinkedList:pushFront(value)
	local node = { value = value, next = self.head }
	self.head = node
	if self.tail == nil then
		self.tail = node
	end
end

function LinkedList:pushBack(value)
	local node = { value = value, next = nil }
	if self.tail then
		self.tail.next = node
	else
		self.head = node
	end
	self.tail = node
end

function LinkedList:popFront()
	if self.head then
		local value = self.head.value
		self.head = self.head.next
		if self.head == nil then
			self.tail = nil
		end
		return value
	end
end

function LinkedList:popBack()
	if self.head then
		if self.head == self.tail then
			local value = self.head.value
			self.head = nil
			self.tail = nil
			return value
		else
			local current = self.head
			while current.next and current.next ~= self.tail do
				current = current.next
			end
			local value = self.tail.value
			self.tail = current
			self.tail.next = nil
			return value
		end
	end
end

function LinkedList:get(index)
	local current = self.head
	for i = 1, index do
		if current then
			current = current.next
		else
			return nil
		end
	end
	return current and current.value
end

function LinkedList:set(index, value)
	local current = self.head
	for i = 1, index do
		if current then
			current = current.next
		else
			return
		end
	end
	if current then
		current.value = value
	end
end

function LinkedList:remove(index)
	if index == 0 then
		self:popFront()
	elseif index == self:size() - 1 then
		self:popBack()
	else
		local current = self.head
		for i = 1, index - 1 do
			current = current.next
		end
		if current and current.next then
			current.next = current.next.next
		end
	end
end

function LinkedList:size()
	local size = 0
	local current = self.head
	while current do
		size = size + 1
		current = current.next
	end
	return size
end

function LinkedList:clear()
	self.head = nil
	self.tail = nil
end

function LinkedList:print()
	local values = {}
	local current = self.head
	while current do
		values[#values + 1] = current.value
		current = current.next
	end
	print(table.concat(values, ", "))
end

return LinkedList
