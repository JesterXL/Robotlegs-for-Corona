require "components.AutoSizeText"
DeleteButton = {}

function DeleteButton:new(parentGroup, layoutWidth, layoutHeight)

	if layoutWidth == nil then
		layoutWidth = 400
	end
	if layoutHeight == nil then
		layoutHeight = 67
	end

	local button = display.newGroup()
	button.layoutWidth = layoutWidth
	button.layoutHeight = layoutHeight

	if parentGroup then
		parentGroup:insert(button)
	end

	function button:init()
		local left =  display.newImage("assets/images/push-button-delete-left.png")
		left:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(left)
		self.left = left

		local center =  display.newImage("assets/images/push-button-delete-center.png")
		center:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(center)
		self.center = center

		local right =  display.newImage("assets/images/push-button-delete-right.png")
		right:setReferencePoint(display.TopLeftReferencePoint)
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
		-- [jwarden 5.28.2013] What in God's name, guys... seriously... ...NO SERIOUSLY, WTF
		center:setReferencePoint(display.CenterReferencePoint)
		center.width = layoutWidth - left.width - right.width
		center:setReferencePoint(display.TopLeftReferencePoint)
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

	function button:touch(event)
		if event.phase == "ended" then
			self:dispatchEvent({name="onDeleteButtonTouched", target=self})
			return true
		end
	end

	button:init()

	return button

end

return DeleteButton