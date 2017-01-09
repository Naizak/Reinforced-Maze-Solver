function randGenMaze = myMaze(ROW,COL, uiAxis) % how to make the inputs random?
rand('state',sum(100*clock)); %#ok<RAND>

%{
    The graph entities are: 
        an id for each intersection(ID)
        the physical row of the intersection(ROW)  
        the physical column of the intersection(COL)
        membership to a connected region(state)
        and a link to adjacent intersections(upPointer,rightPointer,downPointer,leftPointer).
%}

% creating 2 matrices ROW & COL based on the r & c values given in myMaze(r,c)
[c,r]=meshgrid(1:COL,1:ROW); % creating matrices c & r

% creating the connectionMatrix that will keep track of conncetions between regions
connectionMatrix = reshape((1:ROW*COL),ROW,COL); % connectionMatrix identifies connected regions

% creating the matrix ID
ID = reshape((1:ROW*COL),ROW,COL); % ID identifies intersections of a given maze

% creating 4 zero matrices of size ID named pointer matrices
leftPointer = zeros(size(ID));
upPointer = zeros(size(ID));
rightPointer = zeros(size(ID));
downPointer = zeros(size(ID));

% giving the pointer matrices values
leftPointer(:,2:size(ID,2)) = ID(:,1:size(ID,2)-1); % shifting the ID matrix to the right by one column
upPointer(2:size(ID,1),:) = ID(1:size(ID,1)-1,:);  % shifting the ID matrix down by one row
rightPointer(:,1:size(ID,2)-1) = ID(:,2:size(ID,2));  % shifting the ID matrix to the left by one column
downPointer(1:size(ID,1)-1,:) = ID(2:size(ID,1),:); % shifting the ID matrix up by one row

