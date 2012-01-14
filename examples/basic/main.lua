--[[

	Robotlegs for Corona example: Basic
	
	The following example shows some of how the basics in Robotlges are implemented in Corona/Lua.
	- instantiating your Context (MainContext.lua)
	- mappping your commands and mediators. Notice Mediated view's are required to have a classType property (convention)
	- manually mediating your views via context:createMediator(viewInstance)
	- showing how Mediators set Model data on views, and solve race conditions in case the View's arrive before/after the data
	is in fact ready (PlayerMediator.lua)
	- showing how the standard of multiple View's binding to the same data & responding
	to it via Mediators (Player, HealthBar, and PlayerModel)
	- having a user gesture spawn Controller logic (click on HealButton, it is dispatched via HealButtonMediator,
	who in turn has HealPlayerCommand executed). Also provides optionally Mediator to Model access (HealButtonMediator NOTE)
	
	NOTE: Please keep in mind since mediating views is currently manual, you are responsible for un-mediating them as well.
	
	1.13.2012 - updated to latest widget API and changed x and y for buttons to top and left.
	
	Jesse Warden
	
	Twitter
		http://twitter.com/jesterxl
	
	Email
		jesterxl@jessewarden.com
		jessew@webappsolution.com
		jesse.warden@gmail.com (G+)
		
	Web
		http://jessewarden.com
		http://webappsolution.com
	
	

	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


require "sprite"
require "physics"
widget = require "widget"

require "com.jessewarden.robotlegs.examples.basic.views.Player"
require "com.jessewarden.robotlegs.examples.basic.views.Bullet"
require "com.jessewarden.robotlegs.examples.basic.views.HealthBar"
require "com.jessewarden.robotlegs.examples.basic.views.HealButton"
require "com.jessewarden.robotlegs.examples.basic.views.HealthText"

require "com.jessewarden.robotlegs.examples.basic.BasicContext"

function addLoop(o)
	assert(o ~= nil, "You cannot pass nil values to the game loop")
	local index = table.indexOf(tickers, o)
	if(index == nil) then
		return table.insert(tickers, o)
	else
		error(o .. " is already added to the game loop.")
	end
end

function removeLoop(o)
	for i,v in ipairs(tickers) do
		if(v == o) then
			table.remove(tickers, i)
			return true
		end	
	end
	print("!! item not found !!")
	return false
end

function onRemoveFromGameLoop(event)
	event.target:removeEventListener("removeFromGameLoop", onRemoveFromGameLoop)
	removeLoop(event.target)
end

function animate(event)
	local now = system.getTimer()
	local difference = now - lastTick
	lastTick = now
	
	for i,v in ipairs(tickers) do
		v:tick(difference)
	end
end

function onTouch(event)
	if(event.phase == "began" or event.phase == "moved") then
		player.planeXTarget = event.x
		player.planeYTarget = event.y
		return true
	end
end

function onCreateBullet(event)
	if(event.phase == "release") then
		local bullet = Bullet:new(event.target.x, event.target.y, player)
		bullet:addEventListener("removeFromGameLoop", onRemoveFromGameLoop)
		addLoop(bullet)
	end
	return true
end

function startThisMug()
	physics.start()
	--physics.setDrawMode( "hybrid" )
	physics.setGravity( 0, 0 )
	
	stage = display.getCurrentStage()
	
	tickers = {} -- holds those who wish to participate in the game loop
		
	-- First, setup your Robotlegs Context
	context = BasicContext:new()
	context:startup()
	
	-- Second, create your View's and manually register their Mediators
	-- ...yes, working on figuring out how to make this automatic vs manual mediation
	healthBar = HealthBar:new()
	healthBar.x = stage.width - healthBar.width - 4
	healthBar.y = 40
	context:createMediator(healthBar)
	
	healthText = HealthText:new(stage.x + 30, stage.y + 30, "0/0")
	context:createMediator(healthText)
	
	player = Player.new()
	player.planeXTarget = stage.width / 2
	player.planeYTarget = stage.height / 2
	player.x = player.planeXTarget
	player.y = player.planeYTarget
	addLoop(player)
	context:createMediator(player)
	
	local creatBulletButton = widget.newButton
	{
        id = "createBulletButton",
        left = 0,
        top = stage.height - 72,
        label = "Create Bullet",
        onEvent = onCreateBullet
    }
	
	healButton = HealButton:new(creatBulletButton.x + creatBulletButton.width + 4, stage.height - 72)
	context:createMediator(healButton)
	
	local planeRect = display.newRect(0, 0, stage.width, stage.height - (stage.height - creatBulletButton.y))
	planeRect.strokeWidth = 3
	planeRect:setFillColor(140, 140, 140)
	planeRect:setStrokeColor(180, 180, 180)
	planeRect.name = "planeRect"
	planeRect.alpha = .1
	
	lastTick = system.getTimer()
	
	Runtime:addEventListener("enterFrame", animate )
	planeRect:addEventListener("touch", onTouch)	
end

startThisMug()