clear
i = imread('sample27.jpg'); % enter path to your image here
i = rgb2gray(i);
i = double(i);
[rows columns] = size(i);
%kernel = fspecial('gaussian',[rows columns],10);
%i = imfilter(i,kernel);
radius = (State_Space(i));
kernel = fspecial('gaussian',[rows columns],radius);
i_sharp = deconvlucy(i,kernel,20);
figure,imshow(i_sharp,[])
i = i_sharp;
j = 1;
count_row = 1;
count_col = 1;
check_row = 0;

while count_row<rows && check_row==0
     k = 1;
     count_col =1;
     check_col =0;
     while count_col<columns && check_col==0
        
        if count_col+40>=columns && count_row+40<rows
            block(j,k) =  mat2cell(i(count_row:count_row+40,count_col:columns)); check_col =1;
        elseif count_row+40>=rows && count_col+40<columns
            block(j,k) =  mat2cell(i(count_row:rows,count_col:count_col+40)); check_row=1;
        
        elseif count_col+40>=columns && count_row+40>=rows
            block(j,k) =  mat2cell(i(count_row:rows,count_col:columns)); check_col =1;check_row=1;
        else
            block(j,k) = mat2cell(i(count_row:count_row+40,count_col:count_col+40));
        end
        
        count_col = count_col + 40;
        k = k+1;
        
     end
     count_row = count_row +40;
     j=j+1;
end

for count=1:j-1
    for count1 = 1:k-1
        [size_x,size_y] = size(cell2mat(block(count,count1)));
        [Ix,Iy] = gradient(cell2mat(block(count,count1)));
        Ix = abs(Ix);Iy = abs(Iy);
        REM_row = sum(Ix(:))/size_y;
        REM_col = sum(Iy(:))/size_y;
        REM(count,count1) = max(REM_row,REM_col);
    end
end

thresh = graythresh(REM);

check = 0;
check1 =0;
count_row =1;
for count=1:j-1
    count_col=1;
    for count1=1:k-1
        if (REM(count,count1)>1130 && REM(count,count1)<1230) || (REM(count,count1)>1250 && REM(count,count1)<1300) || (REM(count,count1)>1360 && REM(count,count1)<1520)
            i_seg(count_row:count_row+40,count_col:count_col+40) = 255; check = check+1;
        else
            i_seg(count_row:count_row+40,count_col:count_col+40) = 0; check1 = check1+1;
        end
    count_col = count_col+40;    
    end
count_row = count_row+40;    
end

figure,imshow(i_seg,[])