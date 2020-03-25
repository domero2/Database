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
