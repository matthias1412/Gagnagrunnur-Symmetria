DROP VIEW IF EXISTS useful_combinations_view;
DROP TABLE IF EXISTS fund,fund_subfund, fundhistory, subfundhistory, actions, subfund, funddata;

CREATE TABLE fund (
  fund_id SERIAL PRIMARY KEY,
  fund_name TEXT NOT NULL,
  short_name TEXT NULL,
  regex_keyword TEXT NULL,
  founded TIMESTAMP NULL
);

CREATE TABLE subfund (
  subfund_id SERIAL PRIMARY KEY,
  fund_id INTEGER NOT NULL REFERENCES fund (fund_id),
  short_name TEXT NULL,
  subfund_type TEXT NULL,
  regex_keyword TEXT NULL,
  subfund_name TEXT NOT NULL,
  founded TIMESTAMP NULL
);

CREATE TABLE funddata (
  id SERIAL PRIMARY KEY,
  value NUMERIC NOT NULL,
  fund_id INTEGER NULL REFERENCES fund (fund_id),
  subfund_id INTEGER NULL REFERENCES subfund(subfund_id),
  attribute1 TEXT NOT NULL,
  attribute2 TEXT NULL,
  attribute3 TEXT NULL,
  attribute4 TEXT NULL,
  date TIMESTAMP NULL
);



CREATE TABLE actions (
  actiontype TEXT PRIMARY KEY,
  description TEXT NOT NULL
);

CREATE TABLE fundhistory (
  id SERIAL PRIMARY KEY,
  origin_id INTEGER NOT NULL REFERENCES fund (fund_id),
  destination_id INTEGER NOT NULL REFERENCES fund (fund_id),
  date TIMESTAMP NOT NULL,
  action_type TEXT NOT NULL REFERENCES actions (actiontype)
);

CREATE TABLE subfundhistory (
  id SERIAL PRIMARY KEY,
  origin_id INTEGER NOT NULL REFERENCES subfund (subfund_id),
  destination_id INTEGER NOT NULL REFERENCES subfund (subfund_id),
  date TIMESTAMP NOT NULL,
  action_type TEXT NOT NULL REFERENCES actions (actiontype)
);

SELECT * FROM fund
WHERE fund_id = 7

SELECT *
FROM subfund
WHERE subfund_id = 8;

SELECT *
FROM subfund
WHERE fund_id = 7;


SELECT * FROM subfund
WHERE
  subfund_type IS NOT NULL;




SELECT * FROM subfund

SELECT COUNT(*) FROM funddata

select * from subfund


SELECT
  f.fund_name,
  fd.date,
  fd.value,
  fd.attribute1,
  fd.attribute2,
  fd.attribute3
FROM
  fund f
JOIN
  funddata fd
ON
  f.fund_id = fd.fund_id
WHERE
  fd.attribute1 ILIKE 'Fjöldi iðgjaldagreiðenda'
  AND fd.attribute2 ILIKE 'karlar'
  AND fd.date > '2019-01-01';



SELECT
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2019 THEN fd.value ELSE NULL END) AS value_2019,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2020 THEN fd.value ELSE NULL END) AS value_2020,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2021 THEN fd.value ELSE NULL END) AS value_2021
FROM
  fund f
JOIN
  funddata fd
ON
  f.fund_id = fd.fund_id
JOIN
  subfund sf
ON
  fd.subfund_id = sf.subfund_id
WHERE
  fd.attribute1 ILIKE 'Áfallin staða'
  AND fd.date > '2019-01-01'
GROUP BY
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name;


/* ná áfallinni stöðu*/

SELECT
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2017 THEN fd.value ELSE NULL END) AS value_2017,

  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2018 THEN fd.value ELSE NULL END) AS value_2018,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2019 THEN fd.value ELSE NULL END) AS value_2019,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2020 THEN fd.value ELSE NULL END) AS value_2020,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2021 THEN fd.value ELSE NULL END) AS value_2021
FROM
  fund f
JOIN
  funddata fd
ON
  f.fund_id = fd.fund_id
LEFT JOIN
  subfund sf
ON
  fd.subfund_id = sf.subfund_id
WHERE
  fd.attribute1 ILIKE 'Áfallin staða'
  
  AND fd.date > '2017-01-01'
GROUP BY
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name;

//////////////////////////   

/*tökumm núna Rekstur -> Lífeyrir -> Samtals lífeyrir*/


