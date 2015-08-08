local Spinner = {}

function Spinner:new(parentGroup)
	if Spinner.sheet == nil then
		Spinner.sheet = graphics.newImageSheet("assets/images/spinner.png", {width=26, height=26, numFrames=12})
		Spinner.sequenceData = 
		{
			{
				name="spin",
				start=1,
				count=12,
				time=1000,
			}
		}
	end
	local spinner = display.newSprite(Spinner.sheet, Spinner.sequenceData)
	if parentGroup then
		parentGroup:insert(spinner)
	end
	spinner.anchorX = 0
	spinner.anchorY = 0
	spinner:setSequence("spin")
	spinner:play()

	return spinner
end

return Spinner