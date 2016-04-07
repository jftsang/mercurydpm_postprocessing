% A poor man's clone of the extractfield function, which is part of the
% Mapping Toolbox, which costs money, because this is a stupid proprietary
% language

% Note - This implementation is extremely slow, e'en when parallelised (on
% my MacBook, with two CPUs).
function field = extractfield(struct_array, name) 
    shape = size(struct_array);
    struct_array = struct_array(:);
    for (i = 1:length(struct_array)) 
        field(i,:) = getfield(struct_array(i), name);
    end
%     field = reshape(field, shape);
end