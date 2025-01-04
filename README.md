# Assmeblyx86_BattleShips

## Description
This project is done in the 1st year at Technical University of Cluj-Napoca, as part of Assembly Language Programming course.
<br/>
This project was entirely my own, and I continue to showcase it as part of my portfolio, as the assignment required each student to select and work on a unique topic individually.

## Usage

### Rules

This game of battleships follows the classic ruleset:
- You have to sink 5 ships of different lenghts:
  -  1 ship of length 5
  -  1 ship of lenght 4
  -  2 ships of lenght 3
  -  1 ship of lenght 2
- The goal is to click the board and sink all the ships.

This is a *single player* game. There are *no turns involved*, because the game generates randomly the ships on the playing surface.
<br>
<br>
In order to play the game you are first required to input the lenght and width of the playing area, at the start of the game ( prompted by the "m si n?" line in the terminal ).  
*Keep in mind that there are limitations regarding how big or small the playing area will be.*
<br>
<br>
After that you will be presented with the UI of the game and you are ready to play.
<br>
To replay the game you must exit and run it again.

#### - INTRODUCTIVE STORY

General! Enemy ships in sight.  
- Command how far up from water should we get
  - Input small numbers, you will be too close to the water and enemy ships. ***RESULTING IN:*** **EASY TARGET!**
  - Input large numbers, you will be too far up, the missles will miss the targets. ***RESULTING IN:*** **MISSION FAILED, YOU WILL GET IT NEXT TIME**.

## Requirements

Your system must be able to run 32bit (x86) executables.

## Contents
In this repository folder called ```\AssemblyX86_BattleShips```, you have an already compiled and ready to run game, in the file named: ```example.exe```.
<br>
In case that does not work, in the forlder asm tools you have a version of Notepad++ with the necessary plugins to compile and run the game.

## Instalation

1. Clone the repo.  
2. Run the file ```example.exe``` found in ```\AssemblyX86_BattleShips```.

## Potential issues

If the game does not start or you cannot run the .exe, you must build the game again using Notepad++.

### Building the game again
1. Head over to 
```
\\AssemblyX86_BattleShips\asm_tools\npp\Notepad++.exe
```
2. Once in Notepad++ open the file 
```example.asm```
3. On the menu bar above click
``` Plugin -> ASM Plugin -> either Run program or Build program```

### Other
Other issues that I am not aware of may require you to find the solution.

## Features to add in the future
- Replay button.