SELECT
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2010 THEN fd.value ELSE NULL END) AS value_2010,

  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2011 THEN fd.value ELSE NULL END) AS value_2011,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2012 THEN fd.value ELSE NULL END) AS value_2012,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2013 THEN fd.value ELSE NULL END) AS value_2013,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2014 THEN fd.value ELSE NULL END) AS value_2014,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2015 THEN fd.value ELSE NULL END) AS value_2015,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2016 THEN fd.value ELSE NULL END) AS value_2016,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2017 THEN fd.value ELSE NULL END) AS value_2017,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2018 THEN fd.value ELSE NULL END) AS value_2018,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2019 THEN fd.value ELSE NULL END) AS value_2019,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2020 THEN fd.value ELSE NULL END) AS value_2020,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2021 THEN fd.value ELSE NULL END) AS value_2021
FROM
  fund f
JOIN
  funddata fd
ON
  f.fund_id = fd.fund_id
LEFT JOIN
  subfund sf
ON
  fd.subfund_id = sf.subfund_id
WHERE
  fd.attribute1 LIKE '%Rekstur%'
  AND fd.attribute2 LIKE '(Samtals) Hrein eign í árslok'
  AND fd.date > '2009-12-31'
GROUP BY
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name;


/////////////

-- ERU SAMTALS GÆJARNIR RÉTT UPPSETTIR QUERY (ITALICS)




SELECT
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2017 THEN fd.value ELSE NULL END) AS value_2017,

  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2018 THEN fd.value ELSE NULL END) AS value_2018,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2019 THEN fd.value ELSE NULL END) AS value_2019,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2020 THEN fd.value ELSE NULL END) AS value_2020,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2021 THEN fd.value ELSE NULL END) AS value_2021
FROM
  fund f
JOIN
  funddata fd
ON
  f.fund_id = fd.fund_id
LEFT JOIN
  subfund sf
ON
  fd.subfund_id = sf.subfund_id
WHERE
  fd.attribute1 ILIKE '$Skuldir$'
  AND fd.date > '2017-01-01'
GROUP BY
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name;




SELECT * FROM funddata WHERE fund_id = 1 AND date > '2020-01-01'

SELECT subfund.*
FROM subfund
JOIN fund ON subfund.fund_id = fund.fund_id
WHERE 'Lífeyrissjóður bankamanna' ~ fund.regex_keyword;

SELECT * FROM subfund

SELECT COUNT(*) FROM funddata

SELECT * FROM fund



-- Ná raunávöxtun fyrir alla sjóði

SELECT
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 1997 THEN fd.value ELSE NULL END) AS value_1997,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 1998 THEN fd.value ELSE NULL END) AS value_1998,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 1999 THEN fd.value ELSE NULL END) AS value_1999,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2000 THEN fd.value ELSE NULL END) AS value_2000,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2001 THEN fd.value ELSE NULL END) AS value_2001,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2002 THEN fd.value ELSE NULL END) AS value_2002,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2003 THEN fd.value ELSE NULL END) AS value_2003,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2004 THEN fd.value ELSE NULL END) AS value_2004,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2005 THEN fd.value ELSE NULL END) AS value_2005,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2006 THEN fd.value ELSE NULL END) AS value_2006,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2007 THEN fd.value ELSE NULL END) AS value_2007,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2008 THEN fd.value ELSE NULL END) AS value_2008,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2009 THEN fd.value ELSE NULL END) AS value_2009,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2010 THEN fd.value ELSE NULL END) AS value_2010,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2011 THEN fd.value ELSE NULL END) AS value_2011,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2012 THEN fd.value ELSE NULL END) AS value_2012,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2013 THEN fd.value ELSE NULL END) AS value_2013,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2014 THEN fd.value ELSE NULL END) AS value_2014,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2015 THEN fd.value ELSE NULL END) AS value_2015,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2016 THEN fd.value ELSE NULL END) AS value_2016,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2017 THEN fd.value ELSE NULL END) AS value_2017,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2018 THEN fd.value ELSE NULL END) AS value_2018,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2019 THEN fd.value ELSE NULL END) AS value_2019,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2020 THEN fd.value ELSE NULL END) AS value_2020,
  MAX(CASE WHEN EXTRACT(YEAR FROM fd.date) = 2021 THEN fd.value ELSE NULL END) AS value_2021
FROM
  fund f
JOIN
  funddata fd
ON
  f.fund_id = fd.fund_id
LEFT JOIN
  subfund sf
ON
  fd.subfund_id = sf.subfund_id
