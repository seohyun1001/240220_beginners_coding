-- DDL(Data Definition Language)
-- : 생성, 변경, 삭제 관련 기능
-- 주의) 명령어를 수행하자마자 데이터베이스에 수행한 내용이 바로 반영되는 특성이 있음
--      -> 자동 커밋된다!

-- CREATE TABLE (소유계정).테이블이름(
-- 열1 이름 열1 자료형,
-- 열2 이름 열2 자료형,
-- ...
-- 열n 이름 열n 자료형
-- );



-- 실습 12-1(p.313)
CREATE TABLE emp_ddl(
    empno NUMBER(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2)
);
-- NUMBER(7,2) : 1000000.01
DESC emp_ddl;



-- 실습 12-4(p.315)
CREATE TABLE emp_ddl_30
    AS SELECT * FROM emp
        WHERE deptno = 30;
SELECT * FROM emp_ddl_30;

-- 실습 12-5(p.315)
CREATE TABLE empdept_ddl
    AS SELECT E.empno, E.ename, E.job, E.mgr, E.hiredate,
                E.sal, E.comm, D.deptno, D.dname, D.loc
                FROM emp E
        INNER JOIN dept D ON D.deptno = E.deptno
    WHERE 1<>1;
SELECT * FROM empdept_ddl;