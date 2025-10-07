
--Part1: Basic SELECT Queries
/*Task 1.1: Write a query to select all employees, displaying their full name (concatenated first and
last name), department, and salary.
 */
SELECT first_name||' '||last_name AS full_name,
       department,
       salary
FROM employees;
/* ||''|| used to concatenate two texts.
   Between the || || symbols, we write the name of the column whose value we want take from the table and join with our text.
 */

/*Task 1.2: Use SELECT DISTINCT to find all unique departments in the company.
 */
SELECT DISTINCT department FROM employees;
-- we use from (DISTINCT) to make it unique not repeated.


--Task 1.3
/* Select all projects with their names and budgets, and create a new column called
budget_category using a CASE expression:
• 'Large' if budget > 150000
    */

SELECT
    project_name,
    budget,
    CASE
        WHEN budget > 150000 THEN 'Large'
        WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
        ELSE 'Small'
    END AS budget_category
FROM projects;
-- we used from(CASE WHEN) they are a condition expression in SQL like (if,else)


-- Task 1.4
/* Write a query using COALESCE to display employee names and their emails. If email is
NULL, display 'No email provided'.
 */

SELECT
    first_name||' '||last_name AS full_name,
    COALESCE(email, 'No email provided') AS email
FROM employees;
/*COALESCE() is a function in SQL that return the first non-NULL value from a list of values.
1. When some values might be NULL
This is the most common case — because if a value is missing (NULL),
we want to show a replacement (default) value instead.
 */


-- PART 2: WHERE Clause and Comparison Operators
--Task 2.1  ind all employees hired after January 1, 2020.
SELECT
    first_name,
    last_name,
    hire_date
FROM employees
WHERE hire_date > '2020-1-1';
-- WHERE: WHERE clause is used in SQL to filter the rows in a table. It chose only those rows that match to a specific condition.
--It's operators(<, >, =, <>, <=,>=, AND, OR, NOT)

/*Task 2.2 Find all employees whose salary is between 60000 and 70000 (use the BETWEEN
operator).
 */
SELECT
    first_name,
    last_name,
    salary
FROM employees
WHERE salary BETWEEN '60000' AND '70000';


--Task 2.3 : Find all employees whose last name starts with 'S' or 'J' (use the LIKE operator).
SELECT
    last_name
FROM employees
WHERE last_name LIKE 'S%' OR last_name  LIKE 'J%';
-- LIKE operator is used in SQL to search for patterns in text, using symbols like % (any number of characters) and _ (one character).
-- s% means start with s. %s means end with s. %s% means can have s in any part of it.
/* _ (underscore) in SQL LIKE is used to match exactly one character in a specific position.means we can know the length of
 a specific part of a text. one _ means 1 character
 */


--Task 2.4 Find all employees who have a manager (manager_id IS NOT NULL) and work in the IT department.
SELECT
    first_name,
    last_name,
    department,
    manager_id
FROM employees
WHERE manager_id IS NOT NULL
    AND department = 'IT'


--Part 3: String and Mathematical Functions
-- We have two types function in Database.1 Mathematical and 2 String function.
-- Task 3.1 Create a query that displays:
--1Employee names in uppercase
SELECT
    UPPER(first_name)AS first_name_upper,
    UPPER(last_name)AS last_name_upper
FROM employees;

--2 Length of their last names
SELECT
    LENGTH(last_name)AS LENGTH_last_name
FROM employees;

--3First 3 characters of their email address (use substring)
SELECT
    email,
    SUBSTRING(email,1,3)AS first_three_chars
FROM employees;
--email=text, 1=start_point(first), 3=length

--Task 3.2: Calculate the following for each employee:
--1 Annual salary(حقوق سالانه)
SELECT
    first_name,
    last_name,
    salary,
    (salary * 12)AS annual_salary
FROM employees;
-- (salary * 12)=>→ multiply each employee’s salary by 12 (months in a year).

--2 Monthly salary (rounded to 2 decimal places)
SELECT
    first_name,
    last_name,
    salary,
    ROUND(salary / 12, 2) AS monthly_salary
FROM employees;

--3• A 10% raise amount (use mathematical operators)
SELECT
    first_name,
    last_name,
    salary,
    (salary * 0.10) AS raise_amount,
    (salary + salary * 0.10) AS new_salary
FROM employees;

--Task 3.3:
/*Use the format() function to create a formatted string for each project: Project:
  [name] - Budget: $[budget] - Status: [status]"
 */
SELECT
    format('Project: %s - Budget: $%s - Status: %s',
           project_name, budget, status) AS project_summary
FROM projects;
--format() is a string function() that used to join several texts and values in one row.


/*Task 3.4: Calculate how many years each employee has been with the company (use date functions
and the current date).
 */
SELECT
    first_name || ' ' || last_name AS full_name,
    hire_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_with_company
FROM employees;
--EXTRACT, AGE, CURRENT_DATE= They are Time/Date function.


--Part 4: Aggregate Functions and GROUP BY
--Task 4.1: Calculate the average salary for each department.
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
--GROUP BY: by its we can bring the same rows in one column.

--Task 4.2: Find the total hours worked on each project, including the project name.
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours
FROM projects p
JOIN assignments a
    ON p.project_id = a.project_id
GROUP BY p.project_name;
--SUM shows total hours that have worked in each project.


/*Task 4.3: Count the number of employees in each department. Only show departments with more
than 1 employee (use HAVING).
 */

SELECT
    department,
    COUNT(employee_id) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(employee_id) > 1;
--HAVING = by its we defined for groups(GROUP BY)means after GROUP BY what should show.


/*Task 4.4: Find the maximum and minimum salary in the company, along with the total payroll (sum
of all salaries).
 */
SELECT
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    SUM(salary) AS total_payroll
FROM employees;

--Part 5: Set Operations
--Task 5.1: Write two queries and combine them using UNION:
--Query 1: Employees with salary > 65000
--Query 2: Employees hired after 2020-01-01 Display employee_id, full name, and salary

-- Query 1:
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary
FROM employees
WHERE salary > 65000

UNION

-- Query 2: Employees hired after 2020-01-01
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary
FROM employees
WHERE hire_date > '2020-01-01';
--UNION join two query and delete the repeated one.

--Task 5.2: Use INTERSECT to find employees who work in IT AND have a salary greater than 65000.
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    department,
    salary
FROM employees
WHERE department = 'IT'

INTERSECT

SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    department,
    salary
FROM employees
WHERE salary > 65000;
--INTERSECT → returns only the rows that appear in both queries (the common results).


--Task 5.3: Use EXCEPT to find all employees who are NOT assigned to any projects.
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name
FROM employees

EXCEPT

SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM employees e
JOIN assignments a
    ON e.employee_id = a.employee_id;


--Part 6: Subqueries
--Task 6.1: Use EXISTS to find all employees who have at least one project assignment.
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM assignments a
    WHERE a.employee_id = e.employee_id
);


--Task 6.2: Use IN with a subquery to find all employees working on projects with status 'Active'.
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name
FROM employees
WHERE employee_id IN (
    SELECT a.employee_id
    FROM assignments a
    JOIN projects p
        ON a.project_id = p.project_id
    WHERE p.status = 'Active'
);
--IN is operator that is used to check whether a value exists within a list of values or inside the result of a subquery.


--Task 6.3: Use ANY to find employees whose salary is greater than ANY employee in the Sales department.
--formula:value operator ANY (subquery)
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    department,
    salary
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
);


--Part 7: Complex Queries
--Task 7.1: Create a query that shows:
-- 1 Employee name
SELECT
    first_name || ' ' || last_name AS full_name,
    department
FROM employees;

--2 Average hours worked per employee.
SELECT
    employee_id,
    AVG(hours_worked) AS avg_hours_worked
FROM assignments
GROUP BY employee_id;

--3 Average hours worked across all their assignments
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    e.department,
    AVG(a.hours_worked) AS avg_hours_worked
FROM employees e
JOIN assignments a
    ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department;

--4  Rank employees by salary within their department
SELECT
    first_name || ' ' || last_name AS full_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_department
FROM employees;
--RANK() → assigns a ranking number to each row based on a specified order.
--Syntax = RANK() OVER (PARTITION BY column ORDER BY column DESC)


-- 5 Show employee name, department, average hours worked, and rank by salary.
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    e.department,
    AVG(a.hours_worked) AS avg_hours_worked,
    RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS rank_in_department
FROM employees e
JOIN assignments a
    ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary
ORDER BY e.department, rank_in_department;

--Task 7.2 Projects where total hours worked > 150
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS num_employees
FROM projects p
JOIN assignments a
    ON p.project_id = a.project_id
GROUP BY p.project_name
HAVING SUM(a.hours_worked) > 150;
-- it shows those projects that much with condition.

--Task 7.3: Create a report showing departments with their:
-- 1 Total number of employees
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department
--COUNT(*) it count all rows even some columns are NULL.

--2 Average salary
SELECT
    department,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY department;
--ROUND to decimal places.

--3 Highest paid employee name Use GREATEST and LEAST functions somewhere in this query
SELECT
    e.department,
    COUNT(*) AS total_employees,
    ROUND(AVG(e.salary), 2) AS average_salary,
    (
        SELECT first_name || ' ' || last_name
        FROM employees
        WHERE department = e.department
        ORDER BY salary DESC
        LIMIT 1
    ) AS highest_paid_employee,
    GREATEST(MAX(e.salary), MIN(e.salary)) AS greatest_value,
    LEAST(MAX(e.salary), MIN(e.salary)) AS least_value
FROM employees e
GROUP BY e.department;
--GREATEST() → returns the largest value from a list of values.
--LEAST() → returns the smallest value from a list of values.


