%   creating the mazeMatrix that will use all the other matrices as vectors, it is a (r*c)X8 dimensional matrix  
%   mazeMatrix = [ID, ROW, COL, connectionMarix, upPointer, downPointer, leftPointer, rightPointer
mazeMatrix = cat(2,reshape(ID,ROW*COL,1),reshape(r,ROW*COL,1),reshape(c,ROW*COL,1),reshape(connectionMatrix,ROW*COL,1),...
    reshape(leftPointer,ROW*COL,1),reshape(upPointer,ROW*COL,1),reshape(rightPointer,ROW*COL,1),reshape(downPointer,ROW*COL,1)  );

mazeMatrix = sortrows(mazeMatrix);

ID=mazeMatrix(:,1);
r=mazeMatrix(:,2);
c=mazeMatrix(:,3);
connectionMatrix=mazeMatrix(:,4);
leftPointer=mazeMatrix(:,5);
upPointer=mazeMatrix(:,6);
rightPointer=mazeMatrix(:,7);
downPointer=mazeMatrix(:,8);
clear mazeMatrix;

% create a random maze
[connectionMatrix, leftPointer, upPointer, rightPointer, downPointer]=...
    makeMaze(ROW,COL,ID, r, c, connectionMatrix, leftPointer, upPointer, rightPointer, downPointer);

% show maze
%h=figure('color','white');%'KeyPressFcn',@move_spot,
showMaze(ROW, COL, r, c, leftPointer, upPointer, rightPointer, downPointer,uiAxis);

%plot(mazeGUI);
%save randGenMaze.mat;
% randGenMaze = x;
return

function [connectionMatrix, leftPointer, upPointer, rightPointer, downPointer] = makeMaze(ROW,COL,ID, r, c, connectionMatrix, leftPointer, upPointer, rightPointer, downPointer)

while max(connectionMatrix)>1 % remove walls until there is one simply connected region
    tempID=ceil(COL*ROW*rand(15,1)); % get a set of temporary ID's
    cityblock=c(tempID)+r(tempID); % get distance from the start
    is_linked=(connectionMatrix(tempID)==1); % The start state is in region 1 - see if they are linked to the start
    temp = sortrows(cat(2,tempID,cityblock,is_linked),[3,2]); % sort id's by start-link and distance
    tempID = temp(1,1); % get the id of the closest unlinked intersection
    randGen = ceil(4*rand); % random pattern

    
    %{
        after a candidate for wall removal is found, the candidate must pass two conditions. 
        1)  it is not an external wall  
        
        2)  the regions on each side of the wall were previously unconnected. If successful the
            wall is removed, the connected states are updated to the lowest of
            the two states, the pointers between the connected intersections are now negative.
    %}
    switch randGen
    case -1
        
    case 1
        if leftPointer(tempID)>0 && connectionMatrix(tempID)~=connectionMatrix(leftPointer(tempID))
            connectionMatrix( connectionMatrix==connectionMatrix(tempID) | connectionMatrix==connectionMatrix(leftPointer(tempID)) )=min([connectionMatrix(tempID),connectionMatrix(leftPointer(tempID))]);
            rightPointer(leftPointer(tempID))=-rightPointer(leftPointer(tempID));
            leftPointer(tempID)=-leftPointer(tempID);
        end
    case 2
        if rightPointer(tempID)>0 && connectionMatrix(tempID)~=connectionMatrix(rightPointer(tempID))
            connectionMatrix( connectionMatrix==connectionMatrix(tempID) | connectionMatrix==connectionMatrix(rightPointer(tempID)) )=min([connectionMatrix(tempID),connectionMatrix(rightPointer(tempID))]);
            leftPointer(rightPointer(tempID))=-leftPointer(rightPointer(tempID));
            rightPointer(tempID)=-rightPointer(tempID);
        end
    case 3
        if upPointer(tempID)>0 && connectionMatrix(tempID)~=connectionMatrix(upPointer(tempID))
            connectionMatrix( connectionMatrix==connectionMatrix(tempID) | connectionMatrix==connectionMatrix(upPointer(tempID)) )=min([connectionMatrix(tempID),connectionMatrix(upPointer(tempID))]);
            downPointer(upPointer(tempID))=-downPointer(upPointer(tempID));
            upPointer(tempID)=-upPointer(tempID);
        end
    case 4
        if downPointer(tempID)>0 && connectionMatrix(tempID)~=connectionMatrix(downPointer(tempID))
            connectionMatrix( connectionMatrix==connectionMatrix(tempID) | connectionMatrix==connectionMatrix(downPointer(tempID)) )=min([connectionMatrix(tempID),connectionMatrix(downPointer(tempID))]);
            upPointer(downPointer(tempID))=-upPointer(downPointer(tempID));
            downPointer(tempID)=-downPointer(tempID);
        end
    otherwise
        randGen;
        error('quit')
    end
    
end

save makeMaze.mat;

return

function showMaze(r, c, ROW, COL, leftPointer, upPointer, rightPointer, downPointer, uiAxis)
%clear any lines from the previous run
cla(uiAxis)

%draw borders
line(uiAxis,[.5,c+.5],[.5,.5]) % draw top border
line(uiAxis,[.5,c+.5],[r+.5,r+.5]) % draw bottom border
line(uiAxis,[.5,.5],[1.5,r+.5]) % draw left border
line(uiAxis,[c+.5,c+.5],[.5,r-.5])  % draw right border

%draw maze inners
for ii=1:length(rightPointer)
     if rightPointer(ii)>0 % right passage blocked
         line(uiAxis, [COL(ii)+.5,COL(ii)+.5],[ROW(ii)-.5,ROW(ii)+.5]);
     end
     if downPointer(ii)>0 % down passage blocked
         line(uiAxis, [COL(ii)-.5,COL(ii)+.5],[ROW(ii)+.5,ROW(ii)+.5]);
     end
end

%decrease the white space around the border
axis(uiAxis, [.5,c+.5,.5,r+.5])
save showMaze.mat;

return

