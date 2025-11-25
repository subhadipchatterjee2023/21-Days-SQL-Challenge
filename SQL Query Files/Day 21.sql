/* Create a comprehensive hospital performance dashboard using CTEs. Calculate: 
1) Service-level metrics (total admissions, refusals, avg satisfaction), 
2) Staff metrics per service (total staff, avg weeks present), 
3) Patient demographics per service (avg age, count). 
Then combine all three CTEs to create a final report showing service name, 
all calculated metrics, and an overall performance score (weighted average of admission rate and satisfaction). 
Order by performance score descending. */
WITH
all_services AS (
  SELECT DISTINCT service FROM services_weekly
  UNION
  SELECT DISTINCT service FROM patients
  UNION
  SELECT DISTINCT service FROM staff
),
services_weekly_agg AS (
  SELECT
    sw.service,
    SUM(sw.patients_admitted)    AS sw_total_admitted,
    SUM(sw.patients_refused)     AS sw_total_refused,
    ROUND(AVG(sw.patient_satisfaction), 2) AS sw_avg_satisfaction,
    ROUND(AVG(sw.staff_morale), 2)         AS sw_avg_staff_morale,
    ROUND(AVG(sw.available_beds), 2)       AS sw_avg_available_beds,
    ROUND(AVG(sw.patients_request), 2)     AS sw_avg_patients_request,
    ROUND(AVG(sw.event IS NOT NULL), 2)    AS sw_event_rate  -- fraction of weeks with an event (0 or 1 per row)
  FROM services_weekly sw
  GROUP BY sw.service
),
patient_service AS (
  SELECT p.service, COUNT(*) AS total_admissions_from_patients, ROUND(AVG(p.satisfaction), 2) AS avg_satisfaction_from_patients
  FROM patients p
  GROUP BY p.service
),
staff_presence_per_staff AS (
  SELECT ss.staff_id, ss.service, SUM(CASE WHEN ss.present = 1 THEN 1 ELSE 0 END) AS weeks_present
  FROM staff_schedule ss
  GROUP BY ss.staff_id, ss.service
),
staff_metrics AS (
  SELECT
    s.service, COUNT(DISTINCT s.staff_id) AS total_staff,
    ROUND(AVG(COALESCE(sp.weeks_present,0)), 2) AS avg_weeks_present
  FROM staff s
  LEFT JOIN staff_presence_per_staff sp
    ON s.staff_id = sp.staff_id
   AND s.service  = sp.service
  GROUP BY s.service
),
patient_demo AS (
  SELECT  p.service, ROUND(AVG(p.age), 2) AS avg_age, COUNT(*) AS patient_count
  FROM patients p
  GROUP BY p.service
)
SELECT
  a.service AS service_name, COALESCE(sw.sw_total_admitted, 0) AS sw_total_admitted,
  COALESCE(sw.sw_total_refused, 0) AS sw_total_refused,
  sw.sw_avg_satisfaction AS sw_avg_satisfaction,
  sw.sw_avg_staff_morale AS sw_avg_staff_morale,
  sw.sw_avg_available_beds AS sw_avg_available_beds,
  sw.sw_avg_patients_request AS sw_avg_patients_request,
  sw.sw_event_rate AS sw_event_rate,
  COALESCE(ps.total_admissions_from_patients, 0) AS total_admissions_from_patients,
  ps.avg_satisfaction_from_patients AS avg_satisfaction_from_patients,
  COALESCE(sm.total_staff, 0) AS total_staff,
  COALESCE(sm.avg_weeks_present, 0) AS avg_weeks_present,
  COALESCE(pd.avg_age, 0) AS avg_age,
  COALESCE(pd.patient_count, 0) AS patient_count,
  ROUND(CASE WHEN NULLIF( COALESCE(sw.sw_total_admitted,0) + COALESCE(sw.sw_total_refused,0), 0) IS NULL
        THEN NULL ELSE COALESCE(sw.sw_total_admitted,0) / NULLIF( COALESCE(sw.sw_total_admitted,0) + COALESCE(sw.sw_total_refused,0), 0)END, 4) AS admission_rate,
  -- consistency metric: ratio of patient-table admissions to services_weekly admitted totals
  ROUND(CASE WHEN NULLIF(COALESCE(sw.sw_total_admitted,0), 0) IS NULL THEN NULL
      ELSE COALESCE(ps.total_admissions_from_patients,0) / NULLIF(COALESCE(sw.sw_total_admitted,0),0)
    END, 4) AS admission_coverage_ratio,
  -- performance score (weights: 60% admission_rate, 40% average satisfaction)
  ROUND(0.6 * COALESCE(CASE
        WHEN NULLIF( COALESCE(sw.sw_total_admitted,0) + COALESCE(sw.sw_total_refused,0), 0) IS NULL
          THEN 0 ELSE COALESCE(sw.sw_total_admitted,0) / NULLIF( COALESCE(sw.sw_total_admitted,0) + COALESCE(sw.sw_total_refused,0), 0) END, 0) + 0.4 * 
             (COALESCE(sw.sw_avg_satisfaction, COALESCE(ps.avg_satisfaction_from_patients,0)) / 100.0 ), 4) AS performance_score
FROM all_services a
LEFT JOIN services_weekly_agg sw ON a.service = sw.service
LEFT JOIN patient_service ps ON a.service = ps.service
LEFT JOIN staff_metrics sm ON a.service = sm.service
LEFT JOIN patient_demo pd ON a.service = pd.service
ORDER BY performance_score DESC, a.service;