load ex3data1.mat
Y = [];
for i = 1:5000
	yk = zeros(10,1);
	num = y(i);
	if (num == 0)
		num = 10;
	endif
	yk(num) = 1;
	Y(i,:) = yk';
end

