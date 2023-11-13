

--1-Which countries have never won gold medal but have won silver/bronze medals?

SELECT c.Country, SUM(m.gold) AS gold, SUM(m.silver) AS silver, SUM(m.bronze) AS bronze
FROM  [dbo].[country$] c
INNER JOIN [dbo].[Medal$] m ON c.country_noc = m.country_noc
GROUP BY c.Country
HAVING SUM(m.gold) = 0 AND (SUM(m.silver) > 0 OR SUM(m.bronze) > 0)
order by c.Country;
----------------------------------------------------------------------

--2-Egypt's participation in the Olympics and the medals won
select [edition_id],[edition],[country],[country_noc],[gold][silver],[bronze],[total]
from [dbo].[Medal$]
where [country] in ('Egypt','United Arab Republic')
order by total desc
----
--3-The maximum number of medals won by Egypt in a Olympics
select top 1 [edition_id],[edition],[country],[country_noc],[gold],[silver],[bronze],[total]
from [dbo].[Medal$]
where [country] in ('Egypt','United Arab Republic')
order by total desc
--4-The maximum number of gold medals won by Egypt in a one Olympic game
select top 1 with ties [edition_id],[edition],[country],[country_noc],[gold],[silver],[bronze],[total]
from [dbo].[Medal$]
where [country] in ('Egypt','United Arab Republic')
order by  gold desc
--5-Which year saw the highest  no of countries participating in olympics
SELECT top 1 e.[edition_id], s.[edition], COUNT(DISTINCT e.[country_noc]) AS 'number of countries'
FROM [dbo].[Edition_Details$] e
INNER JOIN [dbo].[Season$] s ON s.edition_id = e.edition_id
GROUP BY e.[edition_id], s.[edition]
ORDER BY COUNT(DISTINCT e.[country_noc]) DESC;
--6-the location of each olympic games
select edition , city from [dbo].[Season$]
--7-How many olympics games have been held?
select COUNT(distinct edition) as Total_Olympic_Games
from Season$
--8-Mention the total no of nations who participated in each olympics game?
SELECT edition AS Olympics_Game, COUNT(DISTINCT C.country_noc) AS Total_Participating_Nations
FROM Season$ M
INNER JOIN Edition_Details$ C ON M.edition_id = C.edition_id
GROUP BY edition
ORDER BY edition;
--9- Which nation has participated in all of the olympic games
SELECT country_noc
FROM Edition_Details$
GROUP BY country_noc
HAVING COUNT(DISTINCT edition_id) = (SELECT COUNT(DISTINCT edition_id) FROM Edition_Details$)
--10-List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
select edition ,country ,gold , silver ,bronze from Medal$
--11-Identify which country won the most gold, most silver and most bronze medals in each olympic games.
SELECT
    edition,
    gold_country,
    silver_country,
    bronze_country,
    MAX(gold) AS max_gold,
    MAX(silver) AS max_silver,
    MAX(bronze) AS max_bronze
FROM (
    SELECT
        edition,
        FIRST_VALUE(country) OVER (PARTITION BY edition ORDER BY gold DESC) AS gold_country,
        FIRST_VALUE(country) OVER (PARTITION BY edition ORDER BY silver DESC) AS silver_country,
        FIRST_VALUE(country) OVER (PARTITION BY edition ORDER BY bronze DESC) AS bronze_country,
        gold,
        silver,
        bronze
    FROM Medal$
) AS medal_summary
GROUP BY
    edition,
    gold_country,
    silver_country,
    bronze_country
 --12-Identify which country won the most medals overall in each olympic games.
 SELECT
    edition,
    country,
    MAX(overall) AS max_overall
FROM (
    SELECT
        edition,
        FIRST_VALUE(country) OVER (PARTITION BY edition ORDER BY (gold + silver + bronze) DESC) AS country,
        (gold + silver + bronze) AS overall
    FROM Medal$
) AS medal_summary 
GROUP BY
   edition,
   country
   order by  edition
   --13-List down total gold, silver and bronze medals won by each country.
   select  country, sum (gold) as total_gold ,sum(silver) as total_silver,sum(bronze) as total_bronze, sum( total)  as total_medal
    FROM Medal$
	group by country
	--14-Fetch the top 5 athletes who have won the most gold medals
   select top 5 a.athlete_id, a.name,count(d.medal) as gold_medals
   from Olympic_Athlete_Bio$ a inner join Edition_Details$ d 
   on a.athlete_id=d.athlete_id
   where d.medal='gold'
   group by a.athlete_id, a.name
   order by count(d.medal) desc 
   --15-
   select top 5 a.athlete_id, a.name,count(d.medal) as all_medals
   from Olympic_Athlete_Bio$ a inner join Edition_Details$ d 
   on a.athlete_id=d.athlete_id
   where d.medal !='NULL'
   group by a.athlete_id, a.name
   order by count(d.medal) desc 