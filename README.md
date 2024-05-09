# ProB & Atelier B Project
## Asteroids Game

By [Sam Clark](https://github.com/SamC95)

This project was coursework for my third year module: Formal Methods -- at the University of Westminster

## Contents
* [Project Brief](https://github.com/SamC95/Asteroids_BMachine/tree/main#project-brief)
* [Approach](https://github.com/SamC95/Asteroids_BMachine/tree/main#approach)
* [Technologies](https://github.com/SamC95/Asteroids_BMachine/tree/main#technologies)
* [Project Diagrams](https://github.com/SamC95/Asteroids_BMachine/tree/main#project-diagrams)
* [Implementation](https://github.com/SamC95/Asteroids_BMachine/tree/main#implementation)
* [Key Learnings](https://github.com/SamC95/Asteroids_BMachine/tree/main#key-learnings)
* [Achievements](https://github.com/SamC95/Asteroids_BMachine/tree/main#achievements)
* [Challenges](https://github.com/SamC95/Asteroids_BMachine/tree/main#challenges)
* [Conclusions](https://github.com/SamC95/Asteroids_BMachine/tree/main#conclusions)

## Project Brief
* Develop a B specification of a very simple version of the old Asteroids arcade game, using the B tools Atelier B & ProB
* The aim is to move the Spaceship from its home base through space using the various movement operations to get to the Starbase, avoiding the Asteroids.
* Space is made up of regions (squares of the grid) 12 wide by 7 high.
* The regions of space are populated by 11 asteroids, each in one region of space.
* The spaceship occupies only one square at a time which must be either an "empty space square" or the Starbase in its square.
* The spaceship is initially in its homebase, i.e. the bottom left square (1, 1).
* The spaceship can make a normal move, i.e. from one region of space (grid square) to an adjacent one, in one of four directions: Up, Down, Left and Right.
* It uses up 5 units of power when making a normal move.
* The spaceship can engage its warp-drive to "jump" to any region of space, except one occupied by an asteroid. It must not travel outside known space, i.e. outside the grid.
* It uses up 20 units of power when engaging its warp drive, no matter how far it moves.
* If the spaceship crashes into one of the asteroids it loses 10 units of power and bounces back into the square it came from.
* It cannot do a move for which it does not have the required amount of power.
* If the spaceship docks at the starbase, the game is won. If the spaceship is not docked at the spaceship and can not move due to lack of power then the game is lost. Otherwise the game is not over.
* The B specification should use the appropriate features to define the data and operations in your B machine.
* The specification must be syntactically and type correct, as checked by using the Atelier B tool.
* The specification must be animated by ProB. That is it must initialise correctly and all operations can be animated successfully and used to move the Spaceship around the regions of space.

## Approach

The goal of the project is develop the game based on the given rules in the project brief; using both Atelier B and ProB to ensure that the logic is sound and does not result in any invariant conditions being broken.

Below shows the diagram representing the 12x7 Grid with the initial start position of the spaceship at the Homebase (1, 1) and the Starbase that it needs to reach at (6, 4). The dark red dots represent the positions of the asteroids.

![image](https://github.com/SamC95/Asteroids_BMachine/assets/132593571/7666fea6-e6a2-4c98-93f3-3385be1975ea)

## Technologies

[<img src="https://prob.hhu.de/w/skins/prob/img/prob_logo.png" width="200" />](https://prob.hhu.de/w/index.php?title=Main_Page) <br/>

[<img src="https://www.atelierb.eu/wp-content/uploads/2022/10/Logo-Atelier-B.svg" width="200" />](https://www.atelierb.eu/en/)

## Project Diagrams

Below shows a structure diagram for the final Asteroid B Machine, representing all parts of the machine and the relations between them.

<img src="https://github.com/SamC95/Asteroids_BMachine/assets/132593571/33baff80-d272-4b2f-bf4e-332c66f3a75a" width="600">


## Implementation

This snippet of code represents the Warp Drive functionality, it functions by checking all the pre conditions; such as that the position to warp to is on the GRID, that the spaceship is not already on the star base and has enough power for the game to not be over.

After the pre-conditions; it checks if the spaceship has enough power to perform a warp drive, if it does then it will check if the warp drive position would contain an asteroid. If neither of these are true then it will allow the spaceship to warp to the new position and update the position and power appropriately.

```
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
```

## Key Learnings

* Gained further understanding of basic game logic.
* Learnt to utilise ProB and Atelier B to define the game logic and requirements.
* Understanding of ensuring that invariant conditions remain true during use of the program.

## Achievements

* Was able to implement the program functionality without the use of online resources like documentation, as there was very little available for the software.
* Effectively followed the project brief requirements in terms of game logic, whilst ensuring that the invariant conditions are not broken.

## Challenges

I had some difficulties effectively implementing the features as it was difficult to find any information about the language online, as such there was more trial and error than I expected when figuring out how to implement certain logic. Considering the overall short length of the program, it took more time than I expected it would.

## Conclusions

Whilst I had some challenges figuring out the approach to implementation and the syntax of the language, I managed to effectively implement all the expected functionality.

The project taught me how to more effectively implement game logic based on pre-defined rules in the project brief, even if only on a small scale.
