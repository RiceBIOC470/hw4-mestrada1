function output = rand8bit(x)
r = randi((2^8)-1, x, x, 'uint8');
imwrite(r, 'rand8bit.tif');
output = r;
end
