require "components.AutoSizeText"

SearchInput = {}

function SearchInput:new(parentGroup)
	local view = display.newGroup()
	view.FONT_NAME = "HelveticaNeue-Bold"

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local background = display.newImage(self, "assets/images/phone/search-background.png")
		self.background = background
		background:setReferencePoint(display.TopLeftReferencePoint)

		local searchField = native.newTextField(0, 0, background.width - 70, 40)
		self.searchField = searchField
		searchField:setReferencePoint(display.TopLeftReferencePoint)
		searchField.hasBackground = false
		searchField.font = native.newFont(self.FONT_NAME)
		searchField:addEventListener("userInput", self)

		local label = AutoSizeText:new(self)
		self.label = label
		label:setFont(self.FONT_NAME)
		label:setTextColor(100, 100, 100)
		label:setFontSize(21)
		label:setAutoSize(true)
		label:setText("Search")
		label.x = 32
		label.y = 4

		local clear = display.newImage(self, "assets/images/clear-field.png")
		clear:setReferencePoint(display.TopLeftReferencePoint)
		self.clear = clear
		function clear:touch(event)
			if event.phase == "ended" then
				view:onClearField()
			end
			return true
		end
		clear:addEventListener("touch", clear)
		clear.y = 7
		clear.x = background.width - clear.width - 7

		self:move(self.x, self.y)
	end

	function view:move(targetX, targetY)
		self.x = targetX
		self.y = targetY
		local targetX, targetY = self:localToContent(self.background.x, self.background.y)
		self.searchField.x = targetX + 28
		self.searchField.y = targetY + 2
	end

	function view:userInput(event)
		local searchField = self.searchField
		local label = self.label
		local clear = self.clear

		local pStr = tostring(searchField.text)
		if pStr == "" and pStr:len() < 1 then
			label.isVisible = true
			clear.isVisible = false
		else
			label.isVisible = false
			clear.isVisible = true
		end

		if pStr == nil then
			pStr = ""
		end
		self:dispatchEvent({name="onSearch", search=pStr})
	end

	function view:onClearField()
		self.searchField.text = ""
		self:userInput()
	end

	function view:getText()
		return self.searchField.text
	end

	function view:destroy()
		self.searchField:removeSelf()
		self.searchField = nil
		self:removeSelf()
	end

	view:init()

	return view
end

return SearchInput