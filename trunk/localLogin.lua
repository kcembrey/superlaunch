module(..., package.seeall)
local ui = require("ui")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local defaultField
-- Back Key listener
local function onBackEvent( event )
	local phase = event.phase
	local keyName = event.keyName
	
	if (keyName == "back" and phase == "up") then 
		if defaultField ~= nil then
			defaultField:removeSelf()
			defaultField = nil	
		end
		storyboard.gotoScene("mainMenu")
		return true
	end
end	

local function addKeyEvent()
	print( "adding Key Listener" )
	Runtime:addEventListener( "key", onBackEvent )
end

function scene:createScene( event )
	local group = self.view	

	local bg = display.newImage( "background.png", true )
	
	--Open GameData.sqlite.  If the file doesn't exist it will be created
	local path = system.pathForFile("GameData.sqlite", system.DocumentsDirectory)
	db = sqlite3.open( path )   
	 
	--Handle the applicationExit event to close the db
	function onSystemEvent( event )
		if( event.type == "applicationExit" ) then              
			db:close()
		end
	end
	 
	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )	
	
	group:insert( bg )	
end

function scene:enterScene( event )
	local group = self.view
 
	local function updateUser( stringName )
		storyboard.userName = stringName
		for row in db:nrows("SELECT ixUser, sName FROM tblUsers WHERE sName = '"..storyboard.userName.."'") do
			storyboard.userIndex = row.ixUser break 
		end
		if storyboard.userIndex == 0 then
			local tablefill = [[INSERT INTO tblUsers VALUES (NULL, ']]..storyboard.userName..[[');]]
			native.showAlert( "Superlaunch", "Database Insert = " .. tablefill, { "OK" } )
			db:exec( tablefill )
			for row in db:nrows("SELECT ixUser, sName FROM tblUsers WHERE sName = '"..storyboard.userName.."'") do
				storyboard.userIndex = row.ixUser break 
			end
		end
	end
 
	-- TextField Listener
	local function fieldHandler( getObj )
			
	-- Use Lua closure in order to access the TextField object
	 
			return function( event )
	 
					print( "TextField Object is: " .. tostring( getObj() ) )
					
					if ( "began" == event.phase ) then
							-- This is the "keyboard has appeared" event
					
					elseif ( "ended" == event.phase ) then
							-- This event is called when the user stops editing a field:
							-- for example, when they touch a different field or keyboard focus goes away
					
						native.showAlert( "Superlaunch", "Text entered = " .. tostring( getObj().text ), { "OK" } )
						updateUser(tostring( getObj().text ))
							
							
					elseif ( "submitted" == event.phase ) then
							-- This event occurs when the user presses the "return" key
							-- (if available) on the onscreen keyboard
							
							-- Hide keyboard
							native.setKeyboardFocus( nil )
					end
					
			end     -- "return function()"	 
	end
	 
	-- Create our Text Field
	defaultField = native.newTextField( 10, 30, 180, 30,
			fieldHandler( function() return defaultField end ) )    -- passes the text field object
	
	local backButtonPress = function( event )
		defaultField:removeSelf()
		defaultField = nil
		storyboard.gotoScene("mainMenu")
	end
	
	local submitButtonPress = function( event )
		if defaultField ~= nil then
			if storyboard.username ~= defaultField.text then updateUser(tostring( defaultField.text )) end		
			defaultField.isVisible = false
			defaultField:removeSelf()
			defaultField = nil
		end
		native.showAlert( "SuperLaunch", "User Index is "..storyboard.userIndex.." and Username is "..storyboard.userName, 
									{ "OK" } )
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
	
	local submitButton = ui.newButton{
		defaultSrc = "buttonRed.png",
		x = 240,
		y = 280,
		overSrc = "buttonRedOver.png",
		text = "Login",
		onRelease = submitButtonPress,
		emboss = true
	}
	submitButton.isVisible = true
	
	group:insert(backButton)
	group:insert(submitButton)
	-- Add the back key callback
	timer.performWithDelay( 10, addKeyEvent )
end

function scene:exitScene( event )
	local group = self.view
	
	-- Add the back key callback
	Runtime:removeEventListener( "key", onBackEvent );
end

function scene:destroyScene( event )
	local group = self.view
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene