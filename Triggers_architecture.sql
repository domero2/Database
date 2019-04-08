/*MXT3_T_TRADES_EXT
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘T’ when there’s no errors and the ODS_STATUS_FLAG = ‘N’.
MXT3_T_TRADES_CLS
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘M’ when ERROR_FLAG = ‘E’.
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘S’ when there’s no errors and ODS_STATUS_FLAG = ‘T’.
- Update MXT3_T_TRADES_EXT, sets ODS_STATUS_FLAG = ‘P’.
MXT3_T_TRADES_TRM
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘M’ when ERROR_FLAG = ‘E’.
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘F’ when there’s no errors and ODS_STATUS_FLAG = ‘S’.
- Update MXT3_T_TRADES_CLS, sets ODS_STATUS_FLAG = ‘P’.
MXT3_T_TRADES_LDD
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘E’ when ERROR_FLAG = ‘E’.
- Update MXT3_T_TRADES_RAW, sets ODS_STATUS_FLAG = ‘P’ when there’s no errors and ODS_STATUS_FLAG = ‘F’.
- Update MXT3_T_TRADES_TRM, sets ODS_STATUS_FLAG = ‘P’.
*/
--Na tabeli EXT
TRIGGER "USER2"."EXT_Table" BEFORE
  INSERT ON EXT_Table FOR EACH ROW BEGIN

    UPDATE RAW_Table
    SET ODS_STATUS_FLAG = 'T',  ODS_UPDATE_DT = SYSDATE, ODS_PROCESS_DT = SYSDATE
    WHERE MSG_ID            = :NEW.MSG_ID
    AND ODS_STATUS_FLAG ='N';

END;

--Na tabeli CLS

  CREATE OR REPLACE TRIGGER "USER2"."CLS_Table" BEFORE
  INSERT ON CLS_Table FOR EACH ROW BEGIN
 
  IF :NEW.ODS_ERROR_FLAG = 'E' THEN
	UPDATE RAW_Table
	SET ODS_STATUS_FLAG = 'M', ODS_ERROR_FLAG = 'E', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID;
ELSE
	UPDATE RAW_Table
	SET ODS_STATUS_FLAG       ='S', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID
	AND ODS_STATUS_FLAG = 'T';
End IF;  

UPDATE EXT_Table
SET ODS_STATUS_FLAG = 'P', ODS_UPDATE_DT = SYSDATE, ODS_PROCESS_DT = SYSDATE
	WHERE EXT_Table_ID            = :NEW.CLS_Table_ID
	AND ODS_STATUS_FLAG ='N';
END;

--Na tabeli TRM
CREATE OR REPLACE TRIGGER "USER2"."TRM_Table" BEFORE
INSERT ON TRM_Table FOR EACH ROW BEGIN
 
  IF :NEW.ODS_ERROR_FLAG = 'E' THEN
	UPDATE RAW_Table
	SET ODS_STATUS_FLAG = 'M', ODS_ERROR_FLAG = 'E', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID;
ELSE
	UPDATE RAW_Table
	SET ODS_STATUS_FLAG       ='F', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID
	AND ODS_STATUS_FLAG = 'S';
End IF;  

UPDATE CLS_Table
SET ODS_STATUS_FLAG = 'P', ODS_UPDATE_DT = SYSDATE, ODS_PROCESS_DT = SYSDATE
	WHERE CLS_Table_ID            = :NEW.TRM_Table_ID;
END;

-- Na tabeli LDD
CREATE OR REPLACE TRIGGER "USER2"."LDD_Table" BEFORE
INSERT ON LDD_Table FOR EACH ROW BEGIN
 
  IF :NEW.ODS_ERROR_FLAG = 'E' THEN
	UPDATE RAW_Table
	SET ODS_STATUS_FLAG = 'E', ODS_ERROR_FLAG = 'E', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID;
ELSE
	UPDATE RAW_Table
	SET ODS_STATUS_FLAG       ='P', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID
	AND ODS_STATUS_FLAG = 'F';
End IF;  

UPDATE TRM_Table
SET ODS_STATUS_FLAG = 'P', ODS_UPDATE_DT = SYSDATE, ODS_PROCESS_DT = SYSDATE
	WHERE TRM_Table_ID            = :NEW.LDD_Table_ID;

UPDATE RAW_Table
SET ODS_STATUS_FLAG = 'E', ODS_UPDATE_DT = SYSDATE
	WHERE MSG_ID            = :NEW.MSG_ID
	AND ODS_STATUS_FLAG = 'M';
END;
