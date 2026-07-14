/*Datalemur
Data Science Skills
LinkedIn SQL Interview Question*/

SELECT candidate_Id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
    GROUP BY candidate_id
    HAVING count(skill) = 3
    ORDER BY candidate_id
    
