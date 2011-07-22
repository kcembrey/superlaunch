-- tbaUI.lua (currently includes Bar Class)

-- Version 1.0

module(..., package.seeall)
--------------
-- Bar class

function newBar( params )
	local bar
	local size, lineColor
	local group
	
	if ( params.bounds ) then
		local bounds = params.bounds
		local left = bounds[1]
		local top = bounds[2]
		local width = bounds[3]
		local height = bounds[4]
	
		if ( params.size and type(params.size) == "number" ) then size=params.size else size=20 end
		if ( params.lineColor ) then lineColor=params.lineColor else lineColor={ 0, 255, 50, 255 } end
		if ( params.offset and type(params.offset) == "number" ) then offset=params.offset else offset = 0 end
		if ( params.align ) then align = params.align else align = "center" end
		
		if ( params.size ) then
			bar = display.newLine( left, top, left + size, top )
			bar.width = width
		end

		-- Public methods
		function bar:setSize( newSize )
			if ( newSize ) then
				bar:removeSelf()
				bar = display.newLine( left, top, left + newSize, top )
				bar.width = width
				if newSize > 60 then
					bar:setColor( 0, 255, 50, 255 )
				elseif newSize > 40 then
					bar:setColor( 255, 255, 0, 255 )
				elseif newSize > 20 then
					bar:setColor( 255, 165, 0, 255 )
				else
					bar:setColor( 255, 50, 0, 255 )
				end
			end
		end
		
		function bar:setColor( theColor )
			if ( theColor and type(theColor) == "table" ) then
				self:setColor( theColor[1], theColor[2], theColor[3], theColor[4] )
			end
		end
	end
	
	return bar
	-- Return instance
	
end