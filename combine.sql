create or replace function combine(input_intervals input_interval[])
returns table (start_date date, end_date date) as $$
declare
start_count integer := 0;
end_count integer := 0;
cur_time interval_time;
inp_int input_interval;
begin
	CREATE table intervals of input_interval;
	foreach inp_int in array input_intervals loop
	insert into intervals values (inp_int.from_date, inp_int.to_date);
	end loop;
	for cur_time in 
	select intervals.from_date, 1 from intervals
	union
	select intervals.to_date, 2 from intervals
	order by 1, 2
	loop
		if start_count = end_count then
			start_date := cur_time.time_value;
		end if;
		if cur_time.time_type = 1 then
			start_count := start_count + 1;
		else
			end_count := end_count + 1;
		end if;
		if start_count = end_count then
			end_date := cur_time.time_value;
			return next;
		end if;
	end loop;
	drop TABLE intervals;
end;
$$ language plpgsql;