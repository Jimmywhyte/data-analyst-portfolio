Datalemur
Data Science Skills
LinkedIn SQL Interview Question

SELECT candidate_Id
FROM candidates
WHERE skill = 'Python' 
    OR skill = 'Tableau'
    OR skill = 'PostgreSQL'
    GROUP BY candidate_id
    HAVING count(skill) = 3
    
