/* Create a trend analysis showing for each service and week: week number, patients_admitted, running total of patients admitted (cumulative), 
3-week moving average of patient satisfaction (current week and 2 prior weeks), and the difference between current week admissions and the service average. 
Filter for weeks 10-20 only. */
SELECT agg.service, agg.week, agg.patients_admitted,
  -- running total (cumulative)
  SUM(agg.patients_admitted) OVER (PARTITION BY agg.service ORDER BY agg.week
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_patients,
  -- 3-week moving average
  ROUND(AVG(agg.avg_satisfaction) OVER (PARTITION BY agg.service ORDER BY agg.week
  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_3week,
  -- difference from service average
  ROUND(agg.patients_admitted - AVG(agg.patients_admitted) OVER (PARTITION BY agg.service), 2) AS diff_from_service_avg
FROM (
    SELECT p.service, WEEK(p.arrival_date, 3) AS week, COUNT(*) AS patients_admitted, AVG(p.satisfaction) AS avg_satisfaction
    FROM patients p
    GROUP BY p.service, WEEK(p.arrival_date, 3)
) AS agg
WHERE agg.week BETWEEN 10 AND 20
ORDER BY agg.service, agg.week;