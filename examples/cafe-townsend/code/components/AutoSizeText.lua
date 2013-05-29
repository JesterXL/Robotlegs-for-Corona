AutoSizeText = {}

function AutoSizeText:new(parentGroup)

	local view = display.newGroup()
	parentGroup:insert(view)
	view._text = nil
	view._rgba = {255, 255, 255, 255}
	view._fontSize = 18
	view._width = nil
	view._height = nil
	view._autoSize = false
	view._bold = false
	view._fontName = nil

	function view:init()
		self:setText("")
	end

	function view:getText()
		return self._text
	end

	function view:setText(str, bypass)
		if self._text == str and bypass ~= true then
			return true
		end

		if str == nil then str = "nil" end
		
		self._text = str
		if self.field then
			self.field:removeSelf()
			self.field = nil
		end

		local newField
		local fontName
		if self._fontName == nil then
			if self._bold == false then
				fontName = native.systemFont
			else
				fontName = native.systemFontBold
			end
		else
			fontName = self._fontName
		end

		if self._autoSize == true then
			newField = display.newText(str, 0, 0, fontName, self._fontSize)
		else
			-- if self._width == nil then
			-- 	self._width = 0
			-- else
			-- 	self._width = getDivisibleBy4(self._width)
			-- end

			-- if self._height == nil then
			-- 	self._height = 0
			-- else
			-- 	self._height = getDivisibleBy4(self._height)
			-- end
			
			newField = display.newText(str, 0, 0, self._width, self._height, fontName, self._fontSize)
		end
		

		newField:setReferencePoint(display.TopLeftReferencePoint)
		newField:setTextColor(unpack(self._rgba))
		self.field = newField
		self:insert(newField)
		-- field.size = self._fontSize
	end

	function view:setTextColor(r, g, b, alpha)
		if alpha == nil then
			alpha = 255
		end
		self._rgba = {r, g, b, alpha}
		self.field:setTextColor(r, g, b, alpha)
	end

	function view:setFontSize(size)
		self._fontSize = size
		self.field.size = size
	end

	function view:setFont(fontName)
		self._fontName = fontName
		self.field.font = fontName
	end

	function view:setSize(w, h)
		local dirty = false
		if self._width ~= w or self._height ~= h then
			dirty = true
		end
		self._width = w
		self._height = h
		-- [jwarden 5.18.2013] Corona bitches and whines if you set a field to some
		-- value not divisble evenly by 4. #fixed
		local oldH = h
		self._height = self:getDivisibleBy4(self._height)
		local difference = oldH - self._height
		if difference > 0 then
			self._height = self._height + 8
		end
		if dirty then
			self:setText(self._text, true)
		end
	end

	function view:setAutoSize(val)
		if value ~= val then
			self._autoSize = val
			self:setText(self._text, true)
		end
	end

	function view:setBold(bold)
		if value ~= val then
			self._bold = bold
			self:setText(self._text, true)
		end
	end

	function view:getDivisibleBy4(num)
		local value = num
		if value % 4 == 0 then
			return value
		end
		while (value % 4 ~= 0 and value > 4) do
			value = value - 1
		end
		return value
	end


	view:init()

	return view

end

return AutoSizeText