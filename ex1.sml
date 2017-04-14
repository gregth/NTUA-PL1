local

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
                 val v = n - i + 1
             in
                 scanner (i - 1) ((d, v) :: acc) n
             end
     in
         (n, rev(scanner n [] n))
     end

fun get_start (station, []) = []
  | get_start (station, ((x,n) :: xs)) =
        if x>station then (x,n) :: get_start (x, xs)
        else get_start (station, xs)

fun get_finish (station, []) = []
  | get_finish (station, ((x,n) :: xs)) =
        if x<station then (x,n) :: get_finish (x, xs)
        else get_finish (station, xs)


fun merge (nil, ys) = ys  
  | merge (xs, nil) = xs
  | merge ((x,n)::xs, (y,m)::ys) =
    if x < y then (x,n) :: merge (xs, (y,m)::ys)              
    else if n < m then (x,n) :: merge (xs, (y,m)::ys)
         else (y,m) :: merge ((x,n)::xs, ys)


fun find_max_path (best_start, best_finish, closest_station, []) = best_start - best_finish
  | find_max_path (best_start, best_finish, closest_station, (height, index) :: xs) =
        let
            val curr_len = index - closest_station
            val best_len = best_start - best_finish
        in
            if curr_len > best_len then find_max_path (index, closest_station, closest_station, xs)
            else if closest_station > index then find_max_path (best_start, best_finish, index, xs)
            else find_max_path (best_start, best_finish, closest_station, xs)
        end

in 
    fun max_path file = 
        let
            val (n, stations) = get_stations file
            val rev_head :: rev_tail = rev stations
            val start = rev_head :: get_start (#1 (rev_head), rev_tail)
            val finish = rev (hd stations :: get_finish (#1 (hd stations), tl stations))
            val (height, index) :: sorted_tail = merge (start, finish)
        in
            find_max_path (index, index, index, sorted_tail)
    end
end