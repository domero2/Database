merge into "database_name"."schema_name"."table_name" Src
using ( SELECT "PK_of_table","Sysdate","file",
          case row_number() over (partition by "PK_of_table" 
                                  order by "Sysdate" desc, "file" desc) when 1 then 'Y' else 'N' end AS "Calculation"
       FROM "database_name"."schema_name"."table_name"
      WHERE "flag" in ('U','Y')) SubRank
  on Src."PK_of_table" = SubRank."PK_of_table"
  and Src."Sysdate" = SubRank."Sysdate"
  and Src."file" = SubRank."file"
  and Src."flag" in ('U','Y')
  when matched then update set Src."flag" = SubRank."Calculation";
                       
merge into "database_name"."schema_name"."table_name" traget using (
    with source_reports as
    (
      select  $1:data_source::string "source_sys", 
              $1:data_filename::string "file", 
              METADATA$FILENAME "name_of_rep"
      from '@"database_name"."schema_name"."stage_name"/folder/sub_folder/'
      (file_format => '"database_name"."schema_name"."file_format_name"')
    )
    select  Stg."source_sys", 
            SPLIT_PART(Src."file",'.',3) "file_table", 
            TO_TIMESTAMP_LTZ(SPLIT_PART(Src."file",'.',6),'yyyymmddhh24miss') "generation_time",
            Stg."file", 
            Stg."name_of_rep",
            Stg."fetched_records",
            Stg."exported_records"
            from staging_table Stg 
            left join "database_name"."schema_name"."table_name" Tgr on Stg."name_of_rep"=Tgr."name_of_rep"
            where Tgr."ReportName" is null) as Stg
on traget."file"=Stg."file" and traget."name_of_rep" is null
when matched then update set 
    traget."name_of_rep"= Stg."name_of_rep",
    traget."fetched_records" = Stg."fetched_records",
    traget."exported_records" = Stg."exported_records"
when not matched then insert
    ("source_sys", 
    "file_table", 
    "generation_time",
    "file",
    "name_of_rep",
    "fetched_records",
    "exported_records")
    values
    (Stg."source_sys", 
    Stg."file_table", 
    Stg."generation_time",
    Stg."file",
    Stg."name_of_rep",
    Stg."fetched_records",
    Stg."exported_records"); 
                    
--generate insert statement base on information schem
select insert_part."2" || select_part."2" from
(select 1 as "1", 'INSERT INTO "database_name"."schema_name"."table_name"
\n(' || listagg('"'||column_name||'"',',\n') 
within group (order by ordinal_position) || ')\n' as "2" 
from "database_name".information_schema.columns where table_name = 'table_name' 
and table_schema = 'schema_name' and table_catalog = 'database_name') insert_part join
(select 1 as "1", 'select ' || listagg('"Items":"'||column_name||'" as "'||column_name||'"',',\n') 
within group (order by ordinal_position) || 
',\n
"FileName" as "FileName"\n from "database_name"."schema_name"."table_name_Lnd"'
as "2"
from "database_name".information_schema.columns where 
table_name = 'table_name' and table_schema = 'schema_name' and table_catalog = 'database_name'
) select_part on insert_part."1" = select_part."1";

                       
-- Function which return last file from s3 stage, prevent to load only csv extension and regex patern matched
create or replace  function LastFile()
returns string
as
$$
SELECT
   distinct TRIM(split_part(METADATA$FILENAME,'/',3)) as name
    FROM '@"DATABCOSTS"."LOADFILES"."AirflowAlbiAws"/Databricks/non-prod/'
     where regexp_like(name, '^[0-9]{{16}}-[0-9]{{4}}-[0-9]{{2}}-[a-zA-Z]{{5}}.csv') 
      and METADATA$FILENAME not in (Select distinct "FileName" from  "DATABCOSTS"."LOADFILES"."DatabricksCosts")
       order by name 
        limit 1
$$;   
                            
                            
                            
 --Getting data from s3 bbucket using staging and inserting into SF
COPY INTO "{database_name}"."{schema_name}"."{table_name_staging}"("Items", "FileName", "LoadingDate")
from (select t.$1,  METADATA$FILENAME, current_timestamp::timestamp_ntz
from '@"{stage_database}"."{stage_schema}"."{stage_name}"/{s3_folder_name}/{environment}/{file_name}'
(file_format => '"{stage_database}"."{stage_schema}"."{file_format_name}"') t)
ON_ERROR = 'ABORT_STATEMENT';

                            
--Parse json instruction to get json data                           
INSERT INTO "database_name"."schema_name"."table_name"
("Column1",
"Column2")
select 
TRIM(parse_json($1):"Column1_name",'"') as "Column1_name",
TRIM(parse_json($1):"Column2_name",'"') as "Column2_name"

from "database_name"."schema_name"."table_name"
                            
-- How to update table using CTE
update "database_name"."schema_name"."table_name" upd set upd."FlagColumn" = inner."FlagColumn2"
from ( 
with Ranks( SELECT "PK_of_table","Sysdate","file",
          case row_number() over (partition by "PK_of_table" 
                                  order by "Sysdate" desc, "file" desc) when 1 then 'Y' else 'N' end AS "Calculation"
       FROM "database_name"."schema_name"."table_name"
      WHERE "flag" in ('U','Y')) 
 select * from Ranks) inner
  on upd."PK_of_table" = inner."PK_of_table"
  and upd."Sysdate" = inner."Sysdate"
  and upd."file" = inner."file"
  and upd."flag" in ('U','Y')
