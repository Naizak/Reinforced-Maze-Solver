function[stateCount, numberOfTimesPunished, moveStack] = randomMazeSolver()

if exist('traversedMaze.mat', 'file')
    load traversedMaze.mat;
else
    load binaryMaze.mat;
end
close(gcf)

moveStack = java.util.Stack;
decisionStack = java.util.Stack;

rowEndValue = (2*gridRow)+1;
colEndValue = (2*gridCol)+1;
x = rowEndValue-1;
y = colEndValue;
stateCount = 0;

moveStack.push([x y]);

while true
    lastMove = moveStack.peek();
    x = lastMove(1);
    y = lastMove(2);
    
    %get new coordinate to move to
    [x,y] = getCoordinates(x,y,rowEndValue,colEndValue,decisionStack,binaryMaze, moveStack);
   
    %% break at start
    if x == 2 && y == 1
        %disp(stateCount)
        numberOfTimesPunished = sum(binaryMaze(:)== -5);
        %disp(sum(binaryMaze(:)== -5))
        break;
    end
    
    %check if we need to backtrack then backtrack or move there
   firstCheck = checkIfWhereIWantToGoIsWhereIveBeen(moveStack, [x y]) == true;
    secondCheck = checkIfThingsAroundYouAreWallsOrOutOfBoundsOrPunishments([x y], rowEndValue,colEndValue, binaryMaze) == true;
    if secondCheck
        %need to backtrack
        decisionToBacktrackTo = decisionStack.pop();
        xAndYCoordinateToBacktrackTo = [decisionToBacktrackTo(1),decisionToBacktrackTo(2)];
        
        %set punishment value
        binaryMaze(x,y) = -5;
        
        while true
            %set punishment value
            binaryMaze(lastMove(1), lastMove(2)) = -5;

            lastMove = moveStack.pop();

            %if the last move is where we want to go then leave now
            if doesWhereImGoingEqualWhereIveBeen(lastMove, xAndYCoordinateToBacktrackTo)
                break;
            end
        end
    else
        moveStack.push([x y]);% the actual traversal through the maze
    end

    stateCount = stateCount+1;
%     X = sprintf('x is: %d', x);
%     Y = sprintf('y is: %d', y);
%     disp(X)
%     disp(Y)
end

traversedMaze = binaryMaze;
% disp(traversedMaze)//IF YOU WANT TO DISPLAY THE MAZE IN THE CMD WINDOW
% disp(stateCount)
% disp(numberOfTimesPunished)
save traversedMaze.mat


return

%% Begin Checks
%% Check if a given state is legal within the maze
function[upValid] = isUpSafe(x,y,rowEndValue,colEndValue)

if ~isnan(x-1) && (x-1) <= rowEndValue && ~isnan(y) && y <= colEndValue %if true
    upValid = true;
else
    upValid = false;
end
return
function[downValid] = isDownSafe(x,y,rowEndValue,colEndValue)

if ~isnan(x+1) && (x+1) <= rowEndValue && ~isnan(y) && y <= colEndValue
    downValid = true;
else
    downValid = false;
end
return
function[leftValid] = isLeftSafe(x,y,rowEndValue,colEndValue)

if ~isnan(x) && x <= rowEndValue && ~isnan(y-1) && (y-1) <= colEndValue
    leftValid = true;
else
    leftValid = false;
end
return
function[rightValid] = isRightSafe(x,y,rowEndValue,colEndValue)

if ~isnan(x) && x <= rowEndValue && ~isnan(y+1) && (y+1) <= colEndValue
    rightValid = true;
else
    rightValid = false;
end
return

%% Check if a given state is a wall
function[upWall] = isUpWall(x,y,binaryMaze)

if binaryMaze(x-1,y) == 1
    upWall = true;
else
    upWall = false;
end

return
function[downWall] = isDownWall(x,y,binaryMaze)

if binaryMaze(x+1,y) == 1
    downWall = true;
else
    downWall = false;
end

return
function[leftWall] = isLeftWall(x,y,binaryMaze)

if binaryMaze(x,y-1) == 1
    leftWall = true;
else
    leftWall = false;
end

return
function [rightWall] = isRightWall(x,y,binaryMaze)

if binaryMaze(x,y+1) == 1
    rightWall = true;