WHERE
  fd.attribute2 LIKE 'Lífeyrisbyrði'
  AND fd.date > '1995-12-31'
GROUP BY
  f.fund_id,
  f.fund_name,
  sf.subfund_id,
  sf.subfund_name;



select count(*) from funddata





SELECT subfund_name FROM subfund WHERE fund_id = 12 ORDER BY subfund_name


      SELECT
        EXTRACT(YEAR FROM fd.date) AS date,
        MAX(fd.value) AS value
      FROM
        funddata fd
      WHERE
        fd.subfund_id = 75
        AND fd.attribute1 = $2
        AND fd.attribute2 = $3
        AND fd.date > '1995-12-31'
      GROUP BY
        EXTRACT(YEAR FROM fd.date)
      ORDER BY
        date


select * from subfund



-- ná fjölda séreign og samtrygginga sjóða árið 1999

WITH subfunds_1999 AS (
  SELECT subfund_id, subfund_type
  FROM subfund
  WHERE EXISTS (
    SELECT 1
    FROM funddata
    WHERE subfund.subfund_id = funddata.subfund_id
    AND date = '1998-12-31'
  )
)
SELECT subfund_type, COUNT(*) AS num_subfunds
FROM subfunds_1999
WHERE subfund_type IN ('Samtrygging', 'Séreign')
GROUP BY subfund_type;
--
SELECT DISTINCT
  f.fund_name,
  sf.subfund_name,
  sf.subfund_type
FROM
  fund f
  JOIN subfund sf ON f.fund_id = sf.fund_id
  JOIN funddata fd ON sf.subfund_id = fd.subfund_id
WHERE
  EXTRACT(YEAR FROM fd.date) = 2014;


SELECT * FROM subfund

SELECT count(CASE WHEN fund_id IS NULL THEN 1 END) FROM funddata;

SELECT DISTINCT f.fund_name, sf.subfund_id, sf.subfund_name, sf.subfund_type
FROM fund AS f
JOIN subfund AS sf ON f.fund_id = sf.fund_id
WHERE sf.subfund_type IN ('Samtrygging', 'Séreign')
ORDER BY sf.subfund_name ASC;



--

SELECT COUNT(*)
FROM funddata
WHERE subfund_id = 165
  AND attribute1 = 'Kennitölur'
  AND attribute2 = 'Meðalraunávöxtun s.l. 5 ára (%)';


SELECT * FROM subfund

where subfund_name = "Lífeyrisauki L1"





----- VIEWIÐ
DROP VIEW IF EXISTS useful_combinations_view;
CREATE VIEW useful_combinations_view AS
SELECT
    f.fund_id,
    f.fund_name,
    sf.subfund_id,
    sf.subfund_name,
    sf.subfund_type,
    fd.attribute1,
    fd.attribute2,
    fd.attribute3,
    fd.attribute4,
    fd.value,
    to_char(fd.date, 'YYYY-MM-DD HH24:MI:SS') AS date
FROM
    funddata fd
JOIN
    fund f ON fd.fund_id = f.fund_id
JOIN
    subfund sf ON fd.subfund_id = sf.subfund_id
