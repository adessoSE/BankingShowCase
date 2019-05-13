-- MySQL dump 10.13  Distrib 8.0.15, for Win64 (x86_64)
--
-- Host: localhost    Database: haushaltsbuch
-- ------------------------------------------------------
-- Server version	8.0.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `summarize_values`
--

DROP TABLE IF EXISTS `summarize_values`;
/*!50001 DROP VIEW IF EXISTS `summarize_values`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `summarize_values` AS SELECT 
 1 AS `customer_id`,
 1 AS `number_expenses`,
 1 AS `number_receives`,
 1 AS `number_cash_ins`,
 1 AS `sum_cash_ins`,
 1 AS `overall_number_receives`,
 1 AS `average_spent`,
 1 AS `overall_avg_received`,
 1 AS `balance_ratio`,
 1 AS `max_balance`,
 1 AS `min_balance`,
 1 AS `interest_rate`,
 1 AS `credit_limit`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `payment_data`
--

DROP TABLE IF EXISTS `payment_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `payment_data` (
  `step` int(8) DEFAULT NULL,
  `action` varchar(32) DEFAULT NULL,
  `amount` double(16,2) DEFAULT NULL,
  `amount_real` double(16,2) DEFAULT NULL,
  `nameOrig` varchar(16) DEFAULT NULL,
  `place` varchar(32) DEFAULT NULL,
  `date` varchar(10) DEFAULT NULL,
  `datetime` varchar(5) DEFAULT NULL,
  `verwendungszweck` varchar(64) DEFAULT NULL,
  `oldBalanceOrig` double(16,2) DEFAULT NULL,
  `newBalanceOrig` double(16,2) DEFAULT NULL,
  `nameDest` varchar(16) DEFAULT NULL,
  `oldBalanceDest` double(16,2) DEFAULT NULL,
  `newBalanceDest` double(16,2) DEFAULT NULL,
  `isFraud` int(1) DEFAULT NULL,
  `isFlaggedFraud` int(1) DEFAULT NULL,
  `isUnauthorizedOverdraft` int(1) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `summarize_values`
--

/*!50001 DROP VIEW IF EXISTS `summarize_values`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`patrice`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `summarize_values` AS select `res`.`id_orig` AS `customer_id`,`res`.`number_expenses` AS `number_expenses`,`res`.`number_receives` AS `number_receives`,`res`.`number_cash_ins` AS `number_cash_ins`,`res`.`sum_cash_ins` AS `sum_cash_ins`,(`res`.`number_receives` + `res`.`number_cash_ins`) AS `overall_number_receives`,`res`.`average_spent` AS `average_spent`,((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) AS `overall_avg_received`,(((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) AS `balance_ratio`,`res`.`max_balance` AS `max_balance`,`res`.`min_balance` AS `min_balance`,(case when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) < 0.2) then 6 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.2 and 0.3) then 5.75 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.3 and 0.4) then 5.5 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.4 and 0.5) then 5.25 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.5 and 0.6) then 5 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.6 and 0.7) then 4.75 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.7 and 0.8) then 4.5 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.8 and 0.9) then 4.25 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) between 0.9 and 1) then 4 when ((((`res`.`sum_received` + `res`.`sum_cash_ins`) / (`res`.`number_receives` + `res`.`number_cash_ins`)) / `res`.`average_spent`) > 1) then 3.75 end) AS `interest_rate`,(case when (`res`.`average_received` < 0) then 10 when (`res`.`average_received` between 0 and 5000) then (round((`res`.`average_received` / 1000),0) * 10000) when (`res`.`average_received` between 5000 and 100000) then (round((`res`.`average_received` / 1000),0) * 15000) when (`res`.`average_received` > 100000) then (round((`res`.`average_received` / 1000),0) * 20000) end) AS `credit_limit` from (with `expenses` as (select `payment_data`.`nameOrig` AS `id_orig`,count(`payment_data`.`nameOrig`) AS `number_expenses`,avg((`payment_data`.`oldBalanceOrig` - `payment_data`.`newBalanceOrig`)) AS `average_spent`,sum((`payment_data`.`oldBalanceOrig` - `payment_data`.`newBalanceOrig`)) AS `sum_spent`,sum(`payment_data`.`isUnauthorizedOverdraft`) AS `number_of_overdraft_attempts`,max(`payment_data`.`newBalanceOrig`) AS `max_balance`,min(`payment_data`.`newBalanceOrig`) AS `min_balance` from `payment_data` where (`payment_data`.`action` <> 'CASH_IN') group by `payment_data`.`nameOrig`), `receives` as (select `payment_data`.`nameDest` AS `id_dest`,count(`payment_data`.`nameDest`) AS `number_receives`,avg((`payment_data`.`newBalanceDest` - `payment_data`.`oldBalanceDest`)) AS `average_received`,sum((`payment_data`.`newBalanceDest` - `payment_data`.`oldBalanceDest`)) AS `sum_received`,sum(`payment_data`.`isUnauthorizedOverdraft`) AS `number_of_overdraft_attempts_dest`,max(`payment_data`.`newBalanceDest`) AS `max_balance_dest`,min(`payment_data`.`newBalanceDest`) AS `min_balance_dest` from `payment_data` group by `payment_data`.`nameDest`), `cash_ins` as (select `payment_data`.`nameOrig` AS `id_cash`,count(`payment_data`.`nameOrig`) AS `number_cash_ins`,avg((`payment_data`.`newBalanceOrig` - `payment_data`.`oldBalanceOrig`)) AS `average_cash_ins`,sum((`payment_data`.`newBalanceOrig` - `payment_data`.`oldBalanceOrig`)) AS `sum_cash_ins` from `payment_data` where (`payment_data`.`action` = 'CASH_IN') group by `payment_data`.`nameOrig`) select `expenses`.`id_orig` AS `id_orig`,`expenses`.`number_expenses` AS `number_expenses`,`expenses`.`average_spent` AS `average_spent`,`expenses`.`sum_spent` AS `sum_spent`,`expenses`.`number_of_overdraft_attempts` AS `number_of_overdraft_attempts`,`expenses`.`max_balance` AS `max_balance`,`expenses`.`min_balance` AS `min_balance`,`receives`.`id_dest` AS `id_dest`,`receives`.`number_receives` AS `number_receives`,`receives`.`average_received` AS `average_received`,`receives`.`sum_received` AS `sum_received`,`receives`.`number_of_overdraft_attempts_dest` AS `number_of_overdraft_attempts_dest`,`receives`.`max_balance_dest` AS `max_balance_dest`,`receives`.`min_balance_dest` AS `min_balance_dest`,`cash_ins`.`id_cash` AS `id_cash`,`cash_ins`.`number_cash_ins` AS `number_cash_ins`,`cash_ins`.`average_cash_ins` AS `average_cash_ins`,`cash_ins`.`sum_cash_ins` AS `sum_cash_ins` from ((`expenses` join `receives` on((`receives`.`id_dest` = `expenses`.`id_orig`))) left join `cash_ins` on((`cash_ins`.`id_cash` = `expenses`.`id_orig`)))) `res` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-10 13:30:16