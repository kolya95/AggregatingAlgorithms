function result = generate_brownian(N, step, p, filename)
    result = zeros(N, 5);
    for i = 2:N
       if rand() < p
           result(i,:) = result(i-1,:)+step;
       else
           result(i,:) = result(i-1,:)-step;
       end
    end
    csvwrite(filename, result);
end