#include "game_over.agc"

level2_dialogues:
	while (stop = 0)
		
		SetSpriteVisible(98, 1)
		
		PlaySound(1, 100, 1, 0)
		
		// conversation
		for i = 56 to 70
			alpha = 0
			while (alpha < 255)
				SetTextVisible(i, 1)
				SetTextColor(i, color[i, 1], color[i, 2], color[i, 3], alpha)
				alpha = alpha + 2
				
				Sync()
			endwhile
		next i
		
		for i = 56 to 70
			SetTextVisible(i, 0)
		next i
		
		for i = 26 to 40
			SetTextVisible(i, 0)
		next i
		
		alpha = 0
		while (alpha < 255)
			SetTextVisible(88, 1)
			SetTextColor(88, 255, 255, 255, alpha)
			alpha = alpha + 2
			
			Sync()
		endwhile
		
		alpha = 255
		while (alpha > 0)
			SetTextVisible(88, 1)
			SetTextColor(88, 255, 255, 255, alpha)
			alpha = alpha - 2
			
			Sync()
		endwhile
		
		SetSpriteVisible(98, 0)
		StopSound(1)
		
		exit
		Sync()
	endwhile
return

chapter2:
	while stop = 0
		color_change = color_change + 1
	
		for i = 1 to ground
			if (mod(color_change, 100) = 0)
				SetSpriteColor(i+1, Random(0, 255), Random(0, 255), Random(0, 255), 255)
			endif
		next i
		
		gosub player_move21
		gosub start_debug

		Sync()
	endwhile
	
	While(alpha > 0)
		SetTextVisible(22, 1)
		SetTextColor(22, 255, 255, 0, alpha)
		
		alpha = alpha - 2
		Sync()
	endwhile
	
	gosub player_move2
	gosub enemy_move
	gosub debug_destination
	gosub level2_gameover
	gosub exit_level2
return

player_move21:  // move at the beginning
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

start_debug:
	if (GetSpriteCollision(1, 3) = 1)
		SetSpriteVisible(2, 0)
		SetSpriteVisible(3, 0)
		stop = 1
		
		SetSpritePhysicsVelocity(1, 0, 0)
		
		SetSpriteVisible(4, 1)
		SetSpriteVisible(5, 1)
		SetTextVisible(22, 1)
	endif
return

player_move2:  // player movements
	if (GetRawKeyState(65) = 1)
		SetSpritePosition(1, GetSpriteX(1) - 10, GetSpriteY(1))
	endif
	
	if (GetRawKeyState(68) = 1)
		SetSpritePosition(1, GetSpriteX(1) + 10, GetSpriteY(1))
	endif
	
	if (GetSpriteX(1) < 0)
		SetSpritePosition(1, 0, GetSpriteY(1))
	endif
	
	if (GetSpriteX(1) > GetVirtualWidth() - GetSpriteWidth(1))
		SetSpritePosition(1, GetVirtualWidth() - GetSpriteWidth(1), GetSpriteY(1))
	endif
	
	if (GetRawKeyState(87) = 1)
		SetSpritePosition(1, GetSpriteX(1), GetSpriteY(1) - 10)
	endif
	
	if (GetRawKeyState(83) = 1)
		SetSpritePosition(1, GetSpriteX(1), GetSpriteY(1) + 10)
	endif
	
	if (GetSpriteY(1) < 0)
		SetSpritePosition(1, GetSpriteX(1), 0)
	endif
	
	if (GetSpriteY(1) > GetVirtualHeight() - GetSpriteHeight(1))
		SetSpritePosition(1, GetSpriteX(1), GetVirtualHeight() - GetSpriteHeight(1))
	endif
	
	// set gravity
return

enemy_move:
	enemy_x = enemy_x + speed*direction_x
	enemy_y = enemy_y + speed*direction_y
	
	if (enemy_x < 0)
		enemy_x = 0
		direction_x = -direction_x
	endif
	
	if (enemy_x > GetVirtualWidth() - GetSpriteWidth(5))
		enemy_x = GetVirtualWidth() - GetSpriteWidth(5)
		direction_x = -direction_x
	endif 
	
	if (enemy_y < 0)
		enemy_y = 0
		direction_y = -direction_y
	endif
	
	if (enemy_y > GetVirtualHeight() - GetSpriteHeight(5))
		enemy_y = GetVirtualHeight() - GetSpriteHeight(5)
		direction_y = -direction_y
	endif 
	
	SetSpritePosition(5, enemy_x, enemy_y)
return

debug_destination:
	
	if (GetSpriteCollision(1, 4) = 1)
		SetSpritePosition(4, Random(0, GetVirtualWidth() - GetSpriteWidth(4)), Random(0, GetVirtualHeight() - GetSpriteHeight(4)))
		speed = speed + 5
		count = count + 1
	endif
	
return

level2_gameover:
	if (GetSpriteCollision(1, 5) = 1)
		direction_x = 0
		direction_y = 0
		
		SetSpriteVisible(1, 0)
		
		for i = 2 to 5
			DeleteSprite(i)
		next i
		
		for i = 1 to block
			DeleteSprite(99+i)
		next
		
		gosub game_over
	endif
return

exit_level2:
	if (count = 1) // exit level
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
		
		for i = 2 to 5
			DeleteSprite(i)
		next i
		
		for i = 1 to block
			DeleteSprite(99+i)
		next
		
		start = 1
		chapter = -1
		end_game = 1
	endif
return
