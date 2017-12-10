local
	fun next_int input =
		Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
	fun initialize (a, 0) = ()
	  | initialize (a, n) =
			(Array.update(a, n-1, URef.uRef(n));
			initialize (a, n-1))
	fun scanner (stream, 0, count, id) = count
	  | scanner (stream, m, count, id) =
		let
			val i = (next_int stream - 1)
			val j = (next_int stream - 1)
			val p = Array.sub(id, i)
			val q = Array.sub(id, j)
		in
			if (URef.equal (p, q)) then (scanner (stream, m-1, count, id))
			else (URef.union (p, q); scanner (stream, m-1, count-1, id))
		end
	fun parse filename =
		let
			val stream = TextIO.openIn filename
			val n = next_int stream
			val m = next_int stream
			val k = next_int stream
			val id = Array.array(n, URef.uRef(0))
		in
			(initialize (id, n); (scanner (stream, m, n, id), k))
		end
in
	fun villages filename =
		let
			val (count, k) = parse filename
		in
			if (count < k) then 1 
			else (count - k)
		end
end