WHERE
    (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Iðgjöld' AND fd.attribute3 = '(Samtals) Iðgjöld')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Lífeyrir' AND fd.attribute3 = '(Samtals) Lífeyrir')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Hreinar Fjárfestingartekjur' AND fd.attribute3 = '(Samtals) Hreinar fjárfestingartekjur')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Fjárfestingartekjur' AND fd.attribute3 = '(Samtals) Fjárfestingartekjur')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Rekstrarkostnaður' AND fd.attribute3 = '(Samtals) Rekstrarkostnaður')
    OR (fd.attribute1 = 'Efnahagsreikningur' AND fd.attribute2 = '(Samtals) Hrein eign til greiðslu lífeyris')
    OR (fd.attribute1 = 'Efnahagsreikningur' AND fd.attribute2 = 'Eignir' AND fd.attribute3 = '(Samtals) Eignir samtals')
    OR (fd.attribute1 = 'Efnahagsreikningur' AND fd.attribute2 = 'Skuldir' AND fd.attribute3 = '(Samtals) Skuldir samtals')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Hrein raunávöxtun (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Ellilífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Örorkulífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Makalífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Barnalífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Annar lífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Stöðugildi')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Lífeyrisbyrði')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Fjárfestingargjöld (bein og áætluð/reiknuð)' AND fd.attribute3 = 'Hlutfall fjárfestingargjalda alls af heildareignum (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Skrifstofu og stjórnunarkostnaður (alls) í % af meðalstöðu eigna')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Örorku')
    OR (fd.attribute1 = 'Framtíðariðgjöld')
    OR (fd.attribute1 = 'Ellilífeyrir á mán (þús. kr.)' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Samtals sjóðfélagar og lífeyrisþegar')
    OR (fd.attribute1 = 'Iðgjöld ársins (þús. kr.)' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Fjöldi ellilífeyrisþega' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Óvirkir sjóðfélagar')
    OR (fd.attribute1 = 'Heildarstaða %' AND fd.attribute2 ='NaN')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Elli')
    OR (fd.attribute1 = 'Iðgjöld ársins (þús. kr.)' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Áætlaðar launagr.' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Eignir í tryggingafræðilegu mati')
    OR (fd.attribute1 = 'Heildarstaða samtals')
    OR (fd.attribute1 = 'Áætlað iðgjöld %')
    OR (fd.attribute1 = 'Framtíðarstaða %')
    OR (fd.attribute1 = 'Ellilífeyrir á mán (þús. kr.)' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Fjöldi iðgjaldagreiðenda' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Heildarskuldbindingar' AND fd.attribute2 ='NaN')
    OR (fd.attribute1 = 'Virkir sjóðfélagar')
    OR (fd.attribute1 = 'Fjöldi iðgjaldagreiðenda' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Heildareignir')
    OR (fd.attribute1 = 'Áfallnar skuldbindingar')
    OR (fd.attribute1 = 'Áfallin staða')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Barna')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Maka')
    OR (fd.attribute1 = 'Fjöldi ellilífeyrisþega' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Framtíðarskuldbinding')
    OR (fd.attribute1 = 'Áfallin staða %')
    OR (fd.attribute1 = 'Framtíðarstaða')
    OR (fd.attribute1 = 'Áætlaðar launagr.' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Samtals sjóðfélagar');
    

SELECT COUNT(*) FROM useful_combinations_view;




SELECT
    f.fund_id,
    f.fund_name,
    COUNT(fd.id) AS data_count
FROM
    fund f
JOIN
    funddata fd ON f.fund_id = fd.fund_id
GROUP BY
    f.fund_id, f.fund_name
ORDER BY
    data_count

-----------
SELECT
    f.fund_id,
    f.fund_name,
    COUNT(fd.id) AS data_count
FROM
    fund f
JOIN
    funddata fd ON f.fund_id = fd.fund_id
WHERE
    EXTRACT(YEAR FROM fd.date) = 2001
GROUP BY
    f.fund_id, f.fund_name
ORDER BY
    data_count

SELECT
    EXTRACT(YEAR FROM date) AS year,
    COUNT(id) AS data_count
FROM
    funddata
GROUP BY
    year
ORDER BY
    year;





SELECT count(*) FROM funddata
WHERE value is NULL




SELECT
    COALESCE(CAST(EXTRACT(YEAR FROM date) AS INTEGER), 'Total') AS year,
    COUNT(id) AS data_count
FROM
    funddata
GROUP BY
    ROLLUP(year)
ORDER BY
    year;



-- ná fjölda samtrygginga og séreigna allra árana

WITH RECURSIVE years(year) AS (
  SELECT 1997
  UNION ALL
  SELECT year + 1
  FROM years
  WHERE year < 2022
),
subfunds_by_year AS (
  SELECT
    y.year,
    s.subfund_id,
    s.subfund_type
  FROM
    years y
    JOIN subfund s ON EXISTS (
      SELECT 1
      FROM funddata fd
      WHERE
        s.subfund_id = fd.subfund_id
        AND fd.date = make_date(y.year, 12, 31)
    )
)
SELECT
  year,
  subfund_type,
  COUNT(*) AS num_subfunds
FROM
  subfunds_by_year
WHERE
  subfund_type IN ('Samtrygging', 'Séreign')
GROUP BY
  year, subfund_type
ORDER BY
  year, subfund_type;




SELECT *
FROM useful_combinations_view
WHERE date = '2006-12-31';






SELECT DISTINCT
  fd.attribute1,
  fd.attribute2,
  fd.attribute3,
  fd.attribute4
FROM
  funddata fd
JOIN
  subfund sf ON fd.subfund_id = sf.subfund_id
WHERE
  sf.subfund_type IS NULL;


---

SELECT *
FROM useful_combinations_view
WHERE subfund_id = 24
  AND attribute2 = 'Hrein raunávöxtun (%)'
ORDER BY date;