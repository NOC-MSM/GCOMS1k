function [area] = numberarea(mask,value)

%  numberarea orders isolated sub-regions of 2D array by size
%     [AREA] = NUMBERAREA(MASK,VALUE ) orders regions indicated by VALUE in 
%     the 2D array MASK from the largest to the smallest returning the 
%     result in the 2D array AREA.
%
%     In:   mask     (arr)
%           value    (scalar)
%
%     Out:  area     (arr) 
%
%     Example: 
%             [regions] = numberarea(bathy>0,1) ;
%  
%     Author: James Harle (jdha) 01-12-08
%
%     See also

% Allocate array and setup any constants

dims = size(mask) + 2 ;
area = zeros(dims) ;
mask = padarray(mask*1,[1 1],NaN,'both') ;
numb = 1 ;

% Initial sweep of mask for valid points

ind = find(mask==value) ;

% Loop to populate area with indices

while isempty(ind) ~= 1

    % Define a starting point for the population of a isolated region
    
    ind       = ind(1) ;
    area(ind) = numb ;  
    
    % Populate chosen region asigning index value
    
    while isempty(ind) ~= 1

        % Identify 4 closest points
        
        ind     = [ind+1; ind-1; ind-dims(1); ind+dims(1)] ;
        
        % Avoid duplication
        
        ind = unique(ind(mask(ind)==value & area(ind)==0) );

        area(ind) = numb ;
       
    end
 
    % Move to next isolated region
    
    numb      = numb + 1 ;
    ind       = find(mask==value & area==0) ;

end

% Adjust numb to reflect actual number of regions

numb = numb - 1 ;

% Record number of points in region
    
cover = zeros(numb,1) ;

for n = 1:numb
    
    cover(n) = sum(area(:)==n) ;
    
end

% Sort in ascending order of size 

[Y,I] = sort(cover,1,'descend') ;

for n = 1:numb
    
    area(area==I(n)) = -n ;
    
end

area = -area(2:end-1,2:end-1) ;
