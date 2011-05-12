module(..., package.seeall)

function new( arguments )
	local scene = {}
	require "sprite"
	local physics = require( "physics" )
	local ui = require( "ui" )
	local tbaUI = require( "tbaUI" )
	local worldFunctions = require( "superLaunchWorldFunctions" )
	require('socket')
	--physics.setDrawMode( "hybrid" )
	local groundReferencePoint = 335
	local mainCharacter
	local mainContainerGroup
	local game
	local overlayDisplay
	---[[load sounds
	local explosionSound = audio.loadSound("grenade.mp3")
	local bounceSound = audio.loadSound("boing.ogg")
	local swooshSound = audio.loadSound("swoosh.mp3")	
	--]]------
	local totalScore = {}
	local timeLeft = 100
	math.randomseed( os.time() )
	math.random()
	if arguments ~= nil and # arguments > 1 and arguments[2] == true then						
		timeMode = true
		timeBar = tbaUI.newBar{
			bounds = { 0, 290 + display.screenOriginY, 5, 5 },
			lineColor = { 0, 255, 50, 255 },
			size = timeLeft,
			width = 5
		}
		timeBar.bodyName = "timeBar"
		timeBar:setSize( timeLeft )
		timeBar.isVisible = true
		print( "timeMode on")
		local tTimeLeft = system.getTimer()
		local function timeCheck( event )
			local tTimeLeftDelta = (event.time - tTimeLeft)
			if timeMode and tTimeLeftDelta > 750 then
				tTimeLeft = event.time;
				timeLeft = timeLeft - 1
				timeBar:setSize( timeLeft )
			end
		end
		Runtime:addEventListener( "enterFrame", timeCheck )
	end
	
	function start()
		physics.start()
		--physics.setDrawMode( "hybrid" )
		worldLength = 0
		local slingShot
		local slingShotString
		local life = 100
		local explosion
		local boost = 100
		local worldLength = 0
		mainContainerGroup = display.newGroup()
		game = display.newGroup()
		mainContainerGroup:insert( game )
		game.x = 0
		overlayDisplay = display.newGroup()
		mainContainerGroup:insert( overlayDisplay )	
						
		worldFunctions.createFirstSection(physics, game)
		for i=1,2 do
			worldFunctions.AddSection(physics, worldlength, game)
		end		
		
		local timeBar
		local timeMode = false
		
		mainCharacterShape = { 16,-22, 16,0, 14,20, 10,31, -10,32, -14,20, -19,-6, -14, -20 }

		if arguments ~= nil then
			print ("Number of Arguments = " .. #arguments)
			local character = arguments[1]
			print("Character is: "..character)
			if character == "noah" then
				local sheet1 = sprite.newSpriteSheet( "noahSprite.png", 64, 64 )
				local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 4)
				sprite.add( spriteSet1, "mainCharacterSprite", 1, 4, 500, 0 ) -- play 8 frames every 1000 ms
				mainCharacter = sprite.newSprite( spriteSet1 )		
			elseif character == "baby" then
				local sheet1 = sprite.newSpriteSheet( "babySprite.png", 44, 64 )
				local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 4)
				sprite.add( spriteSet1, "mainCharacterSprite", 1, 4, 500, 0 ) -- play 8 frames every 1000 ms
				mainCharacter = sprite.newSprite( spriteSet1 )	
			elseif character == "dog" then
				local sheet1 = sprite.newSpriteSheet( "dogSprite.png", 64, 80 )
				local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 4)
				sprite.add( spriteSet1, "mainCharacterSprite", 1, 4, 500, 0 ) -- play 8 frames every 1000 ms
				mainCharacter = sprite.newSprite( spriteSet1 )		
				mainCharacter:rotate(90)
			end
		else
			local sheet1 = sprite.newSpriteSheet( "noahSprite.png", 64, 64 )
			local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 4)
			sprite.add( spriteSet1, "mainCharacterSprite", 1, 4, 500, 0 ) -- play 8 frames every 1000 ms
			mainCharacter = sprite.newSprite( spriteSet1 )	
		end
		mainCharacter.x = 160; mainCharacter.y = groundReferencePoint - 200

		slingshotString = display.newImage( "string.png" )
		slingshotString.x = 150; slingshotString.y = groundReferencePoint - 180
		slingshotString.bodyName = "slingShotString"
		game:insert(slingshotString)
		--joint = physics.newJoint( "pivot", slingshot, slingshotString, 55, 220 )

		slingshot = display.newImage( "slingshot.png" )
		slingshot.x = 170; slingshot.y = groundReferencePoint - 180
		physics.addBody( slingshot, "static", { friction=0.5 } )
		slingshot.bodyName = "slingShot"
		game:insert(slingshot)

		------------------------------------------------------------
		-- Simple score display

		local scoreDisplay = ui.newLabel{
			bounds = { display.contentWidth - 120, 10 + display.screenOriginY, 100, 24 }, -- align label with right side of current screen
			text = "0",
			--font = "Trebuchet-BoldItalic",
			textColor = { 255, 225, 102, 255 },
			size = 32,
			align = "right"
		}
		scoreDisplay.bodyName = "scoreDisplay"
		overlayDisplay:insert( scoreDisplay )
		score = 0
		scoreDisplay:setText( score )


		------------------------------------------------------------
		-- Life display


		local lifeBar = tbaUI.newBar{
			bounds = { 0, 10 + display.screenOriginY, 5, 5 },
			lineColor = { 0, 255, 50, 255 },
			size = life,
			width = 5
		}
		lifeBar.bodyName = "lifeBar"
		overlayDisplay:insert( lifeBar )
		lifeBar:setSize( life )
		
		------------------------------------------------------------
		-- boost display


		local boostBar = tbaUI.newBar{
			bounds = { 400, 290 + display.screenOriginY, 5, 5 },
			lineColor = { 0, 255, 50, 255 },
			size = boost,
			width = 5
		}
		boostBar.bodyName = "boostBar"
		overlayDisplay:insert( boostBar )
		boostBar:setSize( boost )
		
		local function showExplosion()		
			local explosionSheet = sprite.newSpriteSheet( "explosionSprite.png", 170, 130 )
			local explosionSpriteSet = sprite.newSpriteSet(explosionSheet, 1, 4)
			sprite.add( explosionSpriteSet, "explosionSprite", 1, 4, 2500, 1 )
			explosion = sprite.newSprite( explosionSpriteSet )
			game:insert( explosion )
			explosion.x = mainCharacter.x; explosion.y = 230
			local explosionChannel = audio.play( explosionSound, { channel=2 }  )
			explosion:play()
		end

		local function showBlood()
			blood = display.newImage( "blood.png" )
			game:insert( blood )
			blood .x = mainCharacter.x + 10; blood .y = mainCharacter.y
		end
		
		local function showDeath( deathType )
			lifeBar:setSize( 0 )
			boostBar:setSize ( 0 )
			if deathType == "explosion" then
				showExplosion()
			elseif deathType == "bloody" then
				showBlood()
			end
			mainCharacter:pause()
			mainCharacter.bodyType = "static"
			local menuButton = nil
			local restartButton = nil
			
			local menuButtonPress = function( event )
				menuButton.isVisible = false
				scoreDisplay.parent:remove( scoreDisplay )
				print("Clearing All "..game.numChildren.."in Game")	
				while game.numChildren > 0	do		
						if game[1] ~= nil then
							if game[1].bodyName ~= nil then
								print("Clearing "..game[1].bodyName)
							end
							game:remove( 1 )
						end
				end
				while overlayDisplay.numChildren > 0	do	
					print("Clearing All "..overlayDisplay.numChildren.."in overlayDisplay")	
					for i=1, overlayDisplay.numChildren do
						if overlayDisplay[i] ~= nil then
							if overlayDisplay[i].bodyName ~= nil then
								print("Clearing "..overlayDisplay[i].bodyName)
							end
							overlayDisplay:remove( i )
						end
					end
				end
				game:removeSelf()
				overlayDisplay:removeSelf()
				mainContainerGroup:removeSelf()
				if restartButton ~= nil then restartButton:removeSelf() end
				physics = nil
				ui = nil
				audio.stop( backgroundMusicChannel )
				director:changeScene("screen_Menu", "moveFromLeft")
			end
						
			menuButton = ui.newButton{
				default = "buttonRed.png",
				over = "buttonRedOver.png",
				onPress = menuButtonPress,
				text = "Return To Menu",
				emboss = true,
				x = 240,
				y = 55
			}
			menuButton.isVisible = true
			menuButton.bodyName = "menuButton"
			--overlayDisplay:insert(menuButton)
			
			
			local restartButtonPress = function( event )
				
				restartButton.isVisible = false
				scoreDisplay.parent:remove( scoreDisplay )				
				
				while game.numChildren > 0	do		
					print("Clearing All "..game.numChildren.."in Game")				
					for i=1, game.numChildren do
						if game[i] ~= nil then
							if game[i].bodyName ~= nil then
								print("Clearing "..game[i].bodyName)
							end
							game:remove( i )
						end
					end
				end
				while overlayDisplay.numChildren > 0	do	
					print("Clearing All "..overlayDisplay.numChildren.."in overlayDisplay")	
					for i=1, overlayDisplay.numChildren do
						if overlayDisplay[i] ~= nil then
							if overlayDisplay[i].bodyName ~= nil then
								print("Clearing "..overlayDisplay[i].bodyName)
							end
							overlayDisplay:remove( i )
						end
					end
				end
				menuButton.isVisible = false
				restartButton.isVisible = false
				--director:changeScene("testChange", "crossFade", arguments)
				start()
			end
			
			if #totalScore == 5 then
					local lowestScoreIndex = 1
					local lowestScore = totalScore[1]
					for i=2, #totalScore do
						if lowestScore > totalScore[i] then
							lowestScoreIndex = i
							lowestScore = totalScore[i]
						end
					end
					if score > lowestScore then
						totalScore[lowestScoreIndex] = score
						print ("Replacing score "..lowestScore.." with "..score)
					end
				else
					table.insert(totalScore, score)
				end
			
			if timedModeMain and timeLeft <= 0 then
				local aggregatedScore = 0
				for i=1, #totalScore do
					aggregatedScore = aggregatedScore + totalScore[i]
					print("Score " .. i .. " = " .. totalScore[i])
				end
				local totalDisplay = ui.newLabel{
						bounds = { display.contentWidth - 320, 200 + display.screenOriginY, 100, 24 }, -- align label with right side of current screen
						text = string.format( "%i", aggregatedScore ),
						--font = "Trebuchet-BoldItalic",
						textColor = { 255, 225, 102, 255 },
						size = 32,
						align = "center"
					}
					totalDisplay.bodyName = "totalDisplay"
					overlayDisplay:insert( totalDisplay )
					score = 0
			else
				restartButton = ui.newButton{
					default = "buttonRed.png",
					over = "buttonRedOver.png",
					onPress = restartButtonPress,
					text = "Restart",
					emboss = true,
					x = 240,
					y = 195
				}
				restartButton.isVisible = true
				restartButton.bodyName = "restartButton"	
			end
		end

		local tPrevious = system.getTimer()
		local tNotMovingPrevious = system.getTimer()
		local tAdShownPrevious = system.getTimer()
		local function frameCheck( event )
			local tNotMovingDelta = (event.time - tNotMovingPrevious)
			local tDelta = (event.time - tPrevious)
			local tAddShown = (event.time - tAdShownPrevious)
			if mainCharacter.x > ( worldLength - 2 ) * 960 then
				worldFunctions.AddSection(physics, worldlength, game)
			mainCharacter:toFront();
			end
			if mainCharacter.x > score then
				score = mainCharacter.x
				scoreDisplay:setText( string.format( "%i", score ) )
			end
			if (mainCharacter.x > 100) then
				game.x = math.ceil(-mainCharacter.x) + 120
			end
			if (mainCharacter.y < 220) then
				game.y = -mainCharacter.y - math.fmod(-mainCharacter.y, 2) + 220
			end
			if mainCharacter ~= nil then
				vx, vy = mainCharacter:getLinearVelocity()
				if vx < 35 and vy < 5 and tNotMovingDelta > 100 then
					tNotMovingPrevious = event.time
					life = life - 5
					lifeBar:setSize( life )
				end
			end
			
			
			if ( game.x + sky.x ) > sky.contentWidth then
				sky:translate( -(sky.contentWidth * 2), 0)
			end
			if ( game.x + sky2.x ) > sky.contentWidth then
				sky2:translate( -(sky2.contentWidth * 2), 0)
			end
			
			if ( game.x + sky.x + sky.contentWidth) < 0 then
				sky:translate( sky.contentWidth * 2, 0)
			end
			if ( game.x + sky2.x + sky2.contentWidth) < 0 then
				sky2:translate( sky2.contentWidth * 2, 0)
			end
			
			local mskyTotal = game.x + msky.x + msky.contentWidth
			local msky2Total = game.x + msky2.x + msky2.contentWidth
			
			if ( mskyTotal < 0 or mskyTotal > msky.contentWidth * 2 or msky2Total < 0 or msky2Total > msky2.contentWidth * 2 ) and game.y > 60 then
				msky.x = sky.x
				msky2.x = sky2.x
			end			
			
			local tskyTotal = game.x + tsky.x + tsky.contentWidth
			local tsky2Total = game.x + tsky2.x + tsky2.contentWidth
					
			if ( tskyTotal < 0 or tskyTotal > tsky.contentWidth * 2 or tsky2Total < 0 or tsky2Total > tsky2.contentWidth * 2 ) and game.y > 220 then
				tsky.x = sky.x
				tsky2.x = sky2.x
			end
			
			local ttskyTotal = game.x + ttsky.x + ttsky.contentWidth
			local ttsky2Total = game.x + ttsky2.x + ttsky2.contentWidth
					
			if ( ttskyTotal < 0 or ttskyTotal > ttsky.contentWidth * 2 or ttsky2Total < 0 or ttsky2Total > ttsky2.contentWidth * 2 ) and game.y > 400 then
				ttsky.x = sky.x
				ttsky2.x = sky2.x
			end
			
			if timeLeft <=0 then
				life = 0
			end
			
			if life <= 0 then	
				print("removing event Listeners")
				Runtime:removeEventListener( "enterFrame", frameCheck )
				Runtime:removeEventListener( "enterFrame", removeLifeLava )
				Runtime:removeEventListener( "collision", onGlobalCollision )
				showDeath( "explosion" )
			end
		end
		
		local jetpackButton
		local tJetpack = system.getTimer()
		local function applyJetpackBoost( event )
			local tDelta = (event.time - tJetpack)
			if boost > 0 then
				if tDelta > 150 and mainCharacter ~= nil then	
					tJetpack = event.time
					boost = boost - 10
					boostBar:setSize( boost )
					mainCharacter:applyLinearImpulse( 10, -30, mainCharacter.x - 1, mainCharacter.y )
				end
			else
				jetpackButton.isVisible = false	
				jetpackButton:removeSelf();
				jetpackButton = display.newImage( "jetPack.png" )
				jetpackButton.x = 445; jetpackButton.y = 245
				jetpackButton.bodyName = "Jet Pack Button"
				overlayDisplay:insert(jetpackButton)
				Runtime:removeEventListener( "enterFrame", applyJetpackBoost )
				
			end
		end
			
		local function startJets()		
			Runtime:addEventListener( "enterFrame", applyJetpackBoost )
		end
		
		local function endJets()
			Runtime:removeEventListener( "enterFrame", applyJetpackBoost )
		end
		
		jetpackButton = ui.newButton{
			default = "jetPack.png",
			over = "jetPackOver.png",
			onPress = startJets,
			onRelease = endJets,
			emboss = true,
			x = 445,
			y = 245
		}
		jetpackButton.bodyName = "Jet Pack Button"
		overlayDisplay:insert(jetpackButton)
		
		local tLava = system.getTimer()
		local function removeLifeLava( event )
			local tDelta = (event.time - tLava)
			if tDelta > 250 then	
				tLavaPrevious = event.time
				life = life - 1
				lifeBar:setSize( life )
			end
		end	

		local function onTouch( event )
			local t = event.target

			local phase = event.phase
			if "began" == phase then
				-- Make target the top-most object
				local parent = t.parent
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				-- Spurious events can be sent to the target, e.g. the user presses 
				-- elsewhere on the screen and then moves the finger over the target.
				-- To prevent this, we add this flag. Only when it's true will "move"
				-- events be sent to the target.
				t.isFocus = true

				-- Store initial position
				t.x0 = event.x - t.x
				t.y0 = event.y - t.y
			elseif t.isFocus then
				if "moved" == phase then
					-- Make object move (we subtract t.x0,t.y0 so that moves are
					-- relative to initial grab point, rather than object "snapping").
					t.x = event.x - t.x0
					t.y = event.y - t.y0
				elseif "ended" == phase or "cancelled" == phase then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					slingshot:removeSelf()
					slingshotString:removeSelf()
					local swooshChannel = audio.play( swooshSound, { channel=2 }  )
					t:prepare("mainCharacterSprite")
					t:play()
					physics.addBody( t, { density=5.0, friction=0.1, bounce=0, shape=mainCharacterShape } )
					game:insert(t)
					t.bodyName = "mainCharacterDynamic"
					t.isFixedRotation = true
					--t.angularDamping = 10
					if t.x<1 then
						t.x = 1
					end
					if t.y>295 then
						t.y = 295
					end
					t:removeEventListener( "touch", onTouch )
					t:applyLinearImpulse( 2 * (170 - t.x) , 1 * (groundReferencePoint - 200 - t.y), t.x + 9, t.y)
					Runtime:addEventListener( "enterFrame", frameCheck )
				end
			end

			-- Important to return true. This tells the system that the event
			-- should not be propagated to listeners of any objects underneath.
			return true
		end

		mainCharacter:addEventListener( "touch", onTouch )

		----------------------------------------------------------
		-- Two collision types (run Corona Terminal to see output)
		----------------------------------------------------------


		-- METHOD 1: Use table listeners to make a single object report collisions between "self" and "other"

		local function onLocalCollision( self, event )
			if ( event.phase == "began" ) then
				--print( self.bodyName .. ": collision began with " .. event.other.bodyName )
				if self.bodyName == "lava" or event.other.bodyName == "lava" then
					life = life - 1
					lifeBar:setSize( life )
					Runtime:addEventListener( "enterFrame", removeLifeLava )
				elseif event.other.bodyName == "star" then
					mainCharacter:applyLinearImpulse( 0, -150, mainCharacter.x + 9, mainCharacter.y )
				elseif event.other.bodyName == "bacon" then
					if life > 74 then
						life = 100
					else
						life = life + 25
					end			
					lifeBar:setSize( life )
					mainCharacter:applyLinearImpulse( -10, -75, mainCharacter.x + 9, mainCharacter.y )
				elseif string.find( event.other.bodyName, "spikeWall" ) ~= nil then
					print("removing event Listeners")
					Runtime:removeEventListener( "enterFrame", frameCheck )
					Runtime:removeEventListener( "enterFrame", removeLifeLava )
					Runtime:removeEventListener( "collision", onGlobalCollision )
					showDeath ( "bloody" )					
				end

				elseif ( event.phase == "ended" ) then
					--print( self.bodyName .. ": collision ended with " .. event.other.bodyName )
					if self.bodyName == "lava" or event.other.bodyName == "lava" then				
						Runtime:removeEventListener( "enterFrame", removeLifeLava )
					end
				end
		end

		mainCharacter.collision = onLocalCollision
		mainCharacter:addEventListener( "collision", mainCharacter )
			

		-- METHOD 2: Use a runtime listener to globally report collisions between "object1" and "object2"
		-- Note that the order of object1 and object2 may be reported arbitrarily in any collision

		local tPrevious = system.getTimer()
		local function onGlobalCollision( event )
			if ( event.phase == "began" ) then
				--aprint( "Global report: " .. event.object1.bodyName .. " & " .. event.object2.bodyName .. " collision began" )
			elseif ( event.phase == "ended" ) then

				--print( "Global report: " .. event.object1.bodyName .. " & " .. event.object2.bodyName .. " collision ended" )

			end
			
			--print( "**** " .. event.element1 .. " -- " .. event.element2 )
			
		end

		Runtime:addEventListener( "collision", onGlobalCollision )


		-------------------------------------------------------------------------------------------
		-- New pre- and post-collision events (run Corona Terminal to see output)
		--
		-- preCollision can be quite "noisy", so you probably want to make its listeners
		-- local to the specific objects you care about, rather than a global Runtime listener
		-------------------------------------------------------------------------------------------

		local function onLocalPreCollision( self, event )
			-- This new event type fires shortly before a collision occurs, so you can use this if you want
			-- to override some collisions in your game logic. For example, you might have a platform game
			-- where the character should jump "through" a platform on the way up, but land on the platform
			-- as they fall down again.
			
			-- Note that this event is very "noisy", since it fires whenever any objects are somewhat close!

			--print( "preCollision: " .. self.bodyName .. " is about to collide with " .. event.other.bodyName )
			

		end

		local function onLocalPostCollision( self, event )
			-- This new event type fires only after a collision has been completely resolved. You can use 
			-- this to obtain the calculated forces from the collision. For example, you might want to 
			-- destroy objects on collision, but only if the collision force is greater than some amount.
			
			---[[
			if ( event.force > 20.0 ) then
				--print( "postCollision force: " .. event.force .. ", friction: " .. event.friction )
				life = life - ( string.format( "%i", event.force / 50  ) )
				lifeBar:setSize( life )
				local bounceChannel = audio.play( bounceSound, { channel=3 }  ) 
			end--]]
		end

		-- Here we assign the above two functions to local listeners within mainCharacter only, using table listeners:

		mainCharacter.postCollision = onLocalPostCollision
		mainCharacter:addEventListener( "postCollision", mainCharacter )
		
		return game
	end
	
	return start()
end