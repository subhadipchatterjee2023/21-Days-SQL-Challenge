/* For each service, rank the weeks by patient satisfaction score (highest first). 
Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service. */
SELECT service, week, ROUND(avg_satisfaction, 2) AS patient_satisfaction, patients_admitted,
  rk AS `rank`
FROM (
  SELECT service, week, avg_satisfaction, patients_admitted,
    ROW_NUMBER() OVER (PARTITION BY service ORDER BY avg_satisfaction DESC) AS rk
  FROM (
    SELECT p.service, WEEK(p.arrival_date, 3) AS week, AVG(p.satisfaction) AS avg_satisfaction,
    COUNT(*) AS patients_admitted
    FROM patients p
    GROUP BY p.service, WEEK(p.arrival_date, 3)
  ) AS agg
) AS ranked
WHERE rk <= 3
ORDER BY service, rk;