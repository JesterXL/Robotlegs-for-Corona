local BasicButton = {}

function BasicButton:new(options)

	if options == nil then
		options = {}
	end

	if options.label == nil then
		options.label = "Default"
	end

	local group = display.newGroup()
	group.anchorX = 0
	group.anchorY = 0
	

	if options.x == nil then
		options.x = 0
	end
	if options.y == nil then
		options.y = 0
	end

	if options.width == nil then
		options.width = 100
	end

	if options.height == nil then
		options.height = 60
	end

	local button = display.newRoundedRect(options.x, options.y, options.width, options.height, 8)
	button.strokeWidth = 3
	button:setFillColor(255, 255, 255)
	button:setStrokeColor(0, 0, 0)
	button.name = "button"
	button.anchorX = 0
	button.anchorY = 0
	group:insert(button)

	local text = display.newText(options.label, 0, 0, native.systemFont, 16)
	group:insert(text)
	text:setFillColor(0, 0, 0)
	text.anchorX = 0
	text.anchorY = 0
	text.x = button.x + button.width / 2 - text.width / 2
	text.y = button.y + button.height / 2 - text.height / 2

	if options.onPress ~= nil then

		function group:touch(event)
			options.onPress(event)
		end
		group:addEventListener("touch", group)
	end

	if options.x ~= nil then
		group.x = options.x
	end
	if options.y ~= nil then
		group.y = options.y
	end

	return group
end

return BasicButton