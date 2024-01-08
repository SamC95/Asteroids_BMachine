/* AsteroidGame
 * Author: Sam Clark, w1854525
 * Creation date: 01/12/2023
 */
MACHINE AsteroidGame
    
SETS
    Direction = {MoveUp, MoveDown, MoveLeft, MoveRight};
    Status = {WON, LOST, NOT_OVER};
    MissionError = {SUCCESSFUL_MOVE, SUCCESSFUL_WARP, OUT_OF_BOUNDS, ASTEROID_HIT, ASTEROID_PRESENT, INSUFFICIENT_POWER}
    
CONSTANTS
    GRID,
    HOME_BASE,
    STAR_BASE,
    ASTEROID_POSITIONS,
    NORMAL_POWERCOST,
    WARP_POWERCOST,
    CRASH_POWERCOST,
    POWER_VALUES
    
PROPERTIES
    GRID = (1..12) * (1..7)
    &
    HOME_BASE = (1, 1)
    &
    STAR_BASE = (6, 4)
    &
    ASTEROID_POSITIONS = {(3, 2), (3, 5), (5, 4), (6, 7), (7, 1), (7, 7), (8, 3), (10, 6), (11, 2), (12, 5)}
    &
    NORMAL_POWERCOST = 5
    &
    WARP_POWERCOST = 20
    &
    CRASH_POWERCOST = 10
    &
    POWER_VALUES = {(100), (125), (150), (175), (200)}
    
VARIABLES
    SpaceshipPosition, NextPosition, Asteroids, AsteroidCollisions, PowerAmount, 
    HorizontalPosition, VerticalPosition, RouteTaken, GameActive
    
INVARIANT
    SpaceshipPosition : GRID
    & NextPosition : GRID
    & Asteroids <: ASTEROID_POSITIONS
    & AsteroidCollisions : NAT
    & PowerAmount : -5 .. 200
    & HorizontalPosition : NAT1 & HorizontalPosition <= 12
    & VerticalPosition : NAT1 & VerticalPosition <= 7 
    & RouteTaken : seq(GRID)
    & GameActive : NAT & GameActive <= 1
  
INITIALISATION
    SpaceshipPosition := HOME_BASE
    ||
    NextPosition := HOME_BASE
    ||
    Asteroids := ASTEROID_POSITIONS
    ||
    AsteroidCollisions := 0
    ||
    PowerAmount := 0
    ||
    HorizontalPosition := 1
    ||
    VerticalPosition := 1
    ||
    RouteTaken := [(1, 1)]
    ||
    GameActive := 0
    
