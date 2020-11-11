USE publications;

-- Challenge 1
	-- STEP 1

SELECT * FROM sales;
SELECT * FROM titles;
SELECT * FROM titleauthor;

SELECT a.title_id, b.au_id, ROUND(a.advance * b.royaltyper/100) AS advance, ROUND(a.price * c.qty * a.royalty/100 * b.royaltyper/100) AS sales_royalty
FROM titles as a
LEFT JOIN titleauthor as b
ON a.title_id = b.title_id
LEFT JOIN sales as c
ON a.title_id = c.title_id;

	-- STEP 2
		-- without derived tables
        
SELECT a.title_id, b.au_id, ROUND(a.advance * b.royaltyper/100) AS advance, SUM(ROUND(a.price * c.qty * a.royalty/100 * b.royaltyper/100)) AS sales_royalty
FROM titles as a
LEFT JOIN titleauthor as b
ON a.title_id = b.title_id
LEFT JOIN sales as c
ON a.title_id = c.title_id
GROUP BY au_id, title_id;

		-- with derived tables
        
SELECT title_id, au_id, advance, SUM(sales_royalty) as sales_royalty_tot FROM
(SELECT a.title_id, b.au_id, ROUND(a.advance * b.royaltyper/100) AS advance, ROUND(a.price * c.qty * a.royalty/100 * b.royaltyper/100) AS sales_royalty
FROM titles as a
LEFT JOIN titleauthor as b
ON a.title_id = b.title_id
LEFT JOIN sales as c
ON a.title_id = c.title_id) step1
GROUP BY au_id, title_id;

	-- STEP 3
    
SELECT au_id, SUM((advance + sales_royalty_tot)) AS profit FROM
(SELECT title_id, au_id, advance, SUM(sales_royalty) as sales_royalty_tot FROM
(SELECT a.title_id, b.au_id, ROUND(a.advance * b.royaltyper/100) AS advance, ROUND(a.price * c.qty * a.royalty/100 * b.royaltyper/100) AS sales_royalty
FROM titles as a
LEFT JOIN titleauthor as b
ON a.title_id = b.title_id
LEFT JOIN sales as c
ON a.title_id = c.title_id) step1
GROUP BY au_id, title_id) step2
GROUP BY au_id
ORDER BY profit DESC
LIMIT 3;

-- Challenge 2
	-- STEP 1

SELECT * FROM sales;
SELECT * FROM titles;
SELECT * FROM titleauthor;

CREATE TEMPORARY TABLE STEP1
SELECT a.title_id, b.au_id, ROUND(a.advance * b.royaltyper/100) AS advance, ROUND(a.price * c.qty * a.royalty/100 * b.royaltyper/100) AS sales_royalty
FROM titles as a
LEFT JOIN titleauthor as b
ON a.title_id = b.title_id
LEFT JOIN sales as c
ON a.title_id = c.title_id;

SELECT * FROM STEP1;

	-- STEP 2
DROP TEMPORARY TABLE STEP3;

CREATE TEMPORARY TABLE STEP2
SELECT title_id, au_id, advance, SUM(sales_royalty) AS sales_royalty_tot 
FROM STEP1
GROUP BY au_id, title_id, advance;

SELECT * FROM STEP2;

	-- STEP 3
    
SELECT au_id, SUM((advance + sales_royalty_tot)) AS profit FROM
STEP2
GROUP BY au_id
ORDER BY profit DESC
LIMIT 3;


-- Challenge 3
CREATE TABLE final_table
SELECT au_id, SUM((advance + sales_royalty_tot)) AS profit FROM
(SELECT title_id, au_id, advance, SUM(sales_royalty) as sales_royalty_tot FROM
(SELECT a.title_id, b.au_id, ROUND(a.advance * b.royaltyper/100) AS advance, ROUND(a.price * c.qty * a.royalty/100 * b.royaltyper/100) AS sales_royalty
FROM titles as a
LEFT JOIN titleauthor as b
ON a.title_id = b.title_id
LEFT JOIN sales as c
ON a.title_id = c.title_id) step1
GROUP BY au_id, title_id) step2
GROUP BY au_id
ORDER BY profit DESC
LIMIT 3;

SELECT * FROM final_table;

