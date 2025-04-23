-- You work as a data analyst for a FAANG company that tracks employee salaries over time. The company wants to understand how the average salary in each department compares to the company's overall average salary each month.

-- Write a query to compare the average salary of employees in each department to the company's average salary for March 2024. Return the comparison result as 'higher', 'lower', or 'same' for each department. Display the department ID, payment month (in MM-YYYY format), and the comparison result.

-- employee Schema:
-- column_name	type	description
-- employee_id	integer	The unique ID of the employee.
-- name	string	The full name of the employee.
-- salary	integer	The salary of the employee.
-- department_id	integer	The department ID of the employee.
-- manager_id	integer	The manager ID of the employee.
-- employee Example Input:
-- employee_id	name	salary	department_id	manager_id
-- 1	Emma Thompson	3800	1	6
-- 2	Daniel Rodriguez	2230	1	7
-- 3	Olivia Smith	7000	1	8
-- 5	Sophia Martinez	1750	1	11
-- salary Schema:
-- column_name	type	description
-- salary_id	integer	A unique ID for each salary record.
-- employee_id	integer	The unique ID of the employee.
-- amount	integer	The salary of the employee.
-- payment_date	datetime	The date and time when the salary was paid to the employee.
-- salary Example Input:
-- salary_id	employee_id	amount	payment_date
-- 1	1	3800	01/31/2024 00:00:00
-- 2	2	2230	01/31/2024 00:00:00
-- 3	3	7000	01/31/2024 00:00:00
-- 4	4	6800	01/31/2024 00:00:00
-- 5	5	1750	01/31/2024 00:00:00

-- The main idea of this is to compute the avg salary of the company and department in separate ctes, then join them on company date as the question asks specially for salary in a particular month
with department_avg as (

select avg(e.salary) as dep_avg, e.department_id, s.payment_date
from employee e
join salary s
on e.employee_id = s.employee_id
where payment_date = '03/31/2024  00:00:00'
group by e.department_id, s.payment_date
),

company_avg as (
select 
payment_date,
avg(amount) as com_avg
from salary
WHERE payment_date = '03/31/2024 00:00:00'
group by payment_date
)

select department_avg.department_id, '03-2024' as payment_date,
case when department_avg.dep_avg > company_avg.com_avg then 'higher'
when department_avg.dep_avg < company_avg.com_avg then 'lower'
else 'same' end as comparision
from department_avg join company_avg
on department_avg.payment_date = company_avg.payment_date