OPERATIONS

	/*Starts a new game on first run of the program, or resets the program back to its initial state. 
	 GameActive ensures that the checks for movement, mission status and route are hidden until a 
	 new game has been started at least once

	The game will run until either the player reaches the star base (6, 4) which results in a win, or falls below
	the power required to make a normal move (5 power) resulting in a loss. If either of these scenarios occur then the normal
	and warp moves will disappear. Leaving only the MissionStatus and RegionsVisited enquiry operations and the ability to start a new game.
	 */
    NewGame(power) = 
    PRE
	power : NAT & power : POWER_VALUES
    THEN
 	HorizontalPosition := 1
 	||
	VerticalPosition := 1
	||
	SpaceshipPosition := HOME_BASE
	||
	NextPosition := HOME_BASE
	||
	RouteTaken := [(1,1)]
	||
	AsteroidCollisions := 0
	||
   	PowerAmount := power
  	||
	GameActive := 1
    END;

	/* Checks for possible outcomes of movement (i.e., asteroid hit, moving out of bounds or a valid movement)
	   and performs the appropriate action and informs the user of the outcome.
	   If player wins by landing on the star base or runs out of power to make any possible moves 
	   (less than cost of a normal move) then the normal move function will disappear. 
	*/ 
    report <-- NormalMove(dir) = 
    PRE
	dir : Direction
	& SpaceshipPosition = (HorizontalPosition, VerticalPosition)
	& SpaceshipPosition /: Asteroids
	& GameActive = 1
	& PowerAmount >= 5
	& SpaceshipPosition /= STAR_BASE
    THEN
	IF 
	dir : {MoveUp}
	THEN
	NextPosition := (HorizontalPosition, VerticalPosition + 1);
		IF
		NextPosition : Asteroids & PowerAmount >= 5
		THEN
		report := ASTEROID_HIT
		||
		PowerAmount := PowerAmount - CRASH_POWERCOST
		||
		AsteroidCollisions := AsteroidCollisions + 1

		ELSIF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		VerticalPosition = 7
		THEN
		report := OUT_OF_BOUNDS
		||
		NextPosition := (HorizontalPosition, VerticalPosition)

		ELSE
		VerticalPosition := VerticalPosition + 1
		||
		SpaceshipPosition := (HorizontalPosition, VerticalPosition + 1)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST
		||
		RouteTaken := RouteTaken ^ [(HorizontalPosition , VerticalPosition + 1)]
		||
		report := SUCCESSFUL_MOVE
		END

	ELSIF
	dir: {MoveDown} 
	THEN
	NextPosition := (HorizontalPosition, VerticalPosition - 1);
		IF
		NextPosition : Asteroids & PowerAmount >= 5
		THEN
		report := ASTEROID_HIT
		||
		PowerAmount := PowerAmount - CRASH_POWERCOST
		||
		AsteroidCollisions := AsteroidCollisions + 1

		ELSIF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		VerticalPosition = 1
		THEN
		report := OUT_OF_BOUNDS
		||
		NextPosition := (HorizontalPosition, VerticalPosition)

		ELSE
		VerticalPosition := VerticalPosition - 1
		||
		SpaceshipPosition := (HorizontalPosition, VerticalPosition - 1)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST
		||
		RouteTaken := RouteTaken ^ [(HorizontalPosition , VerticalPosition - 1)]
		||
		report := SUCCESSFUL_MOVE
		END

	ELSIF
	dir: {MoveLeft} 
	THEN	
	NextPosition := (HorizontalPosition -  1, VerticalPosition);
		IF
		NextPosition : Asteroids & PowerAmount >= 5
		THEN
		report := ASTEROID_HIT
		||
		PowerAmount := PowerAmount - CRASH_POWERCOST
		||
		AsteroidCollisions := AsteroidCollisions + 1

		ELSIF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		HorizontalPosition = 1
		THEN
		report := OUT_OF_BOUNDS
		||
		NextPosition := (HorizontalPosition, VerticalPosition)

		ELSE
		HorizontalPosition := HorizontalPosition - 1
		||
		SpaceshipPosition := (HorizontalPosition - 1, VerticalPosition)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST	
		||
		RouteTaken := RouteTaken ^ [(HorizontalPosition - 1, VerticalPosition)]
		||
		report := SUCCESSFUL_MOVE
		END
		
	ELSIF
	dir : {MoveRight}
	THEN
	NextPosition := (HorizontalPosition + 1, VerticalPosition);
		IF
		NextPosition : Asteroids & PowerAmount >= 5
		THEN
		report := ASTEROID_HIT
		||
		PowerAmount := PowerAmount - CRASH_POWERCOST
		||
		AsteroidCollisions := AsteroidCollisions + 1

		ELSIF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		HorizontalPosition = 12
		THEN
		report := OUT_OF_BOUNDS
		||
		NextPosition := (HorizontalPosition, VerticalPosition)

		ELSE
		HorizontalPosition := HorizontalPosition + 1
		||
		SpaceshipPosition := (HorizontalPosition + 1, VerticalPosition)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST
		||
		RouteTaken := RouteTaken ^ [(HorizontalPosition + 1, VerticalPosition)]
		||
		report := SUCCESSFUL_MOVE
		END	
	
	END
    END;

	/* Allows for warping to any position within the grid, as long as it doesn't have an asteroid on it, 
	uses appropriate power cost upon movement. 
	If player wins by landing on the star base or runs out of power to make any possible moves 
	(less than cost of a normal move) then the warp function will disappear. */
    report <-- WarpDrive(newposition) =
    PRE
	SpaceshipPosition = (HorizontalPosition, VerticalPosition)
	& SpaceshipPosition /: Asteroids
	& GameActive = 1
	& newposition : GRID
	& PowerAmount >= 5
	& SpaceshipPosition /= STAR_BASE
    THEN
	IF
	PowerAmount < 20
	THEN
	report := INSUFFICIENT_POWER

	ELSIF
	newposition : Asteroids 
	THEN
	report := ASTEROID_PRESENT
	||
	PowerAmount := PowerAmount - WARP_POWERCOST
	
	ELSE
	HorizontalPosition := prj1(newposition)
	||
	VerticalPosition := prj2(newposition)
	||
	SpaceshipPosition := newposition
	||
	PowerAmount := PowerAmount - WARP_POWERCOST
	||
	RouteTaken := RouteTaken ^ [newposition]
	||
	report := SUCCESSFUL_WARP
	END
    END;

	/* An enquiry operation that shows the current mission status in the order of:
	Current status of the game (Won, Lost or Not Over)
	Current levels of power remaining
	Current position on the grid (e.g., 6|->4 if the spaceship was on the star base)
	The amount of collisions with asteroids during the current game
	*/
    status, power, location, collisions <-- MissionStatus = 
    PRE
	GameActive = 1
    THEN
	IF
		SpaceshipPosition = (6, 4)
	THEN
		status := WON
		||
		location := SpaceshipPosition
		||
		power := PowerAmount
		||
		collisions := AsteroidCollisions

	ELSIF
		PowerAmount < 5
	THEN
		status := LOST
		||
		location := SpaceshipPosition
		||
		power := PowerAmount
		||
		collisions := AsteroidCollisions

	ELSE
		status := NOT_OVER	
		||
		location := SpaceshipPosition
		||
		power := PowerAmount
		||
		collisions := AsteroidCollisions
	END
      END;

	/* Enquiry operation that shows the route that the ship took in order, 
	   includes duplicates if the user returned to an already visited position */
   route <-- RegionsVisited = 
	PRE
		GameActive = 1
	THEN
		route := RouteTaken
	END
END