This repositiory contains usefull Procedures, TRIGGERS and FUNCTIONS which could be used to solve some business problems. In this document you could find scripts from Oracle or SQL Server.

Automatic_partition_by_days.sql
Contains solution for automatic partitioning database by Oracle.

PARTITION_PROCEDURES_FUNCTIONS.sql
This file contains soluton for partitionig by own naming convention.

SP_FOR_BUSINESS_DAYS.sql
Usefull procedure used to count business days. Note that you need table where you will sotre holiday days.

Triggers_architecture.sql
Useful solution for flagging processed and unprocessed rows or rows which cause an error.

LOGGER.sql
Package which contains package body with procedures for logging errors occured in database. This package contains DDL for DB_LOG table aswell.

Repayment.sql - Solution for counting Payment date as a difference between First payment date and last payment date. Each payment date is counted as sequentially added part of year (month,quarter,semiyear,year). There are nominal value column which represent all amount of money which need to be pay during counted period ( difference between First payment date and last payment date). There is amount value column which stored sequential amount of payment.
