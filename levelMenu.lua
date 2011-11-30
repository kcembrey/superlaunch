module(..., package.seeall)

function new( arguments )
	

	local self = display.newGroup()
		
	-- Back Key listener
	local function onKeyEventLevelMenu( event )
		local phase = event.phase
		local keyName = event.keyName
		
		if (phase == "up" and keyName == "back") then 
			Runtime:removeEventListener( "key", onKeyEventLevelMenu );
			timer.performWithDelay(100, moveBack("characterSelect", "moveFromLeft", {"levelMenu"}), 1)
		end
		return true
	end
	
	local levelButtonPress = function(event, localArguments)
		print ("running function"..localArguments[1])
		while self.numChildren > 0	do	
			print("Clearing All "..self.numChildren.."in self")	
			for i=1, self.numChildren do
				if self[i] ~= nil then
					self:remove( i )
				end
			end
		end
		Runtime:removeEventListener( "key", onKeyEventLevelMenu );
		director:changeScene("levelLaunch", "moveFromRight", {arguments[1], localArguments[1]})
	end
	
	---[[
	local int row = 1
	local int col = 1
	for level=1,30 do
		print( "inserting button at " .. ( col * 68 ).."-".. ( row * 54 ))
		local thisButton = ui.newButton{
				default = "levelButton.png",
				over = "levelButtonOver.png",
				onPress = levelButtonPress,
				text = level,
				emboss = true,
				x = ( col * 68 ),
				y = ( row * 58 ),
				arguments = {level}
			}
		thisButton.isVisible = true
		self:insert( thisButton )
		col = col + 1
		if level % 6 == 0 then row = row + 1; col = 1 end
    end
	--]]
	
	-- Add the back key callback
	Runtime:addEventListener( "key", onKeyEventLevelMenu );
	
	return self
end