local function bootstrap()
	display.setStatusBar(display.HiddenStatusBar)
	_G.stage = display.getCurrentStage()

	local background = display.newRect(0, 0, stage.width, stage.height)

	require "CafeTownsendContext"
	local context = CafeTownsendContext:new()
	context:init()


	require "views.LoginView"
	local view = LoginView:new()
	view:move(stage.width / 2 - view.width / 2, stage.height * 0.2)

	require "views.LoadingView"
	local loadingView = LoadingView:new()


end

local function testSpinner()
	local sheet = graphics.newImageSheet("assets/images/spinner.png", {width=26, height=26, numFrames=12})
	local sequenceData = 
	{
		{
			name="spin",
			start=1,
			count=12,
			time=1000,
		}
	}

	local sprite = display.newSprite(sheet, sequenceData)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:setSequence("spin")
	sprite:play()
	sprite.x = 200
	sprite.y = 200
end

local function testBackground()
	-- local img = display.newImage("assets/images/phone/background.png")
	local background = display.newRect(0, 0, stage.width, stage.height)
end

local function testLogin()
	require "views.LoginView"
	local view = LoginView:new()
	view:move(stage.width / 2 - view.width / 2, stage.height * 0.2)
end

local function testShowFonts()
	local g = display.newGroup()
	local fonts = native.getFontNames()
	local count, found_count = 0, 0
	for i,fontname in ipairs(fonts) do
	    count = count+1
	    j, k = string.find(fontname, "HelveticaNeue")
	    if (j ~= nil) then
	        found_count = found_count + 1
	        print("found font: " .. fontname)
	        local obj = display.newText(fontname, 0, (found_count - 1) * 40, fontname, 24)
	        g:insert(obj)
	        obj:setTextColor(255, 255, 255)
	    end
	end
	print ("Font count: " .. count)
	local count_text = display.newText("Found " .. count .. " fonts.", 0, (found_count) * 40, fontname, 18)
	g:insert(count_text)
	count_text:setTextColor(255, 255, 255)
end

local function testPushButton()
	require "components.PushButton"
	local button = PushButton:new()
	button.x = 30
	button.y = 30
end

bootstrap()

-- testBackground()
-- testSpinner()
-- testLogin()
-- testShowFonts()
-- testPushButton()