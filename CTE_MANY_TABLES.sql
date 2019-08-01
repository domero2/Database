WITH sip AS
  (SELECT /*+ parallel(8) */ 
    sip.SOR_INSTR_ID ,
    sip.SOR_INSTR_PACK_CODE_INT_SRC ,
    sip.SOR_INSTR_MARKET_NAME ,
    sip.SOR_INSTR_TYPE_SRC ,
    sip.SOR_INSTR_NAME ,
    sip.SOR_OPT_CALL_PUT ,
    sip.SOR_OPT_STRIKE ,
    sip.SOR_INSTR_CCY ,
    sip.SOR_OPT_STYLE ,
    sip.SOR_OPT_PAYOFFTYPE ,
    sip.SOR_INSTR_EXPIRY ,
    sip.SETTLMENT_TYPE ,
    sip.TRADE_PRICE_MULTIPLIER ,
    sip.SOR_INSTR_ISIN ,
    sip.UNDERLYINGISIN ,
    sip.SOR_INSTR_CODE_INT_SRC,
    sip.SOR_INSTR_MODEL
  FROM user1.TABLE1 sip
  WHERE sip.SOR_INSTR_TYPE_SRC ='Package'
  AND sip.SOR_INSTR_MODEL NOT IN ('Reserved PNL','HVB PuMa OTC Derivative','Uni iCPPI Package')
  ),
  sic AS
  (SELECT /*+ parallel(8) */
    sic.SOR_INSTR_ID ,
    sic.SOR_INSTR_PACK_CODE_INT_SRC ,
    sic.SOR_INSTR_MARKET_NAME ,
    sic.SOR_INSTR_TYPE_SRC ,
    sic.SOR_INSTR_NAME ,
    sic.SOR_OPT_CALL_PUT ,
    sic.SOR_OPT_STRIKE ,
    sic.SOR_INSTR_CCY ,
    sic.SOR_OPT_STYLE ,
    sic.SOR_OPT_PAYOFFTYPE ,
    sic.SOR_INSTR_EXPIRY ,
    sic.SETTLMENT_TYPE ,
    sic.TRADE_PRICE_MULTIPLIER ,
    sic.SOR_INSTR_ISIN ,
    sic.UNDERLYINGISIN ,
    sic.SOR_INSTR_CODE_INT_SRC,
	sic.SOR_INSTR_MODEL,
  sic.SOR_UND_INSTR_TYPE_SRC
  FROM user1.TABLE1 sic
  WHERE sic.SOR_INSTR_TYPE_SRC <>'Package'
  OR (sic.SOR_INSTR_TYPE_SRC    = 'Package'
  AND sic.SOR_INSTR_MODEL      IN ('Reserved PNL','HVB PuMa OTC Derivative','Uni iCPPI Package'))
  ) ,
  pay AS
  (SELECT sld.sor_instr_id ,
    sld.SOR_LEG_UND_INSTR_ISIN,
    sld.SOR_LEG_CCY
  FROM user1.TABLE1 sld
  WHERE sld.SOR_LEG_PAYMNT_SIGN='pay'
  ) ,
  rec AS
  (SELECT sld.sor_instr_id,
    sld.SOR_LEG_UND_INSTR_ISIN,
    sld.SOR_LEG_CCY
  FROM user1.TABLE1 sld
  WHERE sld.SOR_LEG_PAYMNT_SIGN='receive'
  ) ,
  phys AS
  (SELECT sld.sor_instr_id,
    sld.SOR_LEG_UND_INSTR_ISIN,
    sld.SOR_LEG_CCY
  FROM user1.TABLE1 sld
  WHERE sld.SOR_LEG_TYPE_SRC='physical'
  ) ,
  st_nodups AS
  (SELECT MAX(sor_trans_id) AS sor_trans_id,
    sor_trans_ref_src
  FROM user1.TABLE1
  WHERE TRUNC(SOR_TRANS_TS) =TO_DATE('$$p_s_REPORTING_DATE', '$$p_s_DATE_FORMAT')
  GROUP BY sor_trans_ref_src
  )
  ,
  si_nodups AS
  (SELECT MAX(sor_instr_id) AS sor_instr_id,
    SOR_INSTR_CODE_INT_SRC
  FROM user1.TABLE1
  GROUP BY SOR_INSTR_CODE_INT_SRC
  ) ,

 pack as 
  ( select /*+ parallel(8) */
    sip.SOR_INSTR_ID ,
    sic.SOR_INSTR_ID SIC_SOR_INSTR_ID,
    sic.SOR_INSTR_MODEL,
    sip.SOR_INSTR_PACK_CODE_INT_SRC ,
    sic.SOR_INSTR_MARKET_NAME ,
    sic.SOR_INSTR_TYPE_SRC ,
    sic.SOR_INSTR_NAME ,
    sic.SOR_OPT_CALL_PUT ,
    sic.SOR_OPT_STRIKE ,
    sic.SOR_INSTR_CCY ,
    sic.SOR_OPT_STYLE ,
    sic.SOR_OPT_PAYOFFTYPE ,
    sic.SOR_INSTR_EXPIRY ,
    sic.SETTLMENT_TYPE ,
    sic.TRADE_PRICE_MULTIPLIER ,
    sic.SOR_INSTR_ISIN ,
    sic.UNDERLYINGISIN ,
    sic.SOR_INSTR_CODE_INT_SRC,
    sic.SOR_UND_INSTR_TYPE_SRC
  FROM sip
  
  left join sic 
  ON instr(';'
			||TRIM(BOTH ';'
					FROM sip.SOR_INSTR_PACK_CODE_INT_SRC)
			||';',';'
			||sic.SOR_INSTR_CODE_INT_SRC
			||';',1,1)          >0 

 inner join  si_nodups  
 on sic.SOR_INSTR_CODE_INT_SRC=SI_NODUPS.SOR_INSTR_CODE_INT_SRC
 AND sic.SOR_INSTR_ID=SI_NODUPS.SOR_INSTR_ID

 )
  
SELECT ST.TRADE_STATUS_SRC ,
  ST.SOR_TRANS_REF_SRC ,
  ST.EXTERNAL_TRANS_ID ,
  ST.ENTITY_SRC ,
  ST.COUNTERPARTY_CODE_INT_SRC ,
  ST.NDG_CODE ,
  LTRIM(ST.NDG_CODE,'0') AS NDG_CODE_LTRIM,
  ST.TRADE_QTY_OR_NOMINAL ,
  ST.TRADE_TIME_SRC ,
  ST.SOR_TRANS_INSTR_CODE_INT_SRC ,
  ST.SOR_TRANS_ID ,
  ST.SOR_TRANS_TYPE_SRC ,
  ST.TRADE_PRICE ,
  ST.TRADE_PRICE_CCY ,
  ST.MIC_CODE ,
  ST.MEMBERSHIP_CODE ,
  ST.SOR_TRANS_NETAMOUNT ,
  ST.COMPLEXTRCOMPID ,
  ST.ALGO_ID ,
  ST.INVESTMENTDECISIONWITHINFIRM ,
  ST.OPERATOR_CODE_SRC ,
  ST.COMMODITIES_INDIC ,
  ST.NOSTRO_ACCOUNT_CODE_SRC ,
  ST.TRADE_VERSION_SRC ,
  ST.SOR_TRANS_ENTRY_USER_CODE ,
  SI.SOR_INSTR_PRODUCT_TYPE_SRC,
  SI.SOR_INSTR_MODEL,
  SI.SOR_INSTR_TYPE_SRC,
  SI.SOR_INSTR_ALLOTMENT ,
  SI.SOR_INSTR_CODE_INT_SRC ,
  SI.SOR_INSTR_CCY,
  SI.SOR_INSTR_PACK_CODE_INT_SRC,
  SI.SOR_INSTR_ID,
   pack2.SOR_INSTR_ISIN              AS SOR_INSTR_ISIN_IP_Pack,
  pack2.SOR_INSTR_NAME              AS SOR_INSTR_NAME_IP_Pack,
  si.SOR_INSTR_ISIN                AS SOR_INSTR_ISIN_IP_NoPack,
  si.SOR_INSTR_NAME                AS SOR_INSTR_NAME_IP_NoPack,
  pack2.SOR_INSTR_TYPE_SRC          AS SOR_INSTR_TYPE_SRC_IP_Pack,
  si.SOR_INSTR_TYPE_SRC            AS SOR_INSTR_TYPE_SRC_IP_NoPack,
  SIP_R.SOR_LEG_CCY                AS SOR_LEG_CCY_Pack_Rec,
  rec.SOR_LEG_CCY                  AS SOR_LEG_CCY_NoPack_Rec,
  SIP_P.SOR_LEG_CCY                AS SOR_LEG_CCY_Pack_Pay,
  pay.SOR_LEG_CCY                  AS SOR_LEG_CCY_NoPack_Pay,
  SIP_R.SOR_LEG_UND_INSTR_ISIN     AS SOR_LEG_UND_INSTR_ISIN_Pack_R,
  rec.SOR_LEG_UND_INSTR_ISIN       AS SOR_LEG_UND_INSTR_ISIN_NoP_R,
  SIP_P.SOR_LEG_UND_INSTR_ISIN     AS SOR_LEG_UND_INSTR_ISIN_Pack_P,
  pay.SOR_LEG_UND_INSTR_ISIN       AS SOR_LEG_UND_INSTR_ISIN_NoP_P,
  phys.SOR_LEG_UND_INSTR_ISIN       AS SOR_LEG_UND_INSTR_ISIN_Phys,
  pack.SOR_INSTR_TYPE_SRC           AS SOR_INSTR_TYPE_SRC_Pack,
  sic.SOR_INSTR_TYPE_SRC           AS SOR_INSTR_TYPE_SRC_NoPack,
  pack.SOR_INSTR_MARKET_NAME        AS SOR_INSTR_MARKET_NAME_Pack,
  sic.SOR_INSTR_MARKET_NAME        AS SOR_INSTR_MARKET_NAME_NoPack,
  pack2.TRADE_PRICE_MULTIPLIER      AS TRADE_PRICE_MULTI_IP_Pack,
  si.TRADE_PRICE_MULTIPLIER        AS TRADE_PRICE_MULTI_IP_NoPack,
  pack2.UNDERLYINGISIN              AS UNDERLYINGISIN_IP_Pack,
  si.UNDERLYINGISIN                AS UNDERLYINGISIN_IP_NoPack,
  pack2.SOR_INSTR_MARKET_NAME       AS SOR_INSTR_MKT_NAME_IP_Pack,
  si.SOR_INSTR_MARKET_NAME         AS SOR_INSTR_MKT_NAME_IP_NoPack,
  pack2.SOR_OPT_PAYOFFTYPE          AS SOR_OPT_PAYOFFTYPE_IP_Pack,
  si.SOR_OPT_PAYOFFTYPE            AS SOR_OPT_PAYOFFTYPE_IP_NoPack,
  pack2.SOR_OPT_CALL_PUT            AS SOR_OPT_CALL_PUT_IP_Pack,
  si.SOR_OPT_CALL_PUT              AS SOR_OPT_CALL_PUT_IP_NoPack,
  pack2.SOR_OPT_STRIKE              AS SOR_OPT_STRIKE_IP_Pack,
  si.SOR_OPT_STRIKE                AS SOR_OPT_STRIKE_IP_NoPack,
  pack2.SOR_INSTR_CCY               AS SOR_INSTR_CCY_IP_Pack,
  si.SOR_INSTR_CCY                 AS SOR_INSTR_CCY_IP_NoPack,
  pack2.SOR_OPT_STYLE               AS SOR_OPT_STYLE_IP_Pack,
  si.SOR_OPT_STYLE                 AS SOR_OPT_STYLE_IP_NoPack,
  pack2.SOR_INSTR_EXPIRY            AS SOR_INSTR_EXPIRY_IP_Pack,
  si.SOR_INSTR_EXPIRY              AS SOR_INSTR_EXPIRY_IP_NoPack,
  pack2.SOR_INSTR_ID                AS SOR_INSTR_ID_IP_Pack,
  si.SOR_INSTR_ID                  AS SOR_INSTR_ID_IP_NoPack,
  pack.SOR_INSTR_ID                 AS SOR_INSTR_ID_Pack,
  SIC.SOR_INSTR_ID                 AS SOR_INSTR_ID_NoPack,
  pack2.SETTLMENT_TYPE              AS SETTLMENT_TYPE_IP_Pack,
  si.SETTLMENT_TYPE                AS SETTLMENT_TYPE_IP_NoPack,
  pack2.SOR_INSTR_MODEL             AS SOR_INSTR_MODEL_IP_Pack,
  pack2.SOR_INSTR_PACK_CODE_INT_SRC AS SOR_INSTR_P_CODE_INT_SRC_IP_P,
  pack.SOR_UND_INSTR_TYPE_SRC as SOR_UND_INSTR_TYPE_SRC_Pack,
  sic.SOR_UND_INSTR_TYPE_SRC as SOR_UND_INSTR_TYPE_SRC_NoPack,
  ST.PRODUCT_TYPE,
  st.PRICE_NOTATION,
  st.INCR_DECR,
  st.SOR_TRANS_INSTR_ISIN,
  ST.TRADING_BOOK_SRC

FROM user1.TABLE1 st

INNER JOIN st_nodups
ON st.sor_trans_id      =st_nodups.sor_trans_id
AND st.sor_trans_ref_src=st_nodups.sor_trans_ref_src

  --___________________________________JOIN_SO1_INST
INNER JOIN SI_NODUPS
ON ST.SOR_TRANS_INSTR_CODE_INT_SRC=SI_NODUPS.SOR_INSTR_CODE_INT_SRC

INNER JOIN user1.TABLE1 si
ON SI.SOR_INSTR_CODE_INT_SRC=SI_NODUPS.SOR_INSTR_CODE_INT_SRC
AND SI.SOR_INSTR_ID=SI_NODUPS.SOR_INSTR_ID
AND NOT ( (SI.SOR_INSTR_ALLOTMENT='Default'
AND SI.SOR_INSTR_MODEL           ='Uni Future MtM'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Rates'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Rates')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Bchr(38)S or Simple Cox'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Listed Options or Listed Derivatives'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Basket/Share')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Bchr(38)S or Simple Cox'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Listed Options or Listed Derivatives'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Share')
OR (SI.SOR_INSTR_ALLOTMENT       ='Eurex/Flex'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Swaps'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='CCS/CME'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Swaps'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='CCS/ICE'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Swaps'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Physical'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='No Basket Split'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Uni Future'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Uni Gas Future'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='LME Future'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Eurex/Flex'
AND SI.SOR_INSTR_MODEL           ='HVB_LME Bchr(38)S Listed American'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Derivative'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Commodity')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='HVB Dividend Future'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Basket/Share')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='HVB Notional Future'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Securities')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Uni Future'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Basket/Share')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Uni Future MtM'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Future'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Basket/Share')
OR (SI.SOR_INSTR_ALLOTMENT       ='Default'
AND SI.SOR_INSTR_MODEL           ='Uni Future MtM'
AND SI.SOR_INSTR_PRODUCT_TYPE_SRC='Futures'
AND SI.SOR_UND_INSTR_TYPE_SRC    ='Currencies') )

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
