/* Create a report showing each service with: service name, total patients admitted, 
the difference between their total admissions and the average admissions across all services, and a rank indicator ('Above Average', 'Average', 'Below Average'). 
Order by total patients admitted descending. */
SELECT
  s.service,
  (SELECT COUNT(*) FROM patients p WHERE p.service = s.service) AS total_patients,
  (SELECT COUNT(*) FROM patients p WHERE p.service = s.service) - a.avg_patients AS diff_from_avg,
  CASE
    WHEN (SELECT COUNT(*) FROM patients p WHERE p.service = s.service) > a.avg_patients THEN 'Above Average'
    WHEN (SELECT COUNT(*) FROM patients p WHERE p.service = s.service) = a.avg_patients THEN 'Average'
    ELSE 'Below Average'
  END AS rank_indicator FROM
  (SELECT DISTINCT service FROM patients) s
CROSS JOIN
  (SELECT AVG(cnt) AS avg_patients
    FROM (
      SELECT COUNT(*) AS cnt
      FROM patients
      GROUP BY service) t
  ) a
ORDER BY total_patients DESC;