CREATE OR REPLACE PROCEDURE CC.sp_Update_XML(
    v_proc_log_id INT 
  , v_xml_id INT 
  , v_status OUT VARCHAR2
)
IS
  v_cnt            INT;
  v_i              INT;
  v_comment        VARCHAR2(100);
  v_event_action   VARCHAR2(30);
  v_message_data   XMLTYPE;
BEGIN
	
  v_comment      := 'Comment 1';
  v_event_action := 'Cancel';
  v_status := 'failed';

  if v_xml_id IS NOT NULL THEN  
  
SELECT xmltype(REPLACE(REPLACE(message_data, '<!DOCTYPE MxML SYSTEM "mxml.dtd">'), '<!DOCTYPE MxML SYSTEM "MXML.DTD">')) INTO v_message_data FROM Table1 WHERE id = v_xml_id;
    
 

    SELECT
      updateXML(v_message_data
      , '/KPLUS_MESSAGE/IamDeals/TypeOfEvent/text()', v_comment
	  , '/KPLUS_MESSAGE/LoansDepositDeals/TypeOfEvent/text()', v_comment
	  , '/KPLUS_MESSAGE/CashFlowDeals/TypeOfEvent/text()', v_comment
	  , '/KPLUS_MESSAGE/SpotDeals/TypeOfEvent/text()', v_comment
	  , '/KPLUS_MESSAGE/ForwardDeals/TypeOfEvent/text()', v_comment
	   , '/KPLUS_MESSAGE/FxSwapDeals/TypeOfEvent/text()', v_comment
      , '/KPLUS_MESSAGE/HEADER/Action/text()', v_event_action
      ) INTO v_message_data
    FROM dual;
    

  
    INSERT INTO TABLE2 (PROC_LOG_ID, XML_ID, NEW_MESSAGE_DATA) 
	VALUES(v_proc_log_id, v_xml_id, v_message_data.getclobval());
  ELSE
    INSERT INTO TABLE2 (PROC_LOG_ID) VALUES(v_proc_log_id);
  END IF;
  
  COMMIT;

  v_status := 'ok';
END;



CREATE OR REPLACE PROCEDURE CC.sp_MXG_updt_exist(
    v_proc_log_id INT 
  , v_xml_id INT 
  , v_status OUT VARCHAR2
)
IS
  v_secondaryevent        VARCHAR2(100);
  v_mainevent_cancel        VARCHAR2(100);
  v_mainevent       VARCHAR2(100);
  v_flag INT;
  v_message_data   XMLTYPE;
BEGIN
	
	v_secondaryevent := 'First comment';
	v_mainevent_cancel := 'Second comment';
	v_mainevent := 'CANCEL';
    v_status := 'failed';
  if v_xml_id IS NOT NULL THEN  
  
  SELECT xmltype(REPLACE(REPLACE(source_data, '<!DOCTYPE MxML SYSTEM "mxml.dtd">'), '<!DOCTYPE MxML SYSTEM "MXML.DTD">')) 
  INTO v_message_data FROM TABLE1 WHERE msg_id = v_xml_id;  
  -- Checks if secondary_action xpath exists
 SELECT
	count(*) INTO
		v_flag
	FROM
		TABLE1
	WHERE
		EXISTSNODE(v_message_data, '/MxML/events/secondaryEvent/action/text()' )= 1
		AND msg_id = v_xml_id;
		
		
IF v_flag = 1 THEN -- When /MxML/events/secondaryEvent[1]/action' exists, then update two paths, else update only one xpath
 SELECT
	UPDATEXML( v_message_data, '/MxML/events/mainEvent/action/text()', v_mainevent, 
	'/MxML/events/secondaryEvent/action/text()', v_secondaryevent )
	INTO
		v_message_data
	FROM
		dual;
ELSE  SELECT
	UPDATEXML( v_message_data, '/MxML/events/mainEvent/action/text()', v_mainevent_cancel ) INTO
		v_message_data
	FROM
		dual;
END IF;
    

  
    INSERT INTO TABLE2 (PROC_LOG_ID, XML_ID, NEW_MESSAGE_DATA) 
	VALUES(v_proc_log_id, v_xml_id, v_message_data.getclobval());
  ELSE
    INSERT INTO TABLE2 (PROC_LOG_ID) VALUES(v_proc_log_id);
  END IF;
  
  COMMIT;

  v_status := 'ok';
END;




CREATE OR REPLACE PROCEDURE CC.sp_XMLTABLE(
    v_proc_log_id INT 
  , v_xml_id INT 
  , v_status OUT VARCHAR2
)
IS
  v_cnt            INT;
  v_i              INT;
  v_comment        VARCHAR2(100);
  v_event_action   VARCHAR2(30);
  v_message_data   XMLTYPE;
BEGIN

  v_comment      := 'Comment';
  v_event_action := 'CANCEL';
  v_status := 'failed';

  if v_xml_id IS NOT NULL THEN  
    -- Get the message and convert it to xmltype
SELECT xmltype(REPLACE(REPLACE(message_data, '<!DOCTYPE MxML SYSTEM "mxml.dtd">'), '<!DOCTYPE MxML SYSTEM "MXML.DTD">')) INTO v_message_data FROM TABLE1 WHERE id = v_xml_id; --v_id;
    
    -- Count trade nodes
    SELECT count(*) cnt INTO v_cnt
    FROM xmltable('/MxML/trades/trade' passing v_message_data COLUMNS trade_version NUMBER PATH 
	'businessObjectId/versionIdentifier/versionRevision/versionNumber/text()' ) TABLE1;
    
    -- Update some header informations
    SELECT
      updateXML(v_message_data
      , '/MxML/contracts/contract[1]/contractHeader/contractSource/lastContractEventReference/@mefClass', v_comment
      , '/MxML/contracts/contract[1]/contractHeader/contractSource/lastContractEventAction/text()', v_event_action
      ) INTO v_message_data
    FROM dual;
    
    -- Loop through all trades and increment trade version by 1
    FOR v_i IN 1..v_cnt
    LOOP
      SELECT
        updateXML(v_message_data,
          '/MxML/trades/trade['||v_i||']/businessObjectId/versionIdentifier/versionRevision/versionNumber/text()', 
		  extractValue(v_message_data, '/MxML/trades/trade['||v_i||']/businessObjectId/versionIdentifier/versionRevision/versionNumber/text()')+1 
        ) INTO v_message_data
      FROM dual;
      
  --    DBMS_OUTPUT.put_line ('Round #'||v_i);
    END LOOP;  
  
    -- SELECT SUBSTR(v_message_data.getClobVal(), 1, 5000) INTO v_message_data_out FROM dual;
    -- v_message_data_out := SUBSTR(v_message_data, 1, 4000);
    -- v_message_data_out := v_message_data.getClobVal();
  
    INSERT INTO TABLE2 (PROC_LOG_ID, XML_ID, NEW_MESSAGE_DATA) 
	VALUES(v_proc_log_id, v_xml_id, v_message_data.getclobval());
  ELSE
    INSERT INTO TABLE2 (PROC_LOG_ID) VALUES(v_proc_log_id);
  END IF;
  
  COMMIT;

  v_status := 'ok';
END;