else
    rightWall = false;
end

return

%% Check if a given state has a punishment value
function[upPunishment] = isUpPunished(x,y,binaryMaze)

if binaryMaze(x-1,y) == -5
    upPunishment = true;
else
    upPunishment = false;
end

return
function[downPunishment] = isDownPunished(x,y,binaryMaze)

if binaryMaze(x+1,y) == -5
    downPunishment = true;
else
    downPunishment = false;
end

return
function[leftPunishment] = isLeftPunished(x,y,binaryMaze)

if binaryMaze(x,y-1) == -5
    leftPunishment = true;
else
    leftPunishment = false;
end

return
function[rightPunishment] = isRightPunished(x,y,binaryMaze)

if binaryMaze(x,y+1) == -5
    rightPunishment = true;
else
    rightPunishment = false;
end

return
%% End Checks

function [x,y] = Choice(nextMove)
x = nextMove(1);
y = nextMove(2);
decision = nextMove(end);
    
if  decision == 0
    x = x-1;   %up
else if decision == 1
        x = x+1; %down
    else if decision == 2
            y = y-1; %left
        else if decision == 3
            y = y+1; %right
            end
        end
    end
end


return

function[x,y] = getCoordinates(x,y,rowEndValue,colEndValue,decisionStack,binaryMaze, moveStack)

[upValid] = isUpSafe(x,y,rowEndValue,colEndValue);
[downValid] = isDownSafe(x,y,rowEndValue,colEndValue);
[leftValid] = isLeftSafe(x,y,rowEndValue,colEndValue);
[rightValid] = isRightSafe(x,y,rowEndValue,colEndValue);

if upValid == true
    [upWall] = isUpWall(x,y,binaryMaze);
end

if downValid == true
    [downWall] = isDownWall(x,y,binaryMaze);
end

if leftValid == true
    [leftWall] = isLeftWall(x,y,binaryMaze);
end

if rightValid == true
    [rightWall] = isRightWall(x,y,binaryMaze);
end

if upValid == true && upWall == false
    [upPunishment] = isUpPunished(x,y,binaryMaze);
end

if downValid == true && downWall == false
    [downPunishment] = isDownPunished(x,y,binaryMaze);
end

if leftValid == true && leftWall == false
    [leftPunishment] = isLeftPunished(x,y,binaryMaze);
end

if rightValid == true && rightWall == false
    [rightPunishment] = isRightPunished(x,y,binaryMaze);
end    

possibleDecision = [];

% if it is legal and not a wall and not a punishment
if upValid == true && upWall == false && upPunishment == false
    [nextMoveX,nextMoveY] = Choice([x y 0]); % getting the coordinates for the given state
    [secondElementA, secondElementB]  = getSecondElement(moveStack); % getting the coordinates for where I just was
    if doesWhereImGoingEqualWhereIveBeen([nextMoveX nextMoveY], [secondElementA secondElementB] ) == false % checking to see if going to that state would be backtracking
        possibleDecision = [possibleDecision 0];        
    end
end

if downValid == true && downWall == false && downPunishment == false
    [nextMoveX,nextMoveY] = Choice([x y 1]);
    [secondElementA,secondElementB]  = getSecondElement(moveStack);
    if doesWhereImGoingEqualWhereIveBeen([nextMoveX nextMoveY], [secondElementA secondElementB] ) == false
        possibleDecision = [possibleDecision 1];        
    end
end

if leftValid == true && leftWall == false && leftPunishment == false
    [nextMoveX,nextMoveY] = Choice([x y 2]);
        [secondElementA,secondElementB]  = getSecondElement(moveStack);
    if doesWhereImGoingEqualWhereIveBeen([nextMoveX nextMoveY], [secondElementA secondElementB] ) == false
        possibleDecision = [possibleDecision 2];        
    end
end

if rightValid == true && rightWall == false && rightPunishment == false
    [nextMoveX,nextMoveY] = Choice([x y 3]);
        [secondElementA,secondElementB]  = getSecondElement(moveStack);
    if doesWhereImGoingEqualWhereIveBeen([nextMoveX nextMoveY], [secondElementA secondElementB] ) == false
        possibleDecision = [possibleDecision 3];        
    end
end

