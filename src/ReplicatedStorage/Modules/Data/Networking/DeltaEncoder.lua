local DeltaEncoder = {}
DeltaEncoder.__index = DeltaEncoder

function DeltaEncoder.new()
	local self = setmetatable({}, DeltaEncoder)
	self.lastValues = {}
	return self
end

function DeltaEncoder:encode(values)
	local encodedValues = {}
	for i, value in ipairs(values) do
		local lastValue = self.lastValues[i] or value
		encodedValues[i] = value - lastValue
		self.lastValues[i] = value
	end
	return encodedValues
end

function DeltaEncoder:decode(encodedValues)
	local values = {}
	for i, encodedValue in ipairs(encodedValues) do
		local lastValue = self.lastValues[i] or 0
		values[i] = encodedValue + lastValue
		self.lastValues[i] = values[i]
	end
	return values
end

return DeltaEncoder
