local AutoSizeText = require "components.AutoSizeText"
local PushButton = {}

function PushButton:new(parentGroup, layoutWidth, layoutHeight)

	if layoutWidth == nil then
		layoutWidth = 400
	end
	if layoutHeight == nil then
		layoutHeight = 67
	end

	local button = display.newGroup()
	button.anchorX = 0
	button.anchorY = 0
	button.layoutWidth = layoutWidth
	button.layoutHeight = layoutHeight

	if parentGroup then
		parentGroup:insert(button)
	end

	function button:init()
		local left =  display.newImage("assets/images/push-button-left.png")
		left.anchorX = 0
		left.anchorY = 0
		self:insert(left)
		self.left = left

		local center =  display.newImage("assets/images/push-button-center.png")
		center.anchorX = 0
		center.anchorY = 0
		self:insert(center)
		self.center = center

		local right =  display.newImage("assets/images/push-button-right.png")
		right.anchorX = 0
		right.anchorY = 0
		self:insert(right)
		self.right = right

		local field = AutoSizeText:new(self)
		field:setTextColor(255, 255, 255)
		field:setFontSize(28)
		field:setAutoSize(true)
		field:setText("Label")
		self.field = field

		self:addEventListener("touch", self)

		self:setSize(self.layoutWidth, self.layoutHeight)
	end

	function button:setSize(layoutWidth, layoutHeight)
		self.layoutWidth = layoutWidth
		self.layoutHeight = layoutHeight

		local left = self.left
		local center = self.center
		local right = self.right

		left.x = 0
		left.y = 0
		right.x = layoutWidth - right.width
		right.y = 0
		-- [jwarden 5.28.2013] What in God's name, guys... seriously...
		-- center:setReferencePoint(display.CenterReferencePoint)
		center.width = layoutWidth - left.width - right.width
		center.anchorX = 0
		center.anchorY = 0
		center.x = left.x + left.width
		center.y = 0

		self:sizeText()
	end

	function button:sizeText()
		local field = self.field
		field.x = self.layoutWidth / 2 - field.width / 2
		field.y = self.layoutHeight / 2 - field.height / 2
		field.y = field.y - 4
	end

	function button:setLabel(text)
		self.field:setText(text)
		self:sizeText()
	end

	function button:getLabel()
		return self.field:getText()
	end

	function button:touch(event)
		if event.phase == "ended" then
			self:dispatchEvent({name="onPushButtonTouched", target=self})
			return true
		end
	end

	button:init()

	return button

end

return PushButton