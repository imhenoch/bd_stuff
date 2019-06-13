-- Install multicorn
-- git clone git://github.com/Kozea/Multicorn.git
-- cd Multicorn
-- make && make install


-- CSV FDW
CREATE SERVER csv_srv foreign data wrapper multicorn options (
    wrapper 'multicorn.csvfdw.CsvFdw'
);

create foreign table csvtest (
       year numeric,
       make character varying,
       model character varying,
       length numeric
) server csv_srv options (
       filename '/home/henoch/test.csv',
       skip_header '1',
       delimiter ',');

select * from csvtest;


-- FILE SYSTEM FDW
CREATE SERVER filesystem_srv foreign data wrapper multicorn options (
    wrapper 'multicorn.fsfdw.FilesystemFdw'
);

CREATE FOREIGN TABLE musicfilesystem (
    artist  character varying,
    album   character varying,
    track   integer,
    title   character varying,
    content bytea,
    filename character varying
) server filesystem_srv options(
    root_dir    '/home/henoch/music',
    pattern     '{artist}/{album}/{track}_{title}.ogg',
    content_column 'content',
    filename_column 'filename');

SELECT count(track), artist, album from musicfilesystem group by artist, album;



-- RSS FDW
CREATE SERVER rss_srv foreign data wrapper multicorn options (
    wrapper 'multicorn.rssfdw.RssFdw'
);

CREATE FOREIGN TABLE my_rss (
    "pubDate" timestamp,
    description character varying,
    title character varying,
    link character varying
) server rss_srv options (
    url     'http://news.yahoo.com/rss/entertainment'
);

SELECT "pubDate", title, link from my_rss ORDER BY "pubDate" DESC LIMIT 10;