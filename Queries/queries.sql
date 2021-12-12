-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
	 first_name VARCHAR NOT NULL,
	 last_name VARCHAR NOT NULL,
	 gender VARCHAR NOT NULL,
	 hire_date DATE NOT NULL,
	 PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY(emp_no,dept_no)

);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no,from_date)
	

);

-- SELECT * FROM dept_emp;

-- DROP TABLE titles CASCADE;

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01'AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01'AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01'AND '1988-12-31');
--check the table
SELECT * FROM retirement_info;

DROP TABLE emp_info;

-- create new table of retiring employees

SELECT emp_no,first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01'AND '1988-12-31');

--Joining departments and dept_name tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

--Joining retirement info and dept_emp tables 
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no=de.emp_no
WHERE de.to_date =('9999=01-01');

--Current employee count by dept_no 
SELECT COUNT (ce.emp_no),de.dept_no
-- create another table 
INTO count_current_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de 
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no,first_name,last_name,gender 
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND'1955-12-31') AND
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	
SELECT e.emp_no,e.first_name,e.last_name,e.gender,s.salary,de.to_date
INTO emp_info
FROM employees as e 
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01'AND'1955-12-31') AND
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

--List of managers per depatment 
SELECT dm.dept_no,d.dept_name,dm.emp_no,ce.last_name,
ce.first_name,dm.from_date,dm.to_date
INTO manager_info
FROM dept_manager AS DM
	INNER JOIN departments AS D
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,ce.first_name,ce.last_name,d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);

SELECT ri.emp_no,ri.first_name,ri.last_name,d.dept_name
FROM retirement_info as ri
INNER JOIN dept_emp as de 
ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN('Sales','Development');

-------------------------------------------------------------------------

Challenge  file 


SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date,t.to_date
--INTO retirement_titles
FROM employees as e
INNER JOIN titles as t 
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01'AND'1955-12-31') 
ORDER BY emp_no;

-- Messages 
133776 rows affected 

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no)emp_no, rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY emp_no, to_date DESC;

--Messages 
90398 rows affected 


SELECT COUNT (ut.title),ut.title
-- create another table 
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;


SELECT DISTINCT ON (e.emp_no)e.emp_no,e.first_name,e.last_name,
	e.birth_date,de.from_date,de.to_date,t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t 
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (birth_date BETWEEN '1965-01-01'AND'1965-12-31')
ORDER BY e.emp_no;

--Messages
1549 rows affected

