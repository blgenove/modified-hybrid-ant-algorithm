clear;
clc;

sudoku = readtable('puzzles/puzzle_1');
sudoku = table2array(sudoku)

global change;
change = 1;
global candidates;
candidates = zeros(9,9,9);
copy_sudoku = zeros(9,9);
copy_candidates = zeros(9,9,9);
global pheromone;
pheromone = zeros(9,9,9);
global rand_a;
global rand_b;
global candi;

for i = 1 : 9
    for j = 1 : 9
        if sudoku (i,j) == 0
            for k = 1 : 9
                candidates(i,j,k) = k;
            end
        end
    end
end

tic %start timer

[check,finished] = checker(sudoku);
while finished == 0 
    if change == 1 
        sudoku = basic(sudoku);
    elseif change == 2 
        sudoku = improved(sudoku);
    elseif change == 3
        sudoku = advanced(sudoku);
        copy_sudoku = sudoku;
        copy_candidates = candidates;
        for i = 1 : 9
            for j = 1 :9
                if sudoku(i,j) == 0
                    for k = 1 : 9
                        if candidates(i,j,k) ~= 0
                            pheromone(i,j,k) = 1; %initialize pheromone of all remaining candidates as 1
                        end
                    end
                end
            end
        end
    elseif change == 4
        [check,finished] = checker(sudoku);
        if check == 0 %if wrong assignment
            sudoku = copy_sudoku;
            candidates = copy_candidates;
            pheromone(rand_a,rand_b,candi) = pheromone(rand_a,rand_b,candi) - 0.1;
        end
        sudoku = aco(sudoku);
    end
    [check,finished] = checker(sudoku);
end

time = toc
sudoku


%basic assignment step
function sudoku = basic(sudoku)
    global change;
    change = 0;
    global candidates
    
    for i = 1 : 9
        for j = 1 : 9
            if sudoku(i,j) == 0 
                %for checking row - horizontal
                for y = 1 : 9
                    if sudoku(i,y) ~= 0
                        candidates(i,j,sudoku(i,y)) = 0;
                    end
                end
                
                %for checking column - vertical
                for x = 1 : 9
                    if sudoku(x,j) ~= 0
                        candidates(i,j,sudoku(x,j)) = 0;
                    end
                end
                
                %for checking subgroup (new)
                row = i - mod((i-1),3);
                col = j - mod((j-1),3);
                
                for x = 0 : 2
                    for y = 0 : 2
                        if sudoku((row+x),(col+y)) ~= 0
                            candidates(i,j,sudoku((row+x),(col+y))) = 0;
                        end
                    end
                end
                
                count = 0;
                for k = 1 : 9
                    if candidates(i,j,k) ~=0
                        count = count + 1;
                    end
                end
                
                if count == 1
                    for k = 1 : 9
                        if candidates(i,j,k) ~= 0
                            sudoku(i,j) = k;
                            change = 1;
                            break;
                        end
                    end
                end
            else
                for k = 1 : 9
                    candidates(i,j,k) = 0;
                end
            end
        end
    end
    
    if change == 0
        change = 2; 
    end
    
end %end basic assignment step function

%improved assignment step
function sudoku = improved(sudoku)
    global candidates;
    global change;
    
    for i = 1 : 9
        for j = 1 : 9
            if sudoku(i,j) == 0
                for k = 1: 9
                    if candidates(i,j,k) ~= 0
                        %check row
                        for y = 1 : 9 
                            flag = 0;
                            if candidates(i,y,k) == k && y ~= j
                                flag = 1;
                                break;
                            end
                        end
                        
                        if flag == 0
                            sudoku(i,j) = k;
                            change = 1;
                            break;
                        end
                        
                        %check column
                        for x = 1 : 9 
                            flag = 0;
                            if candidates(x,j,k) == k && x ~= i
                                flag = 1;
                                break;
                            end
                        end
                        
                        if flag == 0
                            sudoku(i,j) = k;
                            change = 1;
                            break;
                        end
                        
                        %check subgroup
                        row = i - mod((i-1),3);
                        col = j - mod((j-1),3);
                
                        for x = 0 : 2
                            for y = 0 : 2
                                if candidates((row+x),(col+y),k) ~= 0 && x ~= 0 && y ~= 0
                                    flag = 1;
                                    break;
                                end
                            end
                        end
                        
                        
                        if flag == 0
                            sudoku(i,j) = k;
                            change = 1;
                            break;
                        end
                        
                    end
                end
            end
        end
    end
    
    if change == 2
        change = 3; 
    end
    
end %end improved assignment step

