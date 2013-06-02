require "components.AutoSizeText"
require "components.Spinner"
LoadingView = {}

function LoadingView:new(parentGroup)
	local view = display.newGroup()
	view.classType = "LoadingView"

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local background = display.newRect(self, 0, 0, display.actualContentWidth, display.actualContentHeight)
		background:setReferencePoint(display.TopLeftReferencePoint)
		background:setFillColor(100, 100, 100, 200)
		self.background = background
		-- [jwarden 5.29.2013] Mortal Kombat voice "MODALITY!"
		function background:touch(e)
			return true
		end
		function background:tap(e)
			return true
		end
		background:addEventListener("touch", background)
		background:addEventListener("tap", background)

		local box = display.newRoundedRect(self, 0, 0, 340, 200, 6)
		box:setReferencePoint(display.TopLeftReferencePoint)
		box:setFillColor(100, 100, 100, 235)
		self.box = box

		local field = AutoSizeText:new(self)
		self.field = field
		field:setFont("HelveticaNeue-Bold")
		field:setTextColor(255, 255, 255)
		field:setFontSize(31)
		field:setAutoSize(true)

		local spinner = Spinner:new(self)
		self.spinner = spinner
		spinner.xScale = 2
		spinner.yScale = 2

		self:resize()

		Runtime:addEventListener("orientation", self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:setLabel(text)
		self.field:setText(text)
		self:resize()
	end

	function view:orientation()
		self:resize()
	end

	function view:resize()
		local background = self.background
		local box = self.box
		local field = self.field
		local spinner = self.spinner

		background.width = display.actualContentWidth
		background.height = display.actualContentHeight
		background:setReferencePoint(display.TopLeftReferencePoint)
		background.x = 0
		background.y = 0

		box.x = display.actualContentWidth / 2 - box.width / 2
		box.y = display.actualContentHeight * 0.3
		field.x = display.actualContentWidth / 2 - field.width / 2
		field.y = box.y + box.height / 2 - field.height / 2 + 30
		spinner.x = display.actualContentWidth / 2 - spinner.width
		spinner.y = box.y + 8
	end

	function view:show(toShow)
		self:cancelTween()
		if toShow then
			self.alpha = 0
			self.tweenID = transition.to(self, {time = 500, alpha = 1, transition=easing.outExpo})
		else
			self.tweenID = transition.to(self, {time = 500, alpha = 0, transition=easing.outExpo})
		end
	end

	function view:cancelTween()
		if self.tweenID then
			transition.cancel(self.tweenID)
			self.tweenID = nil
		end
	end

	view:init()

	return view
end

return LoadingView