%% takes the decisions and puts it into the decision stack in a random order and pops the stack.
sequenceOfOrderToAddDecisionsToStack = randperm(length(possibleDecision));

for orderNumber = sequenceOfOrderToAddDecisionsToStack
    decisionStack.push([x y possibleDecision(orderNumber)]);
end

nextMove = decisionStack.pop();
%store decision in a new stack use a count to know what choices you want
[x,y] = Choice(nextMove);
%%
return

% Will only work for stacks whose elements are vectors with 2 integers in them
function[foundAMatch] = checkIfWhereIWantToGoIsWhereIveBeen(moveStack, elementToCheckIfInStack)
iterator = moveStack.listIterator();
foundAMatch = false;

while iterator.hasNext() && ~foundAMatch% if I do have another element and I did't find a match
    foundAMatch = doesWhereImGoingEqualWhereIveBeen(iterator.next(), elementToCheckIfInStack);
end

return

% Makes sure you don't backtrack unless nessary
function[matched] = doesWhereImGoingEqualWhereIveBeen(nextMove, previousMove)
firstElementMatched = nextMove(1) == previousMove(1);
secondElementMatched = nextMove(2) == previousMove(2);
matched =  firstElementMatched && secondElementMatched;
return

function[atDeadEnd] = checkIfThingsAroundYouAreWallsOrOutOfBoundsOrPunishments(vector, rowEndValue,colEndValue,binaryMaze)
x = vector(1);
y = vector(2);

%check up
[upIsAWallOrOutOfBoundsOrIsPunished] = ~isUpSafe(x,y,rowEndValue,colEndValue) || isUpWall(x,y,binaryMaze) || isUpPunished(x,y,binaryMaze);

%check  down
[downIsAWallOrOutOfBoundsOrIsPunished] = ~isDownSafe(x,y,rowEndValue,colEndValue) || isDownWall(x,y,binaryMaze) || isDownPunished(x,y,binaryMaze);

%check left
[leftIsAWallOrOutOfBoundsOrIsPunished] = ~isLeftSafe(x,y,rowEndValue,colEndValue) || isLeftWall(x,y,binaryMaze) || isLeftPunished(x,y,binaryMaze);

%check right
[rightIsAWallOrOutOfBoundsOrIsPunished] = ~isRightSafe(x,y,rowEndValue,colEndValue) || isRightWall(x,y,binaryMaze) || isRightPunished(x,y,binaryMaze);

numberOfOutOfBoundsEntrances = 0;
%keeps track of the number of directions that are either a wall or out of bounds
if upIsAWallOrOutOfBoundsOrIsPunished
    numberOfOutOfBoundsEntrances = numberOfOutOfBoundsEntrances + 1;
end

if downIsAWallOrOutOfBoundsOrIsPunished
    numberOfOutOfBoundsEntrances = numberOfOutOfBoundsEntrances + 1;
end

if leftIsAWallOrOutOfBoundsOrIsPunished
    numberOfOutOfBoundsEntrances = numberOfOutOfBoundsEntrances + 1;
end

if rightIsAWallOrOutOfBoundsOrIsPunished
    numberOfOutOfBoundsEntrances = numberOfOutOfBoundsEntrances + 1;
end

atDeadEnd = (numberOfOutOfBoundsEntrances == 3);
return

function [mazeGUIX,mazeGUIY] = returnToGUI(x,y)
mazeGUIX = x;
mazeGUIY = y;
return

function[secondElementA,secondElementB] = getSecondElement(moveStack)
%new imp
secondElementA = 0;
secondElementB = 0;

if moveStack.empty()
    return
end

first = moveStack.pop();

if moveStack.empty()
    moveStack.push(first);
    return
end

second = moveStack.peek();
moveStack.push(first);

secondElementA = second(1);
secondElementB = second(2);


%origina imp
% copyMoveStack = java.util.Stack;
% copyMoveStack.addAll(moveStack);
% secondElementA = 0;
% secondElementB = 0;
% 
% if ~copyMoveStack.empty()
%     copyMoveStack.pop();
% 
%     if ~copyMoveStack.empty()
%         secondElement = copyMoveStack.pop();
%         secondElementA = secondElement(1);
%         secondElementB = secondElement(2);
%     end
% end
return