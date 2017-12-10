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
	
	fun next_state ((i, j, loaded), move) =
		case move of
			  "U" => (i-1, j, loaded)
			| "D" => (i+1, j, loaded)
			| "L" => (i, j-1, loaded)
			| "R" => (i, j+1, loaded)
			| "W" => (i, j, not loaded)

	fun is_possible_move ((i, j, loaded), A, move) =
		case move of
			  "U" => (i > 0 andalso Array2.sub(A, i-1, j) <> "X")
			| "D" => (Array2.nRows A - 1 > i andalso Array2.sub(A, i+1, j) <> "X")
			| "L" => (j > 0 andalso Array2.sub(A, i, j-1) <> "X")
			| "R" => (Array2.nCols A - 1 > j andalso Array2.sub(A, i, j+1) <> "X")
			| "W" => (Array2.sub(A, i, j) = "W")

	fun move_to_nextOne (nextOne, nextTwo, 0) = ()
	  | move_to_nextOne (nextOne, nextTwo, num) = 
	  (Queue.enqueue (nextOne, Queue.dequeue nextTwo);
	  	move_to_nextOne (nextOne, nextTwo, num-1))
	fun traverseOne (A, nextOne, nextTwo, prev, 0) = false
	  | traverseOne (A, nextOne, nextTwo, prev, numofone) =
		let
			val nextState = Queue.dequeue nextOne
			val delivered = (#3 nextState andalso Array2.sub(A, #1 nextState, #2 nextState) = "E")
		in
			if delivered then true else
			(if (is_possible_move (nextState, A, "U") andalso Array2.sub(prev, (#1 nextState -1 + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState) = NONE) then
				(Array2.update(prev, (#1 nextState -1 + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState, SOME (#1 nextState, #2 nextState, "U")); Queue.enqueue((if #3 nextState then nextTwo else nextOne), next_state(nextState, "U")))
			else ();

			if (is_possible_move (nextState, A, "D") andalso Array2.sub(prev, (#1 nextState +1 + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState) = NONE) then
				(Array2.update(prev, (#1 nextState +1 + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState, SOME (#1 nextState, #2 nextState, "D")); Queue.enqueue((if #3 nextState then nextTwo else nextOne), next_state(nextState, "D")))
			else ();

			if (is_possible_move (nextState, A, "L") andalso Array2.sub(prev, (#1 nextState + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState - 1) = NONE) then
				(Array2.update(prev, (#1 nextState + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState - 1, SOME (#1 nextState, #2 nextState, "L")); Queue.enqueue((if #3 nextState then nextTwo else nextOne), next_state(nextState, "L")))
			else ();

			if (is_possible_move (nextState, A, "R") andalso Array2.sub(prev, (#1 nextState + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState + 1) = NONE) then
				(Array2.update(prev, (#1 nextState + (if (#3 nextState) then 0 else (Array2.nRows A))), #2 nextState + 1, SOME (#1 nextState, #2 nextState, "R")); Queue.enqueue((if #3 nextState then nextTwo else nextOne), next_state(nextState, "R")))
			else ();

			if (is_possible_move (nextState, A, "W") andalso Array2.sub(prev, (#1 nextState + (if (not(#3 nextState)) then 0 else (Array2.nRows A))), #2 nextState) = NONE) then
				(Array2.update(prev, (#1 nextState + (if (not(#3 nextState)) then 0 else (Array2.nRows A))), #2 nextState, SOME (#1 nextState, #2 nextState, "W")); Queue.enqueue(nextOne, next_state(nextState, "W")))
			else ();

			traverseOne (A, nextOne, nextTwo, prev, numofone-1))

		end

	fun BFS (A, nextOne, nextTwo, prev, cost) =
	  let val numofone = Queue.length nextOne
	  	  val numoftwo = Queue.length nextTwo

	  in
	  	 if traverseOne (A, nextOne, nextTwo, prev, numofone) then cost
	  	 else (move_to_nextOne(nextOne, nextTwo, numoftwo);
	  	 	BFS(A, nextOne, nextTwo, prev, cost+1))
	  end

	fun previous_move (prev, loaded, move : (int*int*string), N) = Option.valOf(Array2.sub(prev, #1 move + (if (loaded) then 0 else (N)), #2 move))

	fun movesequence (starti, startj, loaded, move, sequence, prev, N) =
		let 
			val prevm = previous_move(prev, loaded, move, N)
		in
		if (starti = #1 move andalso startj = #2 move andalso loaded) then sequence
		else ( movesequence(starti, startj, (if (#3 prevm = "W") then (not loaded) else loaded), prevm, #3 prevm ^ sequence, prev, N))
		end



in
	fun spacedeli file_name =
		let
			val (A, starti, startj, endi, endj) = parse file_name
			val nextOne = Queue.mkQueue() : (int*int*bool) Queue.queue
			val nextTwo = Queue.mkQueue() : (int*int*bool) Queue.queue
	(* η μια διασταση διπλασια *)
			val prev = Array2.array(2*(Array2.nRows A), Array2.nCols A, NONE) : ((int*int*string) option) Array2.array

		in
			(Queue.enqueue(nextOne, (starti, startj, true));
			(BFS (A, nextOne, nextTwo, prev, 0), movesequence(starti, startj, true, Option.valOf(Array2.sub(prev, endi, endj)), #3 (Option.valOf(Array2.sub(prev, endi, endj))), prev, Array2.nRows A)))
		end
end