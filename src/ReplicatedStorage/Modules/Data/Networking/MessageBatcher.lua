local MessageBatching = {}
MessageBatching.__index = MessageBatching

function MessageBatching.new(maxBatchSize, maxBatchInterval)
	local self = setmetatable({}, MessageBatching)
	self.maxBatchSize = maxBatchSize
	self.maxBatchInterval = maxBatchInterval
	self.messages = {}
	self.scheduledSend = nil
	return self
end

function MessageBatching:addMessage(message)
	table.insert(self.messages, message)
	if #self.messages >= self.maxBatchSize then
		self:sendBatch()
	elseif not self.scheduledSend then
		self.scheduledSend = spawn(function()
			wait(self.maxBatchInterval)
			self:sendBatch()
		end)
	end
end

function MessageBatching:sendBatch()
	if #self.messages == 0 then
		return
	end
	local batch = table.concat(self.messages, "")
	-- Send the batch over the network
	self.messages = {}
	self.scheduledSend = nil
end

return MessageBatching
