level1_dialogues:
	while (stop = 0)
		
		SetSpriteVisible(98, 1)
		
		PlaySound(1, 100, 1, 0)
		
		// conversation
		for i = 41 to 55
			alpha = 0
			while (alpha < 255)
				SetTextVisible(i, 1)
				SetTextColor(i, color[i, 1], color[i, 2], color[i, 3], alpha)
				alpha = alpha + 2
				
				Sync()
			endwhile
		next i
		
		for i = 41 to 55
			SetTextVisible(i, 0)
		next i
		
		for i = 26 to 40
			SetTextVisible(i, 0)
		next i
		
		alpha = 0
		while (alpha < 255)
			SetTextVisible(87, 1)
			SetTextColor(87, 255, 255, 255, alpha)
			alpha = alpha + 2
			
			Sync()
		endwhile
		
		alpha = 255
		while (alpha > 0)
			SetTextVisible(87, 1)
			SetTextColor(87, 255, 255, 255, alpha)
			alpha = alpha - 2
			
			Sync()
		endwhile
		
		SetSpriteVisible(98, 0)
		StopSound(1)
		
		exit
		Sync()
	endwhile
return

chapter1:
	while (alpha > 0)
		SetTextVisible(21, 1)
		SetTextColor(21, 255, 255, 0, alpha)
		alpha = alpha - 2
		Sync()
	endwhile
	
	color_change = color_change + 1
	
	for i = 1 to ground
		if (mod(color_change, 100) = 0)
			SetSpriteColor(i+1, Random(0, 255), Random(0, 255), Random(0, 255), 255)
		endif
	next i
	
	gosub player_move1
	gosub button_activate
	gosub exit_level1
return

player_move1:
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
			if (GetSpriteExists(99+i) = 1)
				if (GetSpriteCollision(1, i + 99) = 1)
					gravity = 0
					exit
				else
					gravity = 1
				endif
			endif
		next i
	endif
	
	if (gravity = 1)
		SetSpritePhysicsVelocity(1, GetSpritePhysicsVelocityX(1), 500)
	else
		SetSpritePhysicsVelocity(1, GetSpritePhysicsVelocityX(1), 0)
	endif
return

button_activate:

	// push button 1
	if (GetSpriteCollision(1, 7) = 1)
		SetSpriteVisible(7, 0)
		SetSpriteVisible(11, 0) // turn off the ray
	else
		SetSpriteVisible(7, 1)
		SetSpriteVisible(11, 1) // turn on the ray
	endif
	
	for i = 1 to block
		if (GetSpriteExists(99+i) = 1)
			if (GetSpriteCollision(99+i, 7) = 1)
				SetSpriteVisible(7, 0)
				SetSpriteVisible(11, 0) // turn off the ray
				exit
			else
				SetSpriteVisible(7, 1)
				SetSpriteVisible(11, 1) // turn off the ray
			endif
		endif
	next i
	
	// push button 2
	if (GetSpriteCollision(1, 8) = 1)
		SetSpriteVisible(8, 0)
		SetSpriteVisible(10, 0) // turn off the ray
	else
		SetSpriteVisible(8, 1)
		SetSpriteVisible(10, 1) // turn on the ray
	endif
	
	for i = 1 to block
		if (GetSpriteExists(99+i) = 1)
			if (GetSpriteCollision(99+i, 8) = 1)
				SetSpriteVisible(8, 0)
				SetSpriteVisible(10, 0) // turn off the ray
				exit
			else
				SetSpriteVisible(8, 1)
				SetSpriteVisible(10, 1) // turn off the ray
			endif
		endif
	next i
	
	// push button 3
	if (GetSpriteCollision(1, 9) = 1)
		SetSpriteVisible(9, 0)
		SetSpriteVisible(6, 1) // turn on the door
	else
		SetSpriteVisible(9, 1)
		SetSpriteVisible(6, 0) // turn off the door
	endif
	
	for i = 1 to block
		if (GetSpriteExists(99+i) = 1)
			if (GetSpriteCollision(99+i, 9) = 1)
				SetSpriteVisible(9, 0)
				SetSpriteVisible(6, 1) // turn on the door
				exit
			else
				SetSpriteVisible(9, 1)
				SetSpriteVisible(6, 0) // turn off the door
			endif
		endif
	next i
return

ray_attack:
	if (GetSpriteVisible(10) = 1 and GetSpriteCollision(1, 10) = 1)
		// game over
	endif
	
	if (GetSpriteVisible(11) = 1 and GetSpriteCollision(1, 11) = 1)
		// game over
	endif
	
	for i = 1 to block //erase the block with laser light
		if (GetSpriteExists(99+i) = 1)
			if (GetSpriteCollision(10, 99+i) = 1 and GetSpriteVisible(10) = 1)
				DeleteSprite(99+i)
				press = 0
			endif
		endif
	next i
	
	for i = 1 to block //erase the block with laser light
		if (GetSpriteExists(99+i) = 1)
			if (GetSpriteCollision(11, 99+i) = 1 and GetSpriteVisible(11) = 1)
				DeleteSprite(99+i)
				press = 0
			endif
		endif
	next i
return

exit_level1:
	if (GetSpriteCollision(1, 6) = 1) // exit level
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
		SetSpritePhysicsOff(1)
		
		for i = 1 to block
			if (GetSpriteExists(99+i) = 1)
				DeleteSprite(99+i)
			endif
		next i
		
		for i = 2 to 11
			DeleteSprite(i)
		next i
		
		start = 1
		chapter = -1
		end_game = 1
	endif
return
