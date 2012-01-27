module(..., package.seeall)
local ui = require("ui")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-- Back Key listener
local function onBackEvent( event )
	local phase = event.phase
	local keyName = event.keyName
	
	if (keyName == "back" and phase == "up") then 
		Runtime:removeEventListener( "key", onBackEvent )
		storyboard.gotoScene("mainMenu")
	end
	return true
end

function scene:createScene( event )
	local group = self.view
	
	local bg = display.newImage( "background.png", true )
	
	local topBoundary = display.screenOriginY
	local bottomBoundary = display.screenOriginY
	
	local Character = "noah"
	local noahButton = nil
	local babyButton = nil
	local dogButton = nil
	local slingShotButton = nil
	local hardLaunchButton = nil
	
	local mainLabel = ui.newLabel{
			bounds = { display.contentWidth /2 - 105, 65 + display.screenOriginY, 100, 24 }, -- align label with right side of current screen
			text = "Select a Character",
			--font = "Trebuchet-BoldItalic",
			textColor = { 0, 0, 0, 255 },
			size = 33,
			align = "center"
		}
	
	local backButtonPress = function( event )
		Runtime:removeEventListener( "key", onBackEvent )
		storyboard.gotoScene("mainMenu")
	end
	
	local backButton = ui.newButton{
		defaultSrc = "btn_back.png",
		overSrc = "btn_back.png",
		onRelease = backButtonPress,
		emboss = true,
		x = 450,
		y = 30
	}
	backButton.isVisible = true
	
	local function showLaunchType()
		noahButton.isVisible = false
		babyButton.isVisible = false
		dogButton.isVisible = false
		mainLabel.setText("Select Launch Type")
		slingShotButton.isVisible = true
		hardLaunchButton.isVisible = true
	end
	
	local function noahButtonPress()
		character = "noah"	
		showLaunchType()
	end
	
	local function babyButtonPress()
		character = "baby"
		showLaunchType()
	end
	
	local function dogButtonPress()
		character = "dog"
		showLaunchType()
	end

	noahButton = ui.newButton{
					defaultSrc = "noah.png",
					onEvent = noahButtonPress,
					emboss = true,
					x = 180,
					y = 240
				}
	babyButton = ui.newButton{
					defaultSrc = "baby.png",
					onEvent = babyButtonPress,
					emboss = true,
					x = 320,
					y = 240
				}
	dogButton = ui.newButton{
					defaultSrc = "dog.png",
					onEvent = dogButtonPress,
					emboss = true,
					x = 250,
					y = 140
				}
		
	local function slingShotButtonPress()
		storyboard.arguments = {character, true, "slingShot"}
		storyboard.gotoScene("levelMenu")
	end
	local function hardLaunchButtonPress()
		storyboard.arguments = {character, true, "hardLaunch"}
		storyboard.gotoScene("levelMenu")
	end
	
	slingShotButton = ui.newButton{
				defaultSrc = "buttonRed.png",
				onEvent = slingShotButtonPress,
				overSrc = "buttonRedOver.png",
				text = "SlingShot Mode",
				emboss = true,
				x = 240,
				y = 44
			}
	slingShotButton.isVisible = false	
	hardLaunchButton = ui.newButton{
				defaultSrc = "buttonRed.png",
				onEvent = hardLaunchButtonPress,
				overSrc = "buttonRedOver.png",
				text = "Hard Launch Mode",
				emboss = true,
				x = 240,
				y = 288
			}
	hardLaunchButton.isVisible = false	
	
	
	group:insert( bg )
	group:insert( mainLabel )
	group:insert( backButton )
	group:insert(noahButton)
	group:insert(babyButton)
	group:insert(dogButton)
	group:insert( slingShotButton )	
	group:insert( hardLaunchButton )
end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view
end

function scene:destroyScene( event )
	local group = self.view
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene