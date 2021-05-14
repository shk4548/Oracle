---- 여러행을 입력으로 데이터를 집계하여 하나의 행으로 반환

-- count : 갯수세기
-- employees 테이블에 몇 개의 레코드가 있나?
SELECT COUNT(*) FROM employees; --- 107


-- *로 카운트 > 모든 레코드의 수
-- 컬럼 명시 > null 값은 집계에서 제외
SELECT COUNT(commission_pct) FROM employees;

-- 아래 쿼리와 동일
SELECT COUNT(*) FROM employees
Where commision_pct IS NOT NULL;

--합계 :SUM
-- 사원들 급여 총합
SELECT SUM(salary) FROM employees;

-- 평균 : AVG
-- 사원들 급여 평균
SELECT AVG(salary) FROM employees;

-- 흔히 범하는 오류 
-- 부서별 평균 급여 산정
SELECT department_id, AVG(salary)
FROM employees; -- department_id는 단일 레코드로 집계되지 않으므로 오류

SELECT department_id , salary
FROM employees
ORDER BY department_id;


--수정
-- 그룹별 집계를 위해서는 GROUP BY 절을 이용
SELECT department_id , ROUND(AVG(salary),2) "Average Salary"
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수를 사용한 쿼리문의 SELECT 컬럼 목록에는 
-- 그룹핑에 참여한 필드 OR 집계 함ㅅ만 올 수 있다.

--Having절
-- 평균 급여가 7000 이상인 부서만
SELECT department_id, AVG(salary) 
FROM employees
WHERE AVG(salary) >= 7000     --WHERE 절은 GROUP BY 집계가 일어나기 이전에 조건 체크
GROUP BY department_id;

-- 집계함수 실행 이전에 WHERE 절의 조건을 검사
-- 집계함수 컬럼은 WHERE 절에서 사용할 수 없다.
-- 집계 이후 조건 검사는 HAVING 절으로 수행

--수정된 쿼리
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id
    HAVING  AVG(salary) >= 7000     -- 집계 이후에 조건을 검사
ORDER BY department_id;


---------
-- 분석 함수

-- ROULLUP
-- GROUP BY 절과 함께 사용
-- 그룹핑된 결과에 대한 좀더 상세한 요약을 제공
-- 일종의 ITEM TOTAL 기능을 수행
SELECT department_id,job_id , SUM(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

-- ROLLUP으로 ITEM TOTAL 도 출력
SELECT department_id, job_id , SUM(salary)
FROM employees
GROUP BY ROLLUP (department_id ,job_id)
ORDER BY department_id;

-- CUBE
-- Cross Tab에 의한 Summary 함께 추출
-- ROLLUP 함수에 의해 제공되는 ITEM TOTAL과 함께
-- COLUMN TOTAL 값을 함께 제공
SELECT department_id, job_id , SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

----------------
-- SUBQUERY
----------------
--하나의 SQL 내부에서 다른 SQL를 포함하는 형태
-- 임시로 테이블 구성, 임시결과를 바탕으로 최종 쿼리를 수행

-- 사원들의 급여 중앙값보다 많은 급여를 받은 직원들
-- 급여의 중간값을 알아야함
-- 중간값보다 많이 받는 직원 추출 쿼리

-- 급여의 중간 값?
SELECT MEDIAN(salary) FROM employees;  -- 6200

-- 이 결과보다 많은 급여를 받는 직원 추출 쿼리
SELECT first_name, salary 
FROM employees
WHERE salary > 6200
ORDER BY salary  DESC;

-- 두 쿼리 합쳐 봅니다.
SELECT first_name, salary
FROM employees
Where salary > (SELECT MEDIAN(salary) FROM employees)
ORDER By SALARY DESC;

