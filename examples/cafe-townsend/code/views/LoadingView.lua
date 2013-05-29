require "components.AutoSizeText"
require "components.Spinner"
LoadingView = {}

function LoadingView:new()
	local view = display.newGroup()
	view.classType = "LoadingView"

	function view:init()
		local background = display.newRect(self, 0, 0, stage.width, stage.height)
		background:setReferencePoint(display.TopLeftReferencePoint)
		background:setFillColor(100, 100, 100, 200)
		self.background = background

		local box = display.newRoundedRect(self, 0, 0, 260, 160, 6)
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

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:setLabel(text)
		self.field:setText(text)
		self:resize()
	end

	function view:resize()
		local box = self.box
		local field = self.field
		local spinner = self.spinner
		box.x = stage.width / 2 - box.width / 2
		box.y = stage.height * 0.2
		field.x = stage.width / 2 - field.width / 2
		field.y = box.y + box.height / 2 - field.height / 2 + 30
		spinner.x = stage.width / 2 - spinner.width
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