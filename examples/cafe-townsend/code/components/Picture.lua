local AutoSizeText = require "components.AutoSizeText"

local Picture = {}

function Picture:new(parentGroup)
	local view = display.newGroup()
	view.FONT_NAME = "HelveticaNeue-Bold"

	if parentGroup then
		parentGroup:insert(view)
	end
	
	function view:init()
		local background = display.newImage(self, "assets/images/phone/picture-frame.png")
		background:setReferencePoint(display.TopLeftReferencePoint)
		self.background = background
		function background:touch(event)
			if event.phase == "ended" then
				view:dispatchEvent({name="onAddTouched"})
			end
			return true
		end
		background:addEventListener("touch", background)

		local addField = AutoSizeText:new(self)
		self.addField = addField
		addField:setFont(self.FONT_NAME)
		addField:setFontSize(21)
		addField:setTextColor(0, 0, 0)
		-- addField:setAutoSize(true)
		addField:setSize(background.width - 20, 0)
		addField:setText("Add\nPicture")
		addField.x = background.width / 2 - addField.width / 2
		addField.y = background.height / 2 - addField.height / 2
		-- why would I want to center text? I mean, who does that.
	end

	function view:setImage(url)
		if self.image then
			self.image:removeSelf()
			self.image = nil
		end

		if url then
			self.image = display.newImage(self, url)
		end
	end

	view:init()

	return view
end

return Picture