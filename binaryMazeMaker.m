function binaryMazeMaker

load ('showMaze.mat','r','c','ROW','COL','upPointer','downPointer','leftPointer', ...
    'rightPointer','ii');
% close(gcf)

gridRow = r;
gridCol = c;

% setting the dimensions of the matrix
binaryMaze = zeros((2*gridRow)+1,(2*gridCol)+1);

% Making Boundaries 
binaryMaze(1,:) = 1; % 1st row gets values of 1
binaryMaze(end,:) = 1; % last row gets values of 1
binaryMaze(3:end-1,1) = 1; % first col gets values of 1 except the 2nd element
binaryMaze(2:end-2,end) = 1; % last col gets values of 1 except the 2nd-to-last element

for ii=1:length(rightPointer)
    if rightPointer(ii)>0 % right passage blocked
          % adding 1's in the binary matrix
        binaryMaze(((2*ROW(ii))-1:(2*ROW(ii))+1),((2*COL(ii))+1)) = 1;
    end
    if downPointer(ii)>0 % down passage blocked
        
        % adding 1's in the binary matrix
        binaryMaze(((2*ROW(ii)+1)),((2*COL(ii))-1:(2*COL(ii))+1)) = 1;
        
    end  
end

%disp(binaryMaze)
save binaryMaze.mat
% close(gcf)

return