%advanced assignment step
function sudoku = advanced(sudoku)
    global candidates;
    global change;
    change = 4;
    
    for i = 1 : 9
        for j = 1 : 9
            if sudoku(i,j) == 0
                twin = zeros(1,2);
                twin2 = zeros(1,2);
                a = zeros(2);
                b = zeros(2);
                
                ctr = 1; 
                for k = 1 : 9
                    if candidates(i,j,k) ~= 0
                        if ctr > 2
                            ctr = 1;
                            twin = zeros(1,2);
                            a(1) = 0;
                            b(1) = 0;
                            break;
                        else
                            a(1) = i;
                            b(1) = j;
                            twin(1,ctr) = k;
                            ctr = ctr + 1;
                        end
                    end
                end

                ctr2 = 1;
                %checking row
                if ctr == 3 && j < 9
                    for y = j+1 : 9
                        if sudoku(i,y) == 0
                            for k = 1 : 9
                                if candidates(i,y,k) ~= 0
                                    if ctr2 > 2
                                        ctr2 = 1;
                                        twin2 = zeros(1,2);
                                        a(2) = 0;
                                        b(2) = 0;
                                        break;
                                    else
                                        a(2) = i;
                                        b(2) = y;
                                        twin2(1,ctr2) = k;
                                        ctr2 = ctr2 + 1;
                                    end
                                end
                            end
                            if isequal(twin,twin2)
                                break;
                            end
                        end
                    end
                end
                
                if twin(1,1) == twin2(1,1) && twin(1,2) == twin2(1,2) && twin(1,1) ~= 0
                    for y = 1 : 9 %remove the candidates from the same row
                        if sudoku(i,y) == 0 && y ~= b(1) && y ~= b(2)
                            if candidates(i,y,twin(1,1)) ~= 0 || candidates(i,y,twin(1,2)) ~= 0
                                candidates(i,y,twin(1,1)) = 0;
                                candidates(i,y,twin(1,2)) = 0;
                                change = 3;
                            end
                        end
                    end
                end
                                
                ctr2 = 1;
                %checking column
                if ctr == 3 && i < 9
                    for x = i+1 : 9
                        if sudoku(x,j) == 0
                            for k = 1 : 9
                                if candidates(x,j,k) ~= 0
                                    if ctr2 > 2
                                        ctr2 = 1;
                                        twin2 = zeros(1,2);
                                        a(2) = 0;
                                        b(2) = 0;
                                        break;
                                    else
                                        a(2) = x;
                                        b(2) = j;
                                        twin2(1,ctr2) = k;
                                        ctr2 = ctr2 + 1;
                                    end
                                end
                            end
                            if isequal(twin,twin2)
                                break;
                            end
                        end
                    end
                end
                
               
                if twin(1,1) == twin2(1,1) && twin(1,2) == twin2(1,2) && twin(1,1) ~= 0
                    for x = 1 : 9 %remove the candidates from the same column
                        if sudoku(x,j) == 0 && x ~= a(1) && x ~= a(2) 
                            if candidates(x,j,twin(1,1)) ~= 0 || candidates(x,j,twin(1,2)) ~= 0
                                candidates(x,j,twin(1,1)) = 0;
                                candidates(x,j,twin(1,2)) = 0;
                                change = 3;
                            end
                        end
                    end
                end

                
            end
        end
    end
    
    
end %end advanced assignment step

%ACO step
function sudoku = aco(sudoku)
    global change;
    global pheromone;
    global rand_a;
    global rand_b;
    empty_a = zeros(1,81);
    empty_b = zeros(1,81);
    rand_candi = zeros(1,9); 
    global candi; 
    ctr = 1;
    
    for i = 1 : 9
        for j = 1 : 9
           if sudoku(i,j) == 0 
               empty_a(ctr) = i;
               empty_b(ctr) = j;
               ctr = ctr + 1;
           end
        end
    end
    
    rand_cell = randi([1, ctr-1]); 
    
    rand_a = empty_a(rand_cell);
    rand_b = empty_b(rand_cell);
    
    ctr = 1;
    for k = 1 : 9
        if pheromone(rand_a, rand_b, k) == max(pheromone(rand_a, rand_b, :))
            rand_candi(1,ctr) = k;
            ctr = ctr + 1;
        end
    end
    
    candi = rand_candi(1,randi([1, ctr-1])); %randomly choose candidate based on high pheromone;
    sudoku(rand_a, rand_b) = candi;
    sudoku = basic(sudoku);
    
    if change == 1
        while change == 1
            sudoku = basic(sudoku);
        end
    end
    
    change = 4;
    
end

function [check,finished] = checker(sudoku)
    global candidates;
    check = 1; %1 = right, 0 = wrong
    finished = 1; %1 = finished, 0 = not finished
    count = 0;
    
    for i = 1 : 9
        for j = 1 : 9
            if sudoku(i,j) == 0
                finished = 0;
                count = 0;
                for k = 1 : 9
                    if candidates(i,j,k) == 0
                        count = count + 1;
                    end
                end
            end
            
            if count == 9
                check = 0;
                break;
            end
            
        end
        
        if check == 0
            break;
        end
        
    end
    
end %end check fnc


