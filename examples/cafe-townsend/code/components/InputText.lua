require "components.AutoSizeText"

InputText = {}

function InputText:new(parentGroup, layoutWidth, layoutHeight, promptText)
	local view = display.newGroup()
	view.FONT_NAME = "HelveticaNeue-Bold"
	view.FONT = native.newFont(view.FONT_NAME)
	view.promptText = promptText
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local field = native.newTextField(0, 0, layoutWidth, layoutHeight)
		self.field = field
		field:setReferencePoint(display.TopLeftReferencePoint)
		field.hasBackground = false
		field.font = self.FONT
		field.size = 11
		field:addEventListener("userInput", self)

		local label = AutoSizeText:new(self)
		self.label = label
		label:setFont(self.FONT_NAME)
		label:setTextColor(150, 150, 150)
		label:setFontSize(21)
		label:setAutoSize(true)
		label:setText(self.promptText)

		self:move(self.x, self.y)
	end

	function view:move(targetX, targetY)
		self.x = targetX
		self.y = targetY

		local field = self.field
		local label = self.label

		local targetX, targetY = self:localToContent(label.x, label.y)

		field.x = targetX
		field.y = targetY
	end

	function view:getText()
		return self.field.text
	end

	function view:setText(value)
		self.field.text = value
		self:updateVisibility()
	end

	function view:userInput(event)
		self:updateVisibility()
		self:dispatchEvent(event)
	end

	function view:updateVisibility()
		local field = self.field
		local label = self.label

		local pStr = tostring(field.text)
		if pStr == "" and pStr:len() < 1 then
			label.isVisible = true
		else
			label.isVisible = false
		end
	end

	function view:destroy()
		self.field:removeSelf()
		self.field = nil

		self:removeSelf()
	end

	view:init()

	return view
end

return InputText