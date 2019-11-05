WITH sip AS
  (SELECT /*+ parallel(8) */ 
    sip.SOR_1 ,
    sip.Sor2 ,
    sip.Sor3 
  FROM user1.TABLE1 sip
  WHERE sip.SOR_6 ='Package'
  AND sip.SOR_5 NOT IN ('something','something2','something3')
  ),
  sic AS
  (SELECT /*+ parallel(8) */
    sic.SOR_ID ,
    sic.SOR_2 ,
    sic.SOR_3
  FROM user1.TABLE1 sic
  WHERE sic.SOR_2 <>'Package'
  OR (sic.2    = 'Package'
  AND sic.SOR_3      IN (something','something2','something3'))
  ) ,
  pay AS
  (SELECT sld.sor_1 ,
    sld.SOR_L2,
    sld.SOR_3
  FROM user1.TABLE1 sld
  WHERE sld.SOR_5='pay'
  ) ,
  rec AS
  (SELECT sld.sor_1,
    sld.SOR_2,
    sld.SOR_3
  FROM user1.TABLE1 sld
  WHERE sld.SOR_L3='receive'
  ) ,
  phys AS
  (SELECT sld.sor1,
    sld.SOR_2,
    sld.SOR_3
  FROM user1.TABLE1 sld
  WHERE sld.3='physical'
  ) ,
  st_nodups AS
  (SELECT MAX(sor_1) AS sor_1,
    sor_2
  FROM user1.TABLE1
  WHERE TRUNC(SOR_DATE) =TO_DATE('$$p_R_DATE', '$$p_DATE_FORMAT')
  GROUP BY sor_2
  )
  ,
  si_nodups AS
  (SELECT MAX(sor_1) AS sor_1,
    SOR_2
  FROM user1.TABLE1
  GROUP BY SOR_2
  ) ,

 pack as 
  ( select /*+ parallel(8) */
    sip.SOR_1 ,
    sic.SOR_1,
    sic.SOR_2,
  FROM sip
  
  left join sic 
  ON instr(';'
			||TRIM(BOTH ';'
					FROM sip.SOR_2)
			||';',';'
			||sic.SOR_INSTR_CODE_INT_SRC
			||';',1,1)          >0 

 inner join  si_nodups  
 on sic.SOR_1=SI_NODUPS.SOR_1
 AND sic.SOR_1=SI_NODUPS.SOR_1

 )
  
SELECT ST.TRADE_STATUS_SRC ,
  ST.SOR_2 ,
   pack2.SOR_2             AS SOR_2_IP_Pack,
  pack2.SOR_INSTR_NAME              AS SOR_2_IP_Pack,
  si.SOR_3                AS SOR_3_IP_NoPack,
  si.SOR_4                AS SOR_4_IP_NoPack,
  SIP_R.SOR_6               AS SOR_6_Pack_Rec,
  rec.SOR_7                  AS SOR_7_NoPack_Rec,
  SIP_P.SOR_7                AS SOR_7_Pack_Pay,
  pay.SOR_7                  AS SOR_7_NoPack_Pay,
  phys.SOR_3       AS SOR_3_Phys,
  pack.SOR_2           AS SOR_2_Pack,
  SIC.SOR_1                 AS SOR_1_NoPack,
  ST.TRADING1

FROM user1.TABLE1 st

INNER JOIN st_nodups
ON st.sor_1      =st_nodups.sor_1
AND st.sor_t2=st_nodups.sor_2

  --___________________________________JOIN_SO1_INST
INNER JOIN SI_NODUPS
ON ST.SOR_T3=SI_NODUPS.SOR_I3

INNER JOIN user1.TABLE1 si
ON SI.SOR_I2=SI_NODUPS.SOR_I2
AND SI.SOR_I3=SI_NODUPS.SOR_I3
AND NOT ( (SI.SOR_I8='Default'
AND SI.SOR_2           ='Uni Future MtM'
AND SI.SOR_3='Rates'
AND SI.SOR_4    ='Rates')
OR (SI.SOR_5       ='Default'
AND SI.SOR_6           ='Bchr(38)S or Simple Cox'
AND SI.SOR_7='Listed Options or Listed Derivatives'
AND SI.8    ='Basket/Share')
OR (SI.SOR_9       ='Default'
AND SI.SOR_11          ='Bchr(38)S or Simple Cox'))

  --___________________________________JOIN_SO1_UND_INST_PACK
LEFT JOIN pack
ON si.sor_instr_id=pack.sor_instr_id
AND si.sor_und_instr_code_int_src=pack.SOR_INSTR_CODE_INT_SRC

LEFT JOIN sic
ON si.sor_und_instr_code_int_src=sic.SOR_INSTR_CODE_INT_SRC

  --___________________________________JOIN_SO1_INST_PACK
LEFT JOIN pack pack2
on si.sor_instr_id=pack2.sor_instr_id

  --___________________________________JOIN_SO1_LEG_PAY
LEFT JOIN pay
ON si.sor_instr_id=pay.sor_instr_id

  --___________________________________JOIN_SO1_LEG_REC
LEFT JOIN rec
ON si.sor_instr_id=rec.sor_instr_id

  --___________________________________JOIN_SO1_LEG_PHYS
LEFT JOIN phys
ON si.sor_instr_id=phys.sor_instr_id

  --___________________________________JOIN_SO1_LEG_PAY_PACK
LEFT JOIN pay sip_p
ON sip_p.sor_instr_id=pack2.sic_sor_instr_id

  --___________________________________JOIN_SO1_LEG_REC_PACK
LEFT JOIN rec sip_r
ON sip_r.sor_instr_id=pack2.sic_sor_instr_id

WHERE
TRUNC(ST.SOR_TRANS_TS) =TO_DATE('$$p_s_REPORTING_DATE', '$$p_s_DATE_FORMAT')
AND 
ST.COUNTERPARTY_NAME_SRC NOT LIKE '#%'
AND ST.COUNTERPARTY_NAME_SRC NOT IN ('HVB-M','22','25')
AND upper(ST.ENTITY_SRC)                 = 'SPA'
AND (ST.PRODUCT_TYPE in $$PRODUCT_TYPE
OR ((ST.PRODUCT_TYPE in $$PRODUCT_TYPE2 
AND (st.SOR_TRANS_INSTR_ISIN IS NOT NULL 
OR pack2.SOR_INSTR_ISIN IS NOT NULL) 
AND ST.TRADE_QTY_OR_NOMINAL NOT IN (1,-1)) 
OR (ST.PRODUCT_TYPE NOT in ('COM - OTC - Swap -', 'COM - OTC - Swap - CMD Index') 
AND ST.TRADE_QTY_OR_NOMINAL IN (1,-1) AND (st.SOR_TRANS_INSTR_ISIN IS NOT NULL OR 
pack2.SOR_INSTR_ISIN IS NOT NULL)))OR REGEXP_LIKE(pack2.SOR_INSTR_NAME,'^[a-zA-Z]{2}.{10}') 
AND length(pack2.SOR_INSTR_NAME)=12
OR REGEXP_LIKE(si.SOR_INSTR_NAME,'^[a-zA-Z]{2}.{10}') 
AND length(si.SOR_INSTR_NAME)=12
OR pack2.UNDERLYINGISIN IS NOT NULL
OR si.UNDERLYINGISIN IS NOT NULL
OR SIP_R.SOR_LEG_UND_INSTR_ISIN IS NOT NULL
OR SIP_P.SOR_LEG_UND_INSTR_ISIN IS NOT NULL)
AND ST.SOR_TRANS_TYPE_SRC in ('purchaseSale', 'upfrontPayment')
AND ST.TRADE_STATUS_SRC          IN ('Four Eyes Validated','Trusted Source','Cancelled by MO','Cancelled by FO','Cancelled')
AND TRUNC(ST.TRADE_TIME_SRC) > TO_DATE('$$TRADE_TIME_SRC','$$TRADE_TIME_SRC_FORMAT')
ORDER BY ST.SOR_TRANS_INSTR_CODE_INT_SRC ,
  ST.SOR_TRANS_REF_SRC
  
  
  
  /* NESTED JOINS*\
  
  SELECT 
	ST.SOR_TRANS_ID,
	ST.SRC_SYSTEM_CODE,
	ST.SOR_TRANS_REF_SRC,
	SUB_TS.MAX_SOR_TRANS_UPDATE_TS_SRC AS SOR_TRANS_UPDATE_TS_SRC,
	ST.TRADE_VERSION_SRC AS VERSION_NO,
	ST.TRADE_DATE_SRC
FROM 
	USERz.Tablez ST
JOIN
(
	SELECT 
		SOR_TRANS_REF_SRC,
		MAX(SOR_TRANS_UPDATE_TS_SRC) AS MAX_SOR_TRANS_UPDATE_TS_SRC
	FROM
		USERz.Tablez
	GROUP BY
		SOR_TRANS_REF_SRC
) SUB_TS
ON 	ST.SOR_TRANS_REF_SRC = SUB_TS.SOR_TRANS_REF_SRC
AND ST.SOR_TRANS_UPDATE_TS_SRC = SUB_TS.MAX_SOR_TRANS_UPDATE_TS_SRC

LEFT OUTER JOIN
(
	SELECT distinct	
		SI1.sor_instr_code_int_src,
		SI1.SOR_INSTR_TYPE_SRC
	FROM
		USERz.Tablez SI1
	INNER JOIN
	(
		select
			max(sor_instr_id) sor_instr_id,
			sor_instr_code_int_src
		from
			USERz.Tablez
		group by 
			sor_instr_code_int_src
	) SI2
	ON SI1.sor_instr_id = SI2.sor_instr_id
) SI
on	ST.sor_trans_instr_code_int_src = SI.sor_instr_code_int_src

WHERE	ST.SRC_SYSTEM_CODE in ($$SOURCE_SYSTEM) 
AND		'SO1' in ($$SOURCE_SYSTEM)
AND		to_number(to_char(ST.SOR_TRANS_ID)) > $$p_s_LAST_TE_SO1
