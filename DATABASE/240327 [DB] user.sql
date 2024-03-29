-- 실습 15-1
-- CREATE USER orclstudy
-- IDENTIFIED BY ORACLE;
-- -> 공통 사용자 또는 롤 이름이 부적합합니다.
-- -> C##orclstudy : 오라클12c 이후 버전부터
-- C## + (사용자이름)형식으로 작성해야 계정 생성이 가능함.

-- ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- : 예전 오라클 스크립트를 실행 가능하도록 하는 설정
    -- *** 세션 시작/변경할 때마다 실행해야 함
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- CREATE USER orclstudy
-- IDENTIFIED BY ORACLE;
-- -> 권한이 불충분합니다.
-- -> 계정 생성은 관리자 계정으로 실행해야 함

-- 실습 15-2(p.398)
-- system계정으로 변경 후 실행
-- ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; 먼저 실행.
CREATE USER orclstudy
IDENTIFIED BY ORACLE;
-- orclstudy 생성됨

-- 실습 15-3(p.399)
-- 세션 접속 권한 부여하기(관리자system 권한으로 실행)
GRANT CREATE SESSION TO orclstudy;
-- -> CMD 창의 SQLPLUS에서 접속되었음



-- 실습 15-4(p.400) : 계정 비밀번호 변경
ALTER USER orclstudy
IDENTIFIED BY ORCL;

-- 실습 15-5,6(p.400~401) : 계정 삭제하기
DROP USER orclstudy; -- 계정만 삭제하고 계정이 생성했던 객체(스키마)는 남겨둠
DROP USER orclstudy CASCADE; -- 계정을 삭제하고, 계정이 만들었던 모든 객체(스키마)를 삭제
-- 그냥 삭제하려고 하면 '현재 접속되어 있는 사용자는 삭제할 수 없다'고 뜸(SQLPLUS 실행 중이었음)
-- 다시 로그인 하려고 하면 사용자명/비밀번호가 부적합, 로그온 할 수 없습니다.라고 뜸



-- 시스템 권한 설정하기(P.402) : 관리자 계정으로 실행
-- 실습 15-7(p.405) : 사용자 생성 먼저
CREATE USER orclstudy
    IDENTIFIED BY ORACLE;
    
-- 실습 15-7(p.405) : 사용자에게 권한 부여하기
GRANT RESOURCE, CREATE SESSION, CREATE TABLE TO orclstudy;

-- 데이터 입력을 위한 테이블 스페이스 용량 설정하기
ALTER USER orclstudy
    QUOTA 2M ON USERS;

-- USERS의 테이블 스페이스 무제한 용량으로 설정
ALTER USER orclstudy
    QUOTA UNLIMITED ON USERS;

-- 모든 테이블 스페이스에 무제한 용량 설정
GRANT UNLIMITED TABLESPACE TO orclstudy;

-- 권한 취소
REVOKE 
    RESOURCE, CREATE SESSION, CREATE TABLE, UNLIMITED TABLESPACE
FROM orclstudy;



-- 객체 권한 부여하기 : SELECT, INSERT, UPDATE, DELETE 등
-- scott 계정으로 실행하기
CREATE TABLE temp (
    col1 VARCHAR2(20),
    col2 VARCHAR2(20)
);

GRANT
    SELECT, INSERT, UPDATE, DELETE
ON temp
TO orclstudy;

-- 객체 권한 취소
REVOKE
    SELECT, INSERT, UPDATE, DELETE
ON temp
FROM orclstudy;
-- -> 권한이 없다면 '테이블 또는 뷰가 존재하지 않는다'고 뜸

-- 객체 권한은 실행 즉시 적용된다.



-- 롤 : 여러 종류의 권한을 묶어 놓은 그룹
-- 사전 정의된 롤
-- connect 롤 : CREATE SESSION 권한만 가지고 있는 롤
-- RESOURCE 롤 : CREATE VIEW, CREATE SYNONYM을 제외한 대부분의 권한을 가지고 있는 롤
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM
TO orclstudy;
-- -> 관리자 권한을 제외한 대부분의 권한을 가지게 됨.

-- 사용자 정의 롤
-- 롤 생성 및 설정, 취소(관리자 계정으로 실행)
-- 1). CREATE ROLE 구문으로 롤 생성
CREATE ROLE rolestudy;
-- 2). 생성한 롤에 권한 설정하기
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM
TO rolestudy;
-- 3). 권한을 설정한 롤을 유저에게 설정하기
GRANT rolestudy TO orclstudy;
-- 4). 롤 취소하기
REVOKE rolestudy FROM orclstudy;
-- 5). 롤 삭제하기 : 롤을 삭제하면 롤을 부여 받았던 모든 계정의 롤이 취소되게 됨
DROP ROLE rolestudy;



-- 연습문제(p.416)
-- 1.
-- 1-1. system 계정으로 접속하여 prev_hw 계정 생성하기
-- 1-2. 비밀번호는 ORCL로 지정, 접속 권한 부여 후 접속 가능 여부 확인하기
CREATE USER prev_hw
IDENTIFIED BY ORCL;
GRANT CREATE SESSION TO prev_hw;

-- 2. SCOTT 계정으로 접속, PREV_HW계정에 SCOTT 소유의 EMP, DEPT, SALGRADE 테이블에 SELECT 권한 부여,
-- 권한 부여 후 PREV_HW 계정으로 SCOTT의 EMP, DEPT, SALGRADE 테이블 조회 확인
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
GRANT RESOURCE, CREATE SESSION, CREATE TABLE TO scott;
GRANT SELECT ON emp TO prev_hw;
GRANT SELECT ON dept TO prev_hw;
GRANT SELECT ON salgrade TO prev_hw;

-- sqlplus : SELECT * FROM SCOTT.emp;
-- -> 조회 됨

-- 3. SCOTT 계정으로 접속 후 PREV_HW 계정에 SALGRADE 테이블의 SELECT 권한 취소,
-- 권한 취소 후 PREV_HW계정으로 SCOTT의 SALGRADE 조회 확인
REVOKE SELECT ON salgrade FROM prev_hw;

-- sqlplus : SELECT * FROM scott.salgrade;
-- -> 조회 안 됨