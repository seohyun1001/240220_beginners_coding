-- 실습 9-1(p.242)
SELECT sal FROM emp
WHERE ename = 'JONES';

-- 실습 9-2(p.243)
SELECT * FROM emp 
WHERE sal > 2975;

-- 실습 9-3(p.244)
SELECT * FROM emp
WHERE sal >
    (SELECT sal FROM emp WHERE ename = 'JONES');
    


-- 실습 9-4(p.246)
SELECT * FROM emp
    WHERE hiredate <
        (SELECT hiredate FROM emp WHERE ename = 'SCOTT');



-- 실습 9-5(p.247)
SELECT E.empno, E.ename, E.job, E.sal, D.deptno, D.dname, D.loc
    FROM emp E
        INNER JOIN dept D ON E.deptno = D.deptno
            WHERE E.deptno = 20 AND E.sal >
            (SELECT AVG(sal) FROM EMP);

-- 30번 부서의 평균 급여보다 많이 받는 20번 부서의 사람들을 출력하는 SQL문
SELECT * FROM emp
WHERE deptno = 20 AND sal >
    (SELECT AVG(sal) FROM emp WHERE deptno = 30);
    


-- 실습 9-7(p.250)
-- 각 부서별 최고 급여와, 동일한 급여를 받는 사원 정보 출력
SELECT * FROM emp
    WHERE sal IN(SELECT MAX(sal) FROM emp 
                    GROUP BY deptno);
-- 최고 급여와 금액이 같은 필드까지 같이 출력됨



-- 실습 9-9(p.251)
-- IN과 똑같은 역할
SELECT * FROM emp
    WHERE sal = ANY(SELECT MAX(sal) FROM emp 
                    GROUP BY deptno);
-- 실습 9-10(p.252)
SELECT * FROM emp
    WHERE sal = SOME(SELECT MAX(sal) FROM emp 
                    GROUP BY deptno);
                    
-- 실습 9-11(p.252)
-- 30번 부서 사원들의 최대 급여보다 적은 급여를 받는 사원 정보 출력하기 
SELECT * FROM emp
    WHERE sal < ANY (SELECT sal FROM emp
                        WHERE deptno = 30)
        ORDER BY sal, empno;
        
        

-- 실습 9-14(p.255)
SELECT * FROM emp
    WHERE sal < ALL (SELECT sal FROM emp
                        WHERE deptno = 30)
        ORDER BY sal, empno;
        
        

-- 실습 9-16(p.256)
SELECT * FROM emp
    WHERE EXISTS(SELECT dname FROM dept WHERE deptno = 10);

-- 실습 9-17(p.256)
SELECT * FROM emp
    WHERE EXISTS(SELECT dname FROM dept WHERE deptno = 50);



-- 실습 9-18(p.258)
-- 다중열 서브쿼리 사용하기
SELECT * FROM emp
    WHERE (deptno, sal) IN
    (SELECT deptno, MAX(sal) FROM emp
    GROUP BY deptno);



-- 실습 9-19(p.259)
-- FROM 절에서 사용하는 서브쿼리 = 인라인 뷰
SELECT E10.empno, E10.ename, E10.deptno, D.dname, D.loc
    FROM (SELECT * FROM emp WHERE deptno = 10) E10
        INNER JOIN (SELECT * FROM dept) D ON E10.deptno = D.deptno;

-- 실습 9-20(p.260)       
WITH
    E10 AS (SELECT * FROM emp WHERE deptno = 10),
    D AS (SELECT * FROM dept)
SELECT E10.empno, E10.ename, E10.deptno, D.dname, D.loc
    FROM E10
     INNER JOIN D ON E10.deptno = D.deptno;

-- 실습 9-21(p.261)
-- * 주의) SELECT의 서브쿼리는 반드시 결과가 하나만 나오도록 작성해야 함
SELECT empno, ename, job, sal,
    (SELECT grade FROM salgrade
        WHERE E.sal BETWEEN losal AND hisal) AS SALGRADE,
            deptno,
            (SELECT dname FROM dept
                WHERE E.deptno = dept.deptno) AS dname
                    FROM emp E;

SELECT E.empno, E.ename, E.job, E.sal, S.grade, D.deptno, D.dname
    FROM emp E
        INNER JOIN salgrade S ON E.sal BETWEEN S.losal AND S.hisal
        INNER JOIN dept D ON E.deptno = D.deptno;



-- 연습 문제
-- p.262 ~ 263
-- 1.
SELECT E.job, E.empno, E.ename, E.sal, E.deptno, D.dname FROM emp E
    INNER JOIN dept D ON D.deptno = E.deptno
        WHERE job = 
            (SELECT job FROM emp WHERE ename = 'ALLEN');

-- 2.
SELECT E.empno, E.ename, D.dname, E.hiredate, D.loc, E.sal, S.grade FROM emp E
    INNER JOIN dept D ON D.deptno = E.deptno
    INNER JOIN salgrade S ON E.sal BETWEEN S.losal AND S.hisal
        WHERE sal > ANY
            (SELECT AVG(SAL) FROM emp)
                ORDER BY E.sal desc, E.empno;

-- 3.
SELECT E.empno, E.ename, E.job, D.deptno, D.dname, D.loc FROM emp E
    INNER JOIN dept D ON D.deptno = E.deptno
        WHERE E.deptno = 10 and job NOT IN
            (SELECT job FROM emp WHERE deptno = 30);

-- 4.
SELECT E.empno, E.ename, E.sal, S.grade FROM EMP E
    INNER JOIN salgrade S ON E.sal BETWEEN S.losal AND S.hisal
        WHERE E.sal >
            (SELECT MAX(sal) FROM emp WHERE job = 'SALESMAN')
                ORDER BY E.empno;

SELECT E.empno, E.ename, E.sal, S.grade FROM EMP E
    INNER JOIN salgrade S ON E.sal BETWEEN S.losal AND S.hisal
        WHERE E.sal > ALL
            (SELECT sal FROM emp WHERE job = 'SALESMAN')
                ORDER BY E.empno;
                


-- 서브쿼리 연습문제
-- 1. SCOTT의 급여(SAL)와 동일하거나 더 많이 받는 사원의 이름(ENAME)과 급여(SAL)를 출력하세요.
SELECT ename, sal FROM emp
    WHERE sal >=
        (SELECT sal FROM emp WHERE UPPER(ename) = UPPER('SCOTT'));

-- 2. 직급이 'CLERK'인 사람의 부서번호(DEPTNO)와 부서명(DNAME)을 출력하세요.
SELECT D.deptno, D.dname FROM dept D
    INNER JOIN emp E ON E.deptno = D.deptno
        WHERE job = 'CLERK';

SELECT E.deptno, D.dname FROM emp E
INNER JOIN dept D ON D.deptno = E.deptno
    WHERE E.deptno IN
    (SELECT deptno FROM emp WHERE job = 'CLERK');
    
    SELECT DEPTNO, DNAME
FROM DEPT
WHERE DEPTNO IN (
    SELECT DEPTNO
    FROM EMP
    WHERE JOB = 'CLERK'
);

-- 3. 이름에 T를 포함하고 있는 사원들과 같은 부서에서 근무하는 사원의 사번(EMPNO)과 이름(ENAME)을 출력하세요.
SELECT empno, ename FROM emp
    WHERE deptno IN
    (SELECT DISTINCT deptno FROM emp WHERE ename LIKE('%T%'));

-- 4. 부서 위치가 DALLAS인 모든 사원의 이름(ENAME), 부서번호(DEPTNO)를 출력하세요.
SELECT E.ename, D.deptno FROM emp E
INNER JOIN dept D ON E.deptno = D.deptno
WHERE D.loc = 'DALLAS'
ORDER BY empno;

SELECT ename, deptno FROM emp
WHERE deptno =
    (SELECT deptno FROM dept WHERE LOC = 'DALLAS')
    ORDER BY empno;

-- 5. SALES 부서의 모든 사원의 이름(ENAME)과 급여(SAL)를 출력하세요.
SELECT E.ename, E.sal FROM EMP E
INNER JOIN dept D ON E.deptno = D.deptno
WHERE D.dname = 'SALES'
ORDER BY empno;

SELECT ename, sal FROM emp
WHERE deptno =
    (SELECT deptno FROM dept WHERE dname = 'SALES')
    ORDER BY empno;

-- 6.  KING에게 보고하는(=매니저가 KING인 사원) 모든 사원의 이름(ENAME)과 급여(SAL)를 출력하세요.
SELECT ename, sal FROM emp
WHERE mgr =
    (SELECT empno FROM emp WHERE ename = 'KING')
    ORDER BY empno;

SELECT E.ename, E.sal FROM emp E
INNER JOIN emp E2 ON E.mgr = E2.empno
    WHERE E2.ename = 'KING'
    ORDER BY E.empno;

-- 7. 자신의 급여가 평균급여보다 많고 이름에 S가 들어가는 사원과 동일한 부서에서 근무하는 
-- 모든 사원의 이름(ENAME), 급여(SAL)를 출력하세요.
SELECT ename, sal FROM emp
WHERE sal >
    (SELECT AVG(sal) FROM emp)
        AND deptno IN
            (SELECT DISTINCT deptno FROM emp WHERE ename LIKE('%S%'))
            ORDER BY sal;
