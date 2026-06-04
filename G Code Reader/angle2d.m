function angle = angle2d(vector2d)
    % angle of the vector form the x axis (first dimension)
    arguments
        vector2d (1,2) double
    end
    angle = atan2(vector2d(2), vector2d(1));
end