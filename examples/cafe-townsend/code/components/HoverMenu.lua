local PushButton = require "components.PushButton"

local HoverMenu = {}

function HoverMenu:new(parentGroup, buttons)
	local menu = display.newGroup()

	if parentGroup then
		parentGroup:insert(menu)
	end

	function menu:init()
		-- local background = display.newRect(self, 0, 0, 100, 100)
		-- background:setFillColor(0, 0, 0, 0)
		-- background:addEventListener("touch", function(e)
		-- 	print(e.phase)
		-- end)

		local top =  display.newImage("assets/images/hover-top.png")
		top:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(top)
		self.top = top

		local middle =  display.newImage("assets/images/hover-middle.png")
		middle:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(middle)
		self.middle = middle

		local bottom =  display.newImage("assets/images/hover-bottom.png")
		bottom:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(bottom)
		self.bottom = bottom

		local i
		local startX = 8
		local startY = 33
		local button
		for i=1,#buttons do
			button = PushButton:new(self, top.width - 16)
			button:setLabel(buttons[i])
			button:addEventListener("onPushButtonTouched", self)
			button.x = startX
			button.y = startY
			startY = startY + button.height + 8
		end

		bottom.y = button.y + button.height - 6
		middle:setReferencePoint(display.CenterReferencePoint)
		middle.height = bottom.y - (top.x + top.height)
		middle:setReferencePoint(display.TopLeftReferencePoint)
		middle.y = top.x + top.height

		-- background.width = stage.width
		-- background.height = stage.height
		-- background:setReferencePoint(display.TopLeftReferencePoint)
		-- background.x = top.x
		-- background.y = top.y
	end

	function menu:onPushButtonTouched(event)
		self:dispatchEvent({name="onMenuButtonTouched", label=event.target:getLabel()})
	end

	menu:init()

	return menu
end

return HoverMenu