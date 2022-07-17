modified_aco.m
Input: a 9x9 Sudoku puzzle in an another file in the following example format, where empty cells are represented by 0:
0,0,9,0,1,0,7,0,0
0,2,0,0,0,6,0,5,0 
4,0,0,8,0,0,0,0,9 
0,8,0,0,0,0,2,0,0 
1,0,0,0,4,0,0,0,7 
0,0,2,0,0,0,0,3,0 
5,0,0,0,0,8,0,0,3 
0,3,0,1,0,0,0,6,0 
0,0,6,0,7,0,8,0,0

output: a solved Sudoku puzzle and the time it took for the program to solve the Sudoku puzzle 


How to run modified_aco.m
1. You must have MATLAB software installed on your device
2. Copy or move modified_aco.m and the file that contains the Sudoku puzzle to the MATLAB directory
3. Open MATLAB and open modified_aco.m
4. Change line 4 of modified_aco.m to:

sudoku = readtable('filename'); 

where filename is the name of the file that contains the Sudoku puzzle to be solved.
5. To run the code, type modified_aco on the Command Window or go to the Editor tab and select Run.

NOTE: this code is written in MATLAB R2021a and was not tested on previous MATLAB versions.
