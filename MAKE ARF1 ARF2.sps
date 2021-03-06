﻿***** ODBC GET ***.

**** CALCULATE CLIENT ASSESSMENT RATING  FACTOR.


COMPUTE mINTERCEPT=1.068.

**** LIVING ARRANGEMENT FACTOR.
COMPUTE mLIVINGARR=0.
IF LIVING_ARRANGE='PRRE' mLIVINGARR= -.096.
IF LIVING_ARRANGE='NUHO' mLIVINGARR= .113.
IF LIVING_ARRANGE='PSYF' mLIVINGARR= -.276.


**** PSA FACTOR.
COMPUTE mPSA=0.
IF SUBSTR(PSA,1,2)='03'  mPSA= -.180.
IF SUBSTR(PSA,1,2)='04'  mPSA= -.196.
IF SUBSTR(PSA,1,2)='05'  mPSA= -.136.
IF SUBSTR(PSA,1,2)='06'  mPSA= -.142.
IF SUBSTR(PSA,1,2)='07'  mPSA= -.271.
IF SUBSTR(PSA,1,2)='08'  mPSA= -.077.
IF SUBSTR(PSA,1,2)='09'  mPSA= -.121.
IF SUBSTR(PSA,1,2)='10'  mPSA= -.155.


***** DEMENTIA FACTOR.
COMPUTE mDEMENT=0.
	IF DEMENT='Y'  mDEMENT=.050.

**** ADL TRANSFER FACTOR.
COMPUTE mTRANSFER=0.
IF ADL_TRAN=4 mTRANSFER= .075.


**** IADL MONEY FACTOR..
COMPUTE mMONEY=0.
IF IADL_MON=4 mMONEY= .031.

**** IADL SHOPPING FACTOR.
COMPUTE mSHOP=0.
IF IADL_SHP=4 mSHOP=.026.


**** CANCER FACTOR.
COMPUTE mCANCER=0.
IF CANCER_OTH='Y' mCANCER= -.029.

**** CAREGIVER FACTOR.
COMPUTE mCGIVER=0.
IF CAREGIVER='Y' mCGIVER=.044.

**** DIALYSIS FACTOR.
COMPUTE mDIALYSIS=0.
IF DIALYSIS='Y' mDIALYSIS=.111.

*** SPEECH THERAPY FACTOR.
COMPUTE mSPEECHT=0.
IF SPEECH_THER='Y' mSPEECHT= -.104.

*** PHYSICAL THERAPY FACTOR.
COMPUTE mPHYT=0.
IF PHYSICAL_THERAPY='Y' mPHYT=-.027.

EXECUTE .

COMPUTE ARF2=0.
COMPUTE ARF2 = mINTERCEPT + mLIVINGARR + mPSA + mDEMENT + mTRANSFER + mMONEY + mSHOP + mCANCER + mCGIVER + mDIALYSIS +  mSPEECHT +  mPHYT.
EXECUTE .




*****************************************************************.
*****************************************************************.
*****************************************************************.
*****************************************************************.
*****************************************************************.
*****************************************************************.
*****************************************************************.
**** CALCULATE CLIENT ASSESSMENT RATING  FACTOR (VERSION 1).


COMPUTE ARF=1.
COMPUTE ARF_MB=1.
COMPUTE ARF_DMT=1.
COMPUTE ARF_DIA=1.
COMPUTE ARF_RES=1.
COMPUTE ARF_INC=1.
COMPUTE ARF_ADL=1.
COMPUTE ARF_MED=1.
EXECUTE.




***** MEDICIARE PART B.
	COMPUTE ARF_MB=1.

***** DEMENTIA FACTOR.
	IF DEMENT='Y' ARF_DMT=1.076.

**** DIABETES FACTOR.
	IF DIABE='Y' ARF_DIA=1.120.

**** RESIDENCE FACTOR.
	IF  LIVING_ARRANGE='PRRE'  ARF_RES=.669.

**** INCONTINECE FACTOR.
	IF ltrim(rtrim(INCONT))='Y' ARF_INC=1.092.

**** ADL LEVEL 4 or Higher Factor.
          COMPUTE ADL1AST=1.	
          COMPUTE ADL2AST=1.	
          COMPUTE ADL3AST=1.	
          COMPUTE ADL4AST=1.	
          COMPUTE ADL5AST=1.	
          COMPUTE ADL6AST=1.	
        EXECUTE.

 	IF ADL_BATH>=4 ADL1AST=1.027.
 	IF ADL_DRES>=4 ADL2AST=1.027.
 	IF ADL_EAT>=4 ADL3AST=1.027.
 	IF ADL_TOIL>=4 ADL4AST=1.027.
 	IF ADL_TRAN>=4 ADL5AST=1.027.
 	IF ADL_WALK>=4 ADL6AST=1.027.

	EXECUTE.


**** MEDICATION IADL FACTOR.
	IF iadl_med>=2 ARF_MED=1.056.
            EXECUTE.

**** CALCULATE OVERALL ASSESSMENT RATING FACTOR (ARF).
COMPUTE ARF=ARF_MB*ARF_DMT*ARF_DIA*ARF_RES*ARF_INC*ADL1AST*ADL2AST*ADL3AST*ADL4AST*ADL5AST*ADL6AST*ARF_MED.


	EXECUTE.

SORT CASES BY SSN(A).

SAVE OUTFILE='C:\Documents and Settings\user\Desktop\EdNeuRates2013\ARF1 ARF2 MASTER.sav'
 /COMPRESSED.

SAVE OUTFILE='C:\Documents and Settings\user\Desktop\EdNeuRates2013\ARF_2013.sav'
  /KEEP=SSN ARF ARF2
  /COMPRESSED.


SAVE TRANSLATE OUTFILE='C:\Documents and Settings\user\Desktop\EdNeuRates2013\ARF_2013.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES
   /KEEP=SSN ARF ARF2