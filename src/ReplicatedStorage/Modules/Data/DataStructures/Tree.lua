local Tree = {}
Tree.__index = Tree

function Tree.new(value)
	local self = setmetatable({}, Tree)
	self.value = value
	self.children = {}
	return self
end

function Tree:addChild(value)
	local child = Tree.new(value)
	self.children[#self.children + 1] = child
	return child
end

function Tree:traverse(fn)
	fn(self)
	for i, child in ipairs(self.children) do
		child:traverse(fn)
	end
end

function Tree:print()
	self:traverse(function(node)
		print(node.value)
	end)
end

function Tree:removeChild(value)
	for i, child in ipairs(self.children) do
		if child.value == value then
			table.remove(self.children, i)
			break
		else
			child:removeChild(value)
		end
	end
end

function Tree:find(value)
	local result
	self:traverse(function(node)
		if node.value == value then
			result = node
		end
	end)
	return result
end

return Tree

--[[

	local root = Tree.new("Root")

]]

--[[

	local child1 = root:addChild("Child 1")
	local child2 = root:addChild("Child 2")
	local grandchild = child1:addChild("Grandchild")


]]
