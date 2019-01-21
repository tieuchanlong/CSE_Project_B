begin_story:
	while (stop = 0)
		
		SetSpriteVisible(98, 1)
		SetTextString(14, "Brain capacity: Unregistered")
		
		for i = 8 to 11
			alpha = 0
			while(alpha < 255)
				SetTextVisible(i, 1)
				SetTextColor(i, 255, 255, 255, alpha)
				
				alpha = alpha + 2
				Sync()
			endwhile
		next i
		
		for i = 8 to 11
			SetTextVisible(i, 0)
		next i
		
		
		for i = 12 to 14
			alpha = 0
			while(alpha < 255)
				SetTextVisible(i, 1)
				SetTextColor(i, 255, 255, 255, alpha)
				
				alpha = alpha + 2
				Sync()
			endwhile
		next i
		
		
		alpha = 255
		
		while (alpha > 0)
			for i = 12 to 14
				SetTextColor(i, 255, 255, 255, alpha)
			next i
			
			alpha = alpha - 2
			Sync()
		endwhile
		
		PlaySound(1, 100, 1, 0)
		
		// conversation
		for i = 26 to 40
			alpha = 0
			while (alpha < 255)
				SetTextVisible(i, 1)
				SetTextColor(i, color[i, 1], color[i, 2], color[i, 3], alpha)
				alpha = alpha + 2
				
				Sync()
			endwhile
		next i
		
		for i = 26 to 40
			SetTextVisible(i, 0)
		next i
		
		alpha = 0
		while (alpha < 255)
			SetTextVisible(86, 1)
			SetTextColor(86, 255, 255, 255, alpha)
			alpha = alpha + 2
			
			Sync()
		endwhile
		
		alpha = 255
		while (alpha > 0)
			SetTextVisible(86, 1)
			SetTextColor(86, 255, 255, 255, alpha)
			alpha = alpha - 2
			
			Sync()
		endwhile
		
		SetSpriteVisible(98, 0)
		SetTextVisible(86, 0)
		StopSound(1)
		
		exit
		Sync()
	endwhile
return


chapter0:
	
	color_change = color_change + 1
	
	for i = 1 to ground
		if (mod(color_change, 100) = 0)
			SetSpriteColor(i+1, Random(0, 255), Random(0, 255), Random(0, 255), 255)
		endif
	next i
	
	gosub player_move0
	gosub exit_level0
return


player_move0:
	
	SetSpritePhysicsVelocity(1, 0, GetSpritePhysicsVelocityY(1))
	
	if GetRawKeyState(68) = 1
		SetSpritePhysicsVelocity(1, 100, GetSpritePhysicsVelocityY(1))
	endif
	
	if GetRawKeyState(65) = 1 
		SetSpritePhysicsVelocity(1, -100, GetSpritePhysicsVelocityY(1))
	endif
	
	// ---------------- Prevent the player from getting out of the screen on the left and right ---------------- //
	if (GetSpriteX(1) < 0)
		SetSpritePosition(1, 0, GetSpriteY(1))
	endif
	
	if (GetSPriteX(1) > GetVirtualWidth() - GetSpriteWidth(1))
		SetSpritePosition(1, GetVirtualWidth() - GetSpriteWidth(1), GetSpriteY(1))
	endif
	
	// Set gravity
	gravity = 1
	for i = 1 to ground
		if (GetSpriteCollision(1, i + 1) = 1)
			gravity = 0
			exit
		else
			gravity = 1
		endif
	next i
	
	if (gravity = 1)
		for i = 1 to block
			if (GetSpriteCollision(1, i + 99) = 1)
				gravity = 0
				exit
			else
				gravity = 1
			endif
		next i
	endif
	
	if (gravity = 1)
		SetSpritePhysicsVelocity(1, GetSpritePhysicsVelocityX(1), 500)
	else
		SetSpritePhysicsVelocity(1, GetSpritePhysicsVelocityX(1), 0)
	endif

return

exit_level0:
	if GetSpriteCollision(1, 4) = 1	
		SetSpritePhysicsVelocity(1, 0, 0)
		CreateSprite(97, 99)
		SetSpriteSize(97, GetVirtualWidth(), GetVirtualHeight())
		
		alpha = 0
		while (alpha < 255)
			SetSpriteColor(97, 0, 0, 0, alpha)
			alpha = alpha + 2
			Sync()
		endwhile
		
		DeleteSprite(97)
		
		SetSpriteVisible(1, 0)
		
		for i = 1 to block
			DeleteSprite(99+i)
		next i
		
		for i = 2 to 5
			DeleteSprite(i)
		next i
		
		SetSpritePhysicsOff(1)
		
		
		start = 1
		chapter = -1
		end_game = 1
	endif
return
