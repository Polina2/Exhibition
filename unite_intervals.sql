create or replace FUNCTION unite_intervals() 
RETURNS void as $$
DECLARE
i_id int;
i_type text;
BEGIN
for i_id, i_type IN
select DISTINCT w1.id, w1."type"
from work_interval w1, work_interval w2
where w1.id = w2.id and w1."type" = w2."type" and w1 != w2
loop
	create TABLE tmp (
    id        int  not null,
    date_from date not null, 
    date_to   date not null, 
    type      text not null,
      check ( type in ('LIGHT', 'DARK', 'OPEN_SPACE', 'NULL') ),
    check ( date_from <= date_to )
);
	insert into tmp
	select i_id, *, i_type from combine(array(SELECT
				  (date_from, date_to)::input_interval
				  from work_interval
				  where id = i_id and type = i_type));
	DELETE from work_interval
	where id = i_id and type = i_type;
	INSERT into work_interval
	select * from tmp;
	drop TABLE tmp;
end loop;
end;
$$ LANGUAGE plpgsql;