local
fun parse file =
	let
		(* a function to read a strings that spans till the end of line *)
		val stream1 = TextIO.openIn file
		val stream2 = TextIO.openIn file
		fun next_string stream = Option.valOf(TextIO.inputLine stream)
		fun calculate_dimensions input =
			let
				fun parse_file (stream, rowctr, colctr, str) = 
					let
						val str2 = TextIO.inputLine stream
					in
						if (str2 = NONE) then (rowctr, colctr)
						else parse_file(stream, rowctr+1, (String.size(str)-1), Option.valOf(str2))
					end
			in
				parse_file (input, 1, 0, Option.valOf(TextIO.inputLine input)) 
			end
		val (N, M) = calculate_dimensions(stream1)
		val A = Array2.array(N, M, ".")
		(* loader reads line by line and loads it into array A *)
		fun loader (0, N, M, A, starti, startj, endi, endj) = (TextIO.closeIn stream1; TextIO.closeIn stream2; (A, starti, startj, endi, endj))
		  | loader (line_counter, N, M, A, starti, startj, endi, endj) =
			let
				val line = next_string stream2
				fun upd (arr, str, row, ~1, starti, startj, endi, endj) = ( (starti, startj, endi, endj)) 
				  | upd (arr, str, row, counter, starti, startj, endi, endj) =
				  let 
					val substr = String.substring(str, counter, 1)
				  in
					(Array2.update(arr, row, counter, substr);
					if (substr = "S") then upd (arr, str, row, counter - 1, row, counter, endi, endj)
					else if(substr = "E") then upd (arr, str, row, counter - 1, starti, startj, row, counter)
						else upd (arr, str, row, counter - 1, starti, startj, endi, endj))
				  end
				val (newstarti, newstartj, newendi, newendj) = upd (A, line, N - line_counter, (String.size (line) - 2), starti, startj, endi, endj)
			in
				loader (line_counter-1, N, M, A, newstarti, newstartj, newendi, newendj)
			end
			
		(* Calculates dimensions of input stream. Returns a tuple (N, M) *)
		
	in
		loader (N, N, M, A, 0, 0, 0, 0)
						
	end
	
	fun is_possible_move ((i, j), A, move) =
		case move of
			  "U" => (i > 0 andalso Array2.sub(A, i-1, j) <> "X")
			| "D" => (Array2.nRows A - 1 > i andalso Array2.sub(A, i+1, j) <> "X")
			| "L" => (j > 0 andalso Array2.sub(A, i, j-1) <> "X")
			| "R" => (Array2.nCols A - 1 > j andalso Array2.sub(A, i, j+1) <> "X")

	fun move_to_nextOne (nextOne, nextTwo, 0) = ()
	  | move_to_nextOne (nextOne, nextTwo, num) = 
	  (Queue.enqueue (nextOne, Queue.dequeue nextTwo);
		move_to_nextOne (nextOne, nextTwo, num-1))

	fun move_to_nextTwo (nextTwo, nextThree, 0) = ()
	  | move_to_nextTwo (nextTwo, nextThree, num) =
	  (Queue.enqueue (nextTwo, Queue.dequeue nextThree);
		move_to_nextTwo (nextTwo, nextThree, num-1))
	
	fun traverseOne (A, nextOne, nextTwo, nextThree, prev, 0) = false
	  | traverseOne (A, nextOne, nextTwo, nextThree, prev, numofone) =
		let
			val (X,Y,M) = Queue.dequeue nextOne
			val delivered = (Array2.sub(A, X, Y) = "E")
		in
			(if Array2.sub(prev, X, Y) = NONE then Array2.update(prev, X, Y, SOME M) else ();
			if delivered then true else
			(if (is_possible_move ((X,Y), A, "U") andalso Array2.sub(prev, X -1, Y) = NONE) then
				(Queue.enqueue(nextThree, (X-1, Y, "U")))
			else ();

			if (is_possible_move ((X,Y), A, "D") andalso Array2.sub(prev, X + 1, Y) = NONE) then
				(Queue.enqueue(nextOne, (X+1, Y, "D")))
			else ();

			if (is_possible_move ((X,Y), A, "L") andalso Array2.sub(prev, X, Y - 1) = NONE) then
				(Queue.enqueue(nextTwo, (X, Y-1, "L")))
			else ();

			if (is_possible_move ((X,Y), A, "R") andalso Array2.sub(prev, X, Y + 1) = NONE) then
				(Queue.enqueue(nextOne, (X, Y+1, "R")))
			else ();

			traverseOne (A, nextOne, nextTwo, nextThree, prev, numofone-1))
			)

		end

	fun BFS (A, nextOne, nextTwo, nextThree, prev, cost) =
	  let val numofone = Queue.length nextOne
		  val numoftwo = Queue.length nextTwo
		  val numofthree = Queue.length nextThree

	  in
		 if traverseOne (A, nextOne, nextTwo, nextThree, prev, numofone) then cost
		 else (move_to_nextOne(nextOne, nextTwo, numoftwo);
			move_to_nextTwo(nextTwo, nextThree, numofthree);
			BFS(A, nextOne, nextTwo, nextThree, prev, cost+1))
	  end

	fun previous_position (X, Y, M) = 
		case M of
			  "U" => (X+1, Y)
			| "D" => (X-1, Y)
			| "L" => (X, Y+1)
			| "R" => (X, Y-1)


	fun movesequence (starti, startj, X, Y, M, sequence, prev) =
		let 
			val (NewX, NewY) = previous_position(X, Y, M)
			val prevm =  Option.valOf(Array2.sub(prev, NewX, NewY))
		in
		if (starti = NewX andalso startj = NewY) then sequence
		else ( movesequence(starti, startj, NewX, NewY, prevm, prevm ^ sequence, prev))
		end



in
	fun moredeli file_name =
		let
			val (A, starti, startj, endi, endj) = parse file_name
			val nextOne = Queue.mkQueue() : (int*int*string) Queue.queue
			val nextTwo = Queue.mkQueue() : (int*int*string) Queue.queue
			val nextThree = Queue.mkQueue() : (int*int*string) Queue.queue
			val prev = Array2.array((Array2.nRows A), Array2.nCols A, NONE) : ((string) option) Array2.array

		in
			(Queue.enqueue(nextOne, (starti, startj, "S"));
			(BFS (A, nextOne, nextTwo, nextThree, prev, 0), movesequence(starti, startj, endi, endj, Option.valOf(Array2.sub(prev, endi, endj)), (Option.valOf(Array2.sub(prev, endi, endj))), prev)))
		end
end        