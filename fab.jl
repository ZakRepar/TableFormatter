#translates the current data into a 2D array
function splitter(data, writeFile)
	alignment = split(popfirst!(data), "")
    table = []
    line = []
    for index in data
        line = split(index, "&")
        push!(table, line) 
    end
    formatter(alignment, table, writeFile)
end



#prints the current table 
function formatter(align, table, writeFile)
	write(writeFile, "@")
	count = 0
	for i = 1:(totalLength(table) + length(table[1])*2 + length(table[1]) - 1)
		write(writeFile, "-")
		count += 1
	end
	write(writeFile, "@\n")
	
	for i = 1:length(table)
		for j = 1:length(table[1])
			write(writeFile, "|")
			if align[j] == "<"
				write(writeFile, " ")
				write(writeFile, table[i][j])
				for m = 1:(getLongest(table, j) - length(table[i][j]) + 1)
					write(writeFile, " ")
				end
			elseif align[j] == "="
				if getLongest(table, j) % 2 == 0 && length(table[i][j]) % 2 == 0 || getLongest(table, j) % 2 == 1 && length(table[i][j]) % 2 == 1
					for m = 1:((getLongest(table, j) - length(table[i][j])) / 2) + 1
						write(writeFile, " ")
					end
					write(writeFile, table[i][j])
					for m = 1:((getLongest(table, j) - length(table[i][j])) / 2) + 1
						write(writeFile, " ")
					end
				elseif getLongest(table, j) % 2 == 0 && length(table[i][j]) % 2 == 1 || getLongest(table, j) % 2 == 1 && length(table[i][j]) % 2 == 0
					for m = 1:((getLongest(table, j) - length(table[i][j])) / 2) + 1
						write(writeFile, " ")
					end
					write(writeFile, table[i][j])
					for m = 1:((getLongest(table, j) - length(table[i][j])) / 2) + 2
						write(writeFile, " ")
					end
				end
			else
				for m = 1:(getLongest(table, j) - length(table[i][j]) + 1)
					write(writeFile, " ")
				end
				write(writeFile, table[i][j])
				write(writeFile, " ")
			end
		end
		write(writeFile, "|\n")
		if i == 1
			write(writeFile, "|")
			for k = 1:(length(table[i]))
				if k < length(table[i])
					for l = 1:getLongest(table, k) + 2
						write(writeFile, "-")
					end
					write(writeFile, "+")
				else
					for m = 1:getLongest(table, k) + 2
						write(writeFile, "-")
					end
				end
			end
			write(writeFile, "|\n")	
		end
	end	
	write(writeFile, "@")
	for i = 1:(totalLength(table) + length(table[1])*2 + length(table[1]) - 1)
		write(writeFile, "-")
	end
	write(writeFile, "@\n")
end


#returns the longest string in a column
function getLongest(table, index)
	longest = 0
	for i = 1:(length(table))
		if length(table[i][index]) > longest
			longest = length(table[i][index])
		end
	end
	return longest
end



function totalLength(table)
	total = 0
	for i = 1:length(table[1])
		total += getLongest(table, i)
	end
	return total
end



function main()
	#reads the content of the file into an array where each index is a line of the text
	file = open(ARGS[1], "r")
	input = readlines(file)
	close(file)
	writeFile = open(ARGS[2], "w")

	#stores the input data one table at a time
	i = 1
	current = []
	while input[i] != "*"
	    push!(current, input[i])
	    i += 1
	    while !occursin(first(input[i]), ">") && !occursin(first(input[i]), "<") && !occursin(first(input[i]), "=") && !occursin(first(input[i]), "*")
			push!(current, input[i])
			i += 1
	    end
	    splitter(current, writeFile)
	    current = []
	end
	close(writeFile)
end



main()
