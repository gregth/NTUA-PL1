fun get_stations file =
     let
         fun next_int input =
	     Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
         val stream = TextIO.openIn file
         val n = next_int stream
	 val _ = TextIO.inputLine stream
         fun scanner 0 acc n = acc
           | scanner i acc n =
             let
                 val d = next_int stream
                 val v = n - i
             in
                 scanner (i - 1) ((d, v) :: acc) n
             end
     in
         (n, rev(scanner n [] n))
     end

fun get_starts (station, []) = []
  | get_starts (station, ((x,n) :: xs)) =
        if x>station then (x,n) :: get_starts (x, xs)
        else get_starts (station, xs)

fun get_ends (station, []) = []
  | get_ends (station, ((x,n) :: xs)) =
        if x<station then (x,n) :: get_ends (x, xs)
        else get_ends (station, xs)


fun merge (nil, ys) = ys  
  | merge (xs, nil) = xs
  | merge ((x,n)::xs, (y,m)::ys) =
    if x > y then (x,n) :: merge (xs, (y,m)::ys)              
    else (y,m) :: merge ((x,n)::xs, ys)






