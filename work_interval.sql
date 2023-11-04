create table work_interval (
    id        int  not null,
    date_from date not null,
    date_to   date not null,
    type      text not null
      check ( type in ('LIGHT', 'DARK', 'OPEN_SPACE', 'NULL') ),
    check ( date_from <= date_to )
);