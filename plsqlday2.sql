--Ref Cursors

DECLARE
--declare ref cursor
  TYPE deptcurtype IS REF CURSOR RETURN
  department_masters%ROWTYPE;
  --declaring variable of ref cursor type
  dept_cv deptcurtype;
 dept_details department_masters%ROWTYPE;
BEGIN
    OPEN dept_cv FOR SELECT * FROM department_masters ;
    LOOP
        EXIT WHEN dept_cv%NOTFOUND;
        FETCH dept_cv INTO dept_details;
        DBMS_OUTPUT.PUT_LINE('dcode' || dept_details.dept_code ||'Dname ' ||dept_details.dept_name);
    END LOOP;
    
    CLOSE dept_cv;
  END;



--cursor with parameters

DECLARE
v_scode Number:=&code;
  CURSOR c1(sid NUMBER) IS SELECT * FROM Student_Masters WHERE student_code=sid;
 BEGIN
   -- OPEN c1(1001);
    FOR temp IN c1(v_scode)
    LOOP
      DBMS_OUTPUT.PUT_LINE('Student code: ' || temp.student_code);
      DBMS_OUTPUT.PUT_LINE('Student Name: ' || temp.student_name);
      DBMS_OUTPUT.PUT_LINE('dept code: ' || temp.dept_code);
      
      DBMS_OUTPUT.PUT_LINE('stud dob: '|| temp.student_dob);
      DBMS_OUTPUT.PUT_LINE('stud dob: '|| temp.student_address);
      
    END LOOP;
END;


DECLARE
v_total_mks number;
CURSOR c1 IS SELECT  * FROM Student_Marks;

BEGIN

FOR mks IN c1
LOOP
      v_total_mks:=mks.subject1+mks.subject2+mks.subject3;
      if(V_TOTAL_MKS>250) THEN
      INSERT INTO Performance VALUES(mks.student_code,v_total_mks);
      ELSE
      dbms_output.put_line(mks.student_code ||'  '|| v_total_mks);
      END IF;
END LOOP;
END;

CREATE TABLE Performance(
sid NUMBER,
total_mks number);

select * from performance;


--ref cursor

DECLARE
TYPE deptcurtype  IS REF CURSOR RETURN
department_masters%ROWTYPE;
dept_cv deptcurtype;
dept_details department_masters%ROWTYPE;
BEGIN
OPEN dept_cv FOR select * FROM department_masters;
LOOP
EXIT WHEN dept_cv%NOTFOUND;
FETCH dept_cv INTO dept_details;
dbms_output.put_line(dept_details.dept_name || ',' || dept_details.dept_code);
END LOOP;
CLOSE dept_cv;
END;


--Explicit cursor
DECLARE
--c_code STUDENT_MASTERS.STUDENT_CODE%TYPE;
--c_name STUDENT_MASTERS.STUDENT_NAME%TYPE;
CURSOR c1 IS
SELECT student_code,student_name
FROM student_masters
WHERE student_address='Chennai';

BEGIN

 -- OPEN c1;
  --FETCH c1 INTO c_code,c_name;
  --WHILE c1%FOUND
  FOR studrec IN c1
    LOOP
      
       -- EXIT WHEN c1%NOTFOUND;
        SYS.DBMS_OUTPUT.PUT_LINE(studrec.student_code ||'   '||studrec.student_name);
        --   FETCH c1 INTO c_code,c_name;
END LOOP;
--CLOSE c1;
END;

select * from emp;




 --updating the salary
 
 
DECLARE
v_sal staff_masters1.staff_sal%TYPE;
v_scode staff_masters1.staff_code%TYPE;
CURSOR c_staffsal IS
select staff_code,staff_sal FROM staff_masters1
WHERE staff_sal<28000;
BEGIN
OPEN c_staffsal;
--fetch before the loop
FETCH c_staffsal into v_scode,v_sal;
WHILE c_staffsal%FOUND
LOOP
   UPDATE staff_masters1
   SET staff_sal=v_sal*1.1
   WHERE staff_code=v_scode;
FETCH c_staffsal into v_scode,v_sal;
END LOOP;
CLOSE c_staffsal;
END;
 
 
 
 
 
 
 
 DECLARE
 c_id EMPLOYEE.EMPID%TYPE;
  c_name EMPLOYEE.EMPNAME%TYPE;
  c_salary  EMPLOYEE.SALARY%TYPE;
 --1. declare the cursor
      CURSOR c1 IS 
      SELECT empid,empname,salary 
      FROM Employee;
BEGIN

        UPDATE employee
          SET salary=salary+(.3)*SALARY;
    --2. open the cursor
    OPEN c1;
    --3.Fetch
    LOOP
          FETCH c1 INTO c_id, c_name,c_salary;
          --Termination condition
         /* UPDATE employee
          SET salary=salary+(.3)*SALARY
          WHERE empid=c_id;
            DBMS_OUTPUT.PUT_LINE('Updated salary');*/
      EXIT WHEN c1%NOTFOUND;
         --Process
          DBMS_OUTPUT.PUT_LINE('Name is : ' ||c_name ||'   '||' Salary is :' ||c_salary);
     END LOOP;
     --4 Close the cursor
     CLOSE c1;
 END;
 






set serveroutput on
--Implicit Cursor

BEGIN
  
    UPDATE dept SET dname='test' WHERE DEPTNO=94;
     IF SQL%ROWCOUNT=0 THEN
        INSERT INTO dept VALUES(94,'test','Chennai');
    END IF;
  END;
    


DECLARE
  v_dname DEPT.DNAME%TYPE;
BEGIN
    SELECT dname INTO v_dname  FROM Dept WHERE deptno=94;
   -- UPDATE dept SET dname='testing' WHERE DEPTNO=94;
    /*  IF SQL%NOTFOUND THEN
        INSERT INTO dept VALUES(92,'testing','Bangalore');
    END IF;*/
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No record found with the given deptid');
      END;
    


--Cursors

DECLARE
v_name VARCHAR2(20);
v_sal employee.salary%TYPE;
BEGIN
    SELECT empname,salary
    INTO v_name,v_sal
    FROM employee
    WHERE empid=333;
    DBMS_OUTPUT.PUT_LINE(' EMployee : ' || v_name || ' has a salary '|| v_sal);

EXCEPTION
      WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee matches the given emp no');
        WHEN TOO_MANY_ROWS THEN
              DBMS_OUTPUT.PUT_LINE('More than one employee  matches the given emp no');

END;


DECLARE

v_eno number;
v_name varchar2(20);
CURSOR c1 IS
    SELECT empno,ename
    FROM employee;
    
    BEGIN
    OPEN c1;
    LOOP
     FETCH c1 INTO v_eno,v_ename;
     EXIT WHEN c1%NOTFOUND;
     dbms_output.put_line(to_char(eno) ||'   '|| v_name);
     END LOOP;
     CLOSE c1;
    END;
    