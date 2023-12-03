/* AsteroidGame
 * Author: Sam Clark
 * Creation date: 01/12/2023
 */
MACHINE AsteroidGame
    
SETS
    Direction = {MoveUp, MoveDown, MoveLeft, MoveRight};
    Status = {WON, LOST, NOT_OVER};
    MissionError = {SUCCESSFUL_MOVE, OUT_OF_BOUNDS, ASTEROID_HIT, INSUFFICIENT_POWER}
    
CONSTANTS
    GRID,
    HOME_BASE,
    STAR_BASE,
    ASTEROID_POSITIONS,
    NORMAL_POWERCOST,
    WARP_POWERCOST,
    CRASH_POWERCOST
    
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
    
VARIABLES
    SpaceshipPosition, Asteroids, AsteroidCollisions, PowerAmount, 
    HorizontalPosition, VerticalPosition, RouteTaken, RouteCounter, GameActive
    
INVARIANT
    SpaceshipPosition : GRID
    & Asteroids <: ASTEROID_POSITIONS
    & AsteroidCollisions : NAT
    & PowerAmount : NAT
    & HorizontalPosition : NAT1 & HorizontalPosition <= 12
    & VerticalPosition : NAT1 & VerticalPosition <= 7 
    & RouteTaken : seq(GRID)
    & RouteCounter : NAT1
    & GameActive : NAT & GameActive <= 1

    
INITIALISATION
    SpaceshipPosition := HOME_BASE
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
    RouteCounter := 1
    ||
    GameActive := 0
    
OPERATIONS
    NewGame(power) = 
    PRE
	power : NAT & power = 100
    THEN
 	HorizontalPosition := 1;
	VerticalPosition := 1;
	SpaceshipPosition := (HorizontalPosition, VerticalPosition);
	RouteTaken := [(1,1)];
        	PowerAmount := power;
	GameActive := 1
    END;

    report <-- NormalMove(dir) = 
    PRE
	dir : Direction
	& SpaceshipPosition = (HorizontalPosition, VerticalPosition)
	& GameActive = 1
    THEN
	IF 
	dir : {MoveUp}
	THEN
		IF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSE
		VerticalPosition := VerticalPosition + 1
		||
		SpaceshipPosition := (HorizontalPosition, VerticalPosition + 1)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST
		||
		RouteTaken := RouteTaken \/ [(HorizontalPosition , VerticalPosition + 1)]
		||
		report := SUCCESSFUL_MOVE
		END
	ELSIF
	dir: {MoveDown}
	THEN
		IF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		VerticalPosition = 1
		THEN
		report := OUT_OF_BOUNDS

		ELSE
		VerticalPosition := VerticalPosition - 1
		||
		SpaceshipPosition := (HorizontalPosition, VerticalPosition - 1)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST
		||
		RouteTaken := RouteTaken \/ [(HorizontalPosition , VerticalPosition - 1)]
		||
		report := SUCCESSFUL_MOVE
		END
	ELSIF
	dir: {MoveLeft}
	THEN	
		//IF
		//nextPos : Asteroids
		//THEN
		//report := ASTEROID_HIT

		IF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		HorizontalPosition = 1
		THEN
		report := OUT_OF_BOUNDS

		ELSE
		HorizontalPosition := HorizontalPosition - 1
		||
		SpaceshipPosition := (HorizontalPosition - 1, VerticalPosition)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST	
		||
		RouteTaken := RouteTaken \/ [(HorizontalPosition - 1, VerticalPosition)]
		||
		report := SUCCESSFUL_MOVE
		
	END
		
	ELSIF
	dir : {MoveRight}
	THEN
		IF
		PowerAmount < 5
		THEN
		report := INSUFFICIENT_POWER

		ELSIF
		HorizontalPosition = 12
		THEN
		report := OUT_OF_BOUNDS

		ELSE
		HorizontalPosition := HorizontalPosition + 1
		||
		SpaceshipPosition := (HorizontalPosition + 1, VerticalPosition)
		||
		PowerAmount := PowerAmount - NORMAL_POWERCOST
		||
		RouteTaken := RouteTaken \/ [(HorizontalPosition + 1, VerticalPosition)]
		||
		report := SUCCESSFUL_MOVE
		END	
	END
    END;

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

    END
END

