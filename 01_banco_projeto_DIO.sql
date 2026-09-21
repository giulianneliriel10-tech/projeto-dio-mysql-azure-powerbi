-- Projeto DIO: Integrando Dados com MySQL Azure e Transformando com Power BI
-- Base: Company/Employee Database (Elmasri & Navathe)
-- Script preparado para MySQL.

CREATE DATABASE IF NOT EXISTS projeto_dio;
USE projeto_dio;

DROP TABLE IF EXISTS DEPENDENT;
DROP TABLE IF EXISTS WORKS_ON;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS DEPT_LOCATIONS;
DROP TABLE IF EXISTS DEPARTMENT;
DROP TABLE IF EXISTS EMPLOYEE;

CREATE TABLE EMPLOYEE (
  Fname VARCHAR(10) NOT NULL, Minit CHAR(1), Lname VARCHAR(20) NOT NULL,
  Ssn CHAR(9) NOT NULL, Bdate DATE, Address VARCHAR(30), Sex CHAR(1),
  Salary DECIMAL(10,2), Super_ssn CHAR(9), Dno INT NOT NULL, PRIMARY KEY (Ssn)
);

CREATE TABLE DEPARTMENT (
  Dname VARCHAR(15) NOT NULL, Dnumber INT NOT NULL, Mgr_ssn CHAR(9) NOT NULL,
  Mgr_start_date DATE, PRIMARY KEY (Dnumber), UNIQUE (Dname)
);

CREATE TABLE DEPT_LOCATIONS (
  Dnumber INT NOT NULL, Dlocation VARCHAR(15) NOT NULL,
  PRIMARY KEY (Dnumber, Dlocation)
);

CREATE TABLE PROJECT (
  Pname VARCHAR(15) NOT NULL, Pnumber INT NOT NULL, Plocation VARCHAR(15),
  Dnum INT NOT NULL, PRIMARY KEY (Pnumber), UNIQUE (Pname)
);

CREATE TABLE WORKS_ON (
  Essn CHAR(9) NOT NULL, Pno INT NOT NULL, Hours DECIMAL(4,1) NOT NULL,
  PRIMARY KEY (Essn, Pno)
);

CREATE TABLE DEPENDENT (
  Essn CHAR(9) NOT NULL, Dependent_name VARCHAR(15) NOT NULL, Sex CHAR(1),
  Bdate DATE, Relationship VARCHAR(15),
  PRIMARY KEY (Essn, Dependent_name)
);

INSERT INTO EMPLOYEE VALUES
('John','B','Smith','123456789','1965-01-09','731 Fondren, Houston TX','M',30000,'333445555',5),
('Franklin','T','Wong','333445555','1965-12-08','638 Voss, Houston TX','M',40000,'888665555',5),
('Alicia','J','Zelaya','999887777','1968-01-19','3321 Castle, Spring TX','F',25000,'987654321',4),
('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire TX','F',43000,'888665555',4),
('Ramesh','K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble TX','M',38000,'333445555',5),
('Joyce','A','English','453453453','1972-07-31','5631 Rice, Houston TX','F',25000,'333445555',5),
('Ahmad','V','Jabbar','987987987','1969-03-29','980 Dallas, Houston TX','M',25000,'987654321',4),
('James','E','Borg','888665555','1937-11-10','450 Stone, Houston TX','M',55000,NULL,1);

INSERT INTO DEPARTMENT VALUES
('Research',5,'333445555','1988-05-22'),
('Administration',4,'987654321','1995-01-01'),
('Headquarters',1,'888665555','1981-06-19');

INSERT INTO DEPT_LOCATIONS VALUES
(1,'Houston'),(4,'Stafford'),(5,'Bellaire'),(5,'Sugarland'),(5,'Houston');

INSERT INTO PROJECT VALUES
('ProductX',1,'Bellaire',5),('ProductY',2,'Sugarland',5),('ProductZ',3,'Houston',5),
('Computerization',10,'Stafford',4),('Reorganization',20,'Houston',1),('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON VALUES
('123456789',1,32.5),('123456789',2,7.5),('666884444',3,40.0),
('453453453',1,20.0),('453453453',2,20.0),('333445555',2,10.0),
('333445555',3,10.0),('333445555',10,10.0),('333445555',20,10.0),
('999887777',30,30.0),('999887777',10,10.0),('987987987',10,35.0),
('987987987',30,5.0),('987654321',30,20.0),('987654321',20,15.0),
('888665555',20,16.0);

INSERT INTO DEPENDENT VALUES
('333445555','Alice','F','1986-04-04','Daughter'),
('333445555','Theodore','M','1983-10-25','Son'),
('333445555','Joy','F','1958-05-03','Spouse'),
('987654321','Abner','M','1942-02-28','Spouse'),
('123456789','Michael','M','1988-01-04','Son'),
('123456789','Alice','F','1988-12-30','Daughter'),
('123456789','Elizabeth','F','1967-05-05','Spouse');

ALTER TABLE DEPARTMENT ADD CONSTRAINT fk_department_manager FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE EMPLOYEE ADD CONSTRAINT fk_employee_manager FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE EMPLOYEE ADD CONSTRAINT fk_employee_department FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE DEPT_LOCATIONS ADD CONSTRAINT fk_location_department FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE PROJECT ADD CONSTRAINT fk_project_department FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE WORKS_ON ADD CONSTRAINT fk_work_employee FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE WORKS_ON ADD CONSTRAINT fk_work_project FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber);
ALTER TABLE DEPENDENT ADD CONSTRAINT fk_dependent_employee FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn);

-- Consulta principal: colaborador + departamento + gerente
SELECT
  CONCAT(e.Fname, ' ', e.Lname) AS Nome,
  d.Dname AS Departamento,
  CONCAT(m.Fname, ' ', m.Lname) AS Gerente,
  e.Salary AS Salario
FROM EMPLOYEE e
LEFT JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn;

-- Quantidade de colaboradores por gerente
SELECT
  COALESCE(CONCAT(m.Fname, ' ', m.Lname), 'Sem gerente') AS Gerente,
  COUNT(*) AS Qtd_Colaboradores
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn
GROUP BY m.Ssn, m.Fname, m.Lname
ORDER BY Qtd_Colaboradores DESC;

-- Horas por projeto
SELECT p.Pname AS Projeto, SUM(w.Hours) AS Horas_Total
FROM PROJECT p
LEFT JOIN WORKS_ON w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, p.Pname
ORDER BY Horas_Total DESC;
