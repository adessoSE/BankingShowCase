

-- Tested using MySQL 5.7.26-0ubuntu0.18.04.1 

-- Common Table Expressions are only supported in MySQL 8+
-- However, we are using mysql 5.8, so the main script was change such that the common table expressions will be created as intermediate views


use haushaltsbuch;


--
-- Table structure for base table `payment_data`
--

DROP TABLE IF EXISTS `payment_data`;

CREATE TABLE `payment_data` (
  `transactionId` int(8) DEFAULT NULL,
  `step` int(12) DEFAULT NULL,
  `action` varchar(32) DEFAULT NULL,
  `amount` double(16,2) DEFAULT NULL,
  `amount_real` double(16,2) DEFAULT NULL,
  `nameOrig` varchar(64) DEFAULT NULL,
  `place` varchar(64) DEFAULT NULL,
  `date` varchar(10) DEFAULT NULL,
  `datetime` varchar(5) DEFAULT NULL,
  `verwendungszweck` varchar(128) DEFAULT NULL,
  `oldBalanceOrig` double(16,2) DEFAULT NULL,
  `newBalanceOrig` double(16,2) DEFAULT NULL,
  `nameDest` varchar(64) DEFAULT NULL,
  `oldBalanceDest` double(16,2) DEFAULT NULL,
  `newBalanceDest` double(16,2) DEFAULT NULL,
  `isFraud` int(1) DEFAULT NULL,
  `isFlaggedFraud` int(1) DEFAULT NULL,
  `isUnauthorizedOverdraft` int(1) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




---

-- base views

---


DROP VIEW IF EXISTS `expenses`;


DROP VIEW IF EXISTS `receives`;

DROP VIEW IF EXISTS `cash_ins`;


CREATE VIEW `expenses` AS
SELECT   `payment_data`.`nameOrig`                                                AS `id_orig`, 
         count(`payment_data`.`nameOrig`)                                         AS `number_expenses`,
         avg(`payment_data`.`amount`) AS `average_spent`,
         sum(payment_data`.`amount`) AS `sum_spent`, 
         sum(`payment_data`.`isunauthorizedoverdraft`)                            AS `number_of_overdraft_attempts`,
         max(`payment_data`.`oldBalanceOrig`)                                     AS `max_balance`,
         min(`payment_data`.`newBalanceOrig`)                                     AS `min_balance`
FROM     `payment_data` 
WHERE    (`payment_data`.`action` <> 'CASH_IN') 
GROUP BY `payment_data`.`nameOrig`;

CREATE VIEW `receives` AS
SELECT   `payment_data`.`namedest`                                                AS `id_dest`, 
         count(`payment_data`.`namedest`)                                         AS `number_receives`,
         avg(`payment_data`.`amount`) AS `average_received`,
         sum(`payment_data`.`amount`) AS `sum_received`,
         max(`payment_data`.`newBalanceDest`)                                     AS `max_balance_dest`,
         min(`payment_data`.`oldBalanceDest`)                                     AS `min_balance_dest`
FROM     `payment_data` 
GROUP BY `payment_data`.`namedest`;



CREATE VIEW `cash_ins` AS
SELECT   `payment_data`.`nameorig`                                                  AS `id_cash`, 
         count(`payment_data`.`nameOrig`)                                           AS `number_cash_ins`,
         avg(`payment_data`.`amount`) AS `average_cash_ins`,
         sum(`payment_data`.`amount`) AS `sum_cash_ins`
FROM     `payment_data` 
WHERE    ( `payment_data`.`action` = 'CASH_IN' ) 
GROUP BY `payment_data`.`nameOrig`;


--
-- main outbound view
--


DROP VIEW IF EXISTS `summarize_values`;


CREATE VIEW `summarize_values`                                                                                                         AS
SELECT `res`.`id_orig`                                                                                                                 AS `customer_id`,
       `res`.`number_expenses`                                                                                                         AS `number_expenses`,
       `res`.`number_receives`                                                                                                         AS `number_receives`,
       `res`.`number_cash_ins`                                                                                                         AS `number_cash_ins`,
       `res`.`sum_cash_ins`                                                                                                            AS `sum_cash_ins`,
       (`res`.`number_receives` + `res`.`number_cash_ins`)                                                                             AS `overall_number_receives`,
       `res`.`average_spent`                                                                                                           AS `average_spent`,
       ((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`))                           AS `overall_avg_received`,
       (((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) AS `balance_ratio`,
       `res`.`max_balance`                                                                                                             AS `max_balance`,
       `res`.`min_balance`                                                                                                             AS `min_balance`,( 
       CASE 
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) < 0.2) THEN 6
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.2 AND    0.3) THEN 5.75
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.3 AND    0.4) THEN 5.5
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.4 AND    0.5) THEN 5.25
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.5 AND    0.6) THEN 5
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.6 AND    0.7) THEN 4.75
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.7 AND    0.8) THEN 4.5
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.8 AND    0.9) THEN 4.25
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) BETWEEN 0.9 AND    1) THEN 4
              WHEN ( 
                            ( 
                                   ( 
                                          ( 
                                                 `res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) > 1) THEN 3.75
       END) AS `interest_rate`,( 
       CASE 
              WHEN ( 
                            `res`.`average_received` < 0) THEN 10 
              WHEN ( 
                            `res`.`average_received` BETWEEN 0 AND    5000) THEN (round((`res`.`average_received` / 1000),0) * 10000)
              WHEN ( 
                            `res`.`average_received` BETWEEN 5000 AND    100000) THEN (round((`res`.`average_received` / 1000),0) * 15000)
              WHEN ( 
                            `res`.`average_received` > 100000) THEN (round((`res`.`average_received` / 1000),0) * 20000)
       END) AS `credit_limit` 
FROM  (
SELECT    `expenses`.`id_orig`                           AS `id_orig`, 
          `expenses`.`number_expenses`                   AS `number_expenses`, 
          `expenses`.`average_spent`                     AS `average_spent`, 
          `expenses`.`sum_spent`                         AS `sum_spent`, 
          `expenses`.`number_of_overdraft_attempts`      AS `number_of_overdraft_attempts`, 
          `expenses`.`max_balance`                       AS `max_balance`, 
          `expenses`.`min_balance`                       AS `min_balance`, 
          `receives`.`id_dest`                           AS `id_dest`, 
          `receives`.`number_receives`                   AS `number_receives`, 
          `receives`.`average_received`                  AS `average_received`, 
          `receives`.`sum_received`                      AS `sum_received`, 
          `receives`.`max_balance_dest`                  AS `max_balance_dest`, 
          `receives`.`min_balance_dest`                  AS `min_balance_dest`, 
          `cash_ins`.`id_cash`                           AS `id_cash`, 
          `cash_ins`.`number_cash_ins`                   AS `number_cash_ins`, 
          `cash_ins`.`average_cash_ins`                  AS `average_cash_ins`, 
          `cash_ins`.`sum_cash_ins`                      AS `sum_cash_ins` 
FROM      ((`expenses` 
JOIN      `receives` 
ON       (( 
                              `receives`.`id_dest` = `expenses`.`id_orig`))) 
LEFT JOIN `cash_ins` 
ON       (( 
                              `cash_ins`.`id_cash` = `expenses`.`id_orig`)))) `res` ;
