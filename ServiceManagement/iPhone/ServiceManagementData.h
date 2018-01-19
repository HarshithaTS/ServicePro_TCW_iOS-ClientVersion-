//
//  ServiceManagementData.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 25/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface ServiceManagementData : NSObject {

	//Database instance and database names
	sqlite3 *database;
	NSString *serviceReportsDB;
	NSString *serviceOrderConfirmationListingDB;
    NSString *gssSystemDB;
	NSMutableArray *errorlistArray;
    NSMutableArray *taskStatusMaster;
    NSMutableArray *taskStatusMappingArray;
    NSMutableArray *taskStatusTxtArray;
    NSMutableArray *taskResultTxtArray;
    NSMutableArray *taskResultTypeTxtArray;
    
    NSMutableDictionary *taskStatusMaster_temp;
      
    //**************************************************************************************
    //*
    //*                   Start- Service Order
    //*
    //*
    //**************************************************************************************

	//Task list related arrays..., storing the table names in 'dataTypeArray' and rest arrys for table filed names
	NSArray *dataTypeArray;
	NSArray *ZGSCSMST_SRVCDCMNT01FiledArray;
	NSArray *ZGSCSMST_SRVCACTVTYLIST10FiledArray;
	NSArray *ZGSCSMST_CAUSECODELIST10FiledArray;
	NSArray *ZGSCSMST_CAUSECODEGROUPLIST10FiledArray;
	NSArray *ZGSCSMST_PRBLMCODELIST10FiledArray;
	NSArray *ZGSCSMST_PRBLMCODEGROUPLIST10FiledArray;
	NSArray *ZGSCSMST_SYMPTMCODELIST10FiledArray;
	NSArray *ZGSCSMST_SYMPTMCODEGROUPLIST10FiledArray;
	NSArray *ZGSCSMST_EMPLYMTRLLIST10FiledArray;
	

	
	//Task list array where keeping all the task and 'taskDataDictionary' mainly used in EditTask page.. to hold the data while editing..
	NSMutableArray *taskListArray;	
	NSMutableDictionary  *taskDataDictionary;
	NSMutableArray *activityListArray;
	NSMutableArray *activityListArrayPicker;
	NSMutableArray *materialListArray;
	NSMutableArray *materialListArrayPicker;
	
	//EditTaskId, after cliking on task list, which task is selected for Edit..
	NSString *editTaskId;
    NSString *itemId;
	
	//store Objectiv Id 
	NSString *objectiveID;
	NSString *SymptomGroupCode;
	NSString *ProblemGroupCode;
	NSString *CauseGroupCode;
	NSString *SymptomListCode;
	NSString *ProblemListCode;
	NSString *CauseListCode;
	NSString *FaultResultCode;
	NSString *FaultResultText;
	NSString *MatResultText;
	NSString *NUMBER_EXT;
	NSString *ACTIVITY_NUMBER_EXT;
	NSInteger SRVCACTVTY10ID;
	BOOL faultEditFlag;
	BOOL spareAddFlag;
    //**************************************************************************************
    //*
    //*                   End- Service Order
    //**************************************************************************************

	
    //**************************************************************************************
    //*
    //*                   Start- Service Confirmation
    //*
    //*
    //**************************************************************************************


    
	//Selected row in service confirmation activation creation
	NSInteger selectedRowIndex;
	
	
	//Service confirmation related arrays..'serviceOrderConfirmationListingDataTypeArray' storing table names, rest are table filed names..
	NSArray *serviceOrderConfirmationListingDataTypeArray;
	NSArray *ZGSCSMST_SRVCACTVTY10FiledArray;
	NSArray *ZGSCSMST_SRVCSPARE10FiledArray;
	NSArray *ZGSCSMST_SRVCCNFRMTN12FiledArray;
	
	
	//Service Cofirmation Creation
	NSArray *serviceOrderConfirmationCreationDataTypeArray;

	NSArray *ZGSCSMST_SRVCCNFRMTN20FeildArray;
	NSArray *ZGSCSMST_SRVCCNFRMTNACTVTY20FeildArray;
	NSArray *ZGSCSMST_SRVCCNFRMTNFAULT20FeildArray;
	NSArray *ZGSCSMST_SRVCCNFRMTNMTRL20FeildArray;
	//Service confirmation response
	NSArray *Z_GSCBTMI_ORDER21FeildArray;
	
   	
	//taken individula arrayes for service order activty, conformation, and sparce.. these arrys are fill-up from SAP, donwloding data in ServiveOrders.m file 
	
	BOOL updatedActivityArrayFlag;
	NSMutableArray *ActivityArray;
	NSMutableArray *serviceOrderActivityArray;
    NSMutableArray *serviceOrderSelectedActivityArray;
    NSMutableArray *serviceOrderActivityTempArray;
	NSMutableArray *serviceOrderConfirmationArray;
	NSMutableArray *serviceOrderSpareArray;
    NSMutableArray *serviceOrderSapreTempArray;
	NSMutableArray *serviceConfirmationFaultArray;
	
	NSMutableArray *faultSymtmCodeGroupArray;
	NSMutableArray *faultSymtmCodeGroupArrayPicker;
	NSMutableArray *faultSymtmCodeListArray;
	NSMutableArray *faultSymtmCodeListArrayPicker;
	
	NSMutableArray *faultPrblmCodeGroupArray;
	NSMutableArray *faultPrblmCodeGroupArrayPicker;
	NSMutableArray *faultPrblmCodeListArray;
	NSMutableArray *faultPrblmCodeListArrayPicker;

	
	NSMutableArray *faultCauseCodeGroupArray;
	NSMutableArray *faultCauseCodeGroupArrayPicker;
	NSMutableArray *faultCauseCodeListArray;
	NSMutableArray *faultCauseCodeListArrayPicker;
	
	NSMutableArray *faultAllDataArray;
	NSMutableDictionary *faultDataDictionary;
    NSMutableDictionary *SpareDataDictionary;
    //**************************************************************************************
    //*                   End- Service Confirmation
    //**************************************************************************************

    
    
    //**************************************************************************************
    //*                         Start colleague
    //*
    //*
    //*
    //**************************************************************************************
    //Database table field array
    NSArray *ZGSCSMST_EMPLY01FeildArray;
    NSArray *ZGSCSMST_SRVCDCMNT01_COLLEAGUEFeildArray;
    NSMutableArray *colleagueListArray;

    
    NSMutableArray *colleagueTaskListArray;	
	NSMutableDictionary  *colleagueTaskDataDictionary;

    //**************************************************************************************
    //*                          End colleague
    //**************************************************************************************
	
    
    //**************************************************************************************
    //*                         Start Completed Order
    //*
    //*
    //*
    //**************************************************************************************
   
    //Completed Order-selvan
	NSArray *cDataTypeArray;
	NSArray *sortedArrayList;
	NSArray *ZGSCSMST_SRVCRPRTDATA10FieldArray;	
	NSInteger taskId;
    //**************************************************************************************
    //*                          End Completed Order
    //**************************************************************************************
NSMutableArray *serviceAttachment;

}

@property (nonatomic, retain) NSMutableArray *errorlistArray;

@property (nonatomic, retain) NSString *serviceReportsDB;
@property (nonatomic, retain) NSString *serviceOrderConfirmationListingDB;
@property (nonatomic, retain) NSString *gssSystemDB;

@property (nonatomic, retain) NSArray *dataTypeArray;
@property (nonatomic, retain) NSMutableArray *taskStatusMaster;
@property (nonatomic, retain) NSMutableDictionary *taskStatusMaster_temp;

@property (nonatomic, retain) NSMutableArray *taskStatusMappingArray;
@property (nonatomic, retain) NSMutableArray *taskStatusTxtArray;
@property (nonatomic, retain) NSMutableArray *taskResultTxtArray;
@property (nonatomic, retain) NSMutableArray *taskResultTypeTxtArray;
@property (nonatomic, retain) NSMutableArray *taskSetTypeArray;       // Added on sep 27 2016
//**************************************************************************************
//*
//*                   Start- Service Order
//*
//*
//**************************************************************************************





@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCDCMNT01FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCACTVTYLIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_CAUSECODELIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_CAUSECODEGROUPLIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_PRBLMCODELIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_PRBLMCODEGROUPLIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SYMPTMCODELIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SYMPTMCODEGROUPLIST10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_EMPLYMTRLLIST10FiledArray;

@property (nonatomic, retain) NSMutableArray *materialListArrayPicker;
@property (nonatomic, retain) NSMutableArray *materialListArray;
@property (nonatomic, retain) NSMutableArray *activityListArrayPicker;
@property (nonatomic, retain) NSMutableArray *activityListArray;
@property (nonatomic, retain) NSMutableArray *taskListArray;
@property (nonatomic, retain) NSMutableDictionary  *taskDataDictionary;
@property (nonatomic,retain) NSString *editTaskId;
@property (nonatomic,retain) NSString *itemId;

@property (nonatomic, retain) NSString *objectiveID;
@property (nonatomic, retain) NSString *SymptomGroupCode;
@property (nonatomic, retain) NSString *ProblemGroupCode;
@property (nonatomic, retain) NSString *CauseGroupCode;
@property (nonatomic, retain) NSString *SymptomListCode;
@property (nonatomic, retain) NSString *ProblemListCode;
@property (nonatomic, retain) NSString *CauseListCode;
@property (nonatomic,retain) NSString *FaultResultCode;
@property (nonatomic, retain) NSString *FaultResultText;
@property (nonatomic, retain) NSString *MatResultText;
@property (nonatomic, retain) NSString *NUMBER_EXT;
@property (nonatomic, retain) NSString *ACTIVITY_NUMBER_EXT;
@property (nonatomic) NSInteger SRVCACTVTY10ID;
@property (nonatomic) BOOL faultEditFlag;
@property (nonatomic) BOOL spareAddFlag;



@property (nonatomic) NSInteger selectedRowIndex;
@property (nonatomic) BOOL updatedActivityArrayFlag;
@property (nonatomic, retain) NSArray *serviceOrderConfirmationListingDataTypeArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCACTVTY10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCSPARE10FiledArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCCNFRMTN12FiledArray;

@property (nonatomic, retain) NSMutableArray *ActivityArray;
@property (nonatomic, retain) NSMutableArray *serviceOrderActivityArray;
@property (nonatomic, retain) NSMutableArray *serviceOrderSelectedActivityArray;
@property (nonatomic, retain) NSMutableArray *serviceOrderActivityTempArray;
@property (nonatomic, retain) NSMutableArray *serviceOrderConfirmationArray;
@property (nonatomic, retain) NSMutableArray *serviceOrderSpareArray;
@property (nonatomic, retain) NSMutableArray *serviceOrderSpareTempArray;
@property (nonatomic, retain) NSMutableArray *serviceConfirmationFaultArray;
//**************************************************************************************
//*                   End- Service Order
//**************************************************************************************

//**************************************************************************************
//*
//*                   Start- Service Confirmation
//*
//*
//**************************************************************************************
@property (nonatomic, retain) NSArray *serviceOrderConfirmationCreationDataTypeArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCCNFRMTN20FeildArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCCNFRMTNACTVTY20FeildArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCCNFRMTNFAULT20FeildArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCCNFRMTNMTRL20FeildArray;

//Service Confirmation response

@property (nonatomic, retain) NSArray *Z_GSCBTMI_ORDER21FeildArray;

@property (nonatomic, retain) NSMutableArray *serviceAttachment;



-(void)fetchAndUpdateServiceOrderActivity:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchAndUpdateServiceOrderConfirmation:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchAndUpdateServiceOrderSpare:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchServiceOrderSpareTemp:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchServiceOrderActivityTemp:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchMaterialList:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchActivityList:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchFaultCauseGroup:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchFaultProblemGroup:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchFaultSymptomGroup:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchFaultCauseList:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchFaultProblemList:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchFaultSymptomList:(NSString *)passedQuery:(NSInteger)arrayIndex;

-(void)fetchAndUpdateConfirmationFaultData:(NSString *)passedQuery:(NSInteger)arrayIndex;
//**************************************************************************************
//*                   End- Service Confirmation
//**************************************************************************************


//**************************************************************************************
//*                         Start Completed Order
//*
//*
//*
//**************************************************************************************

@property (nonatomic, retain) NSArray *sortedArrayList;
@property (nonatomic, retain) NSArray *cDataTypeArray;
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCRPRTDATA10FieldArray;

@property (nonatomic, retain) NSMutableArray *faultSymtmCodeGroupArray;
@property (nonatomic, retain) NSMutableArray *faultSymtmCodeGroupArrayPicker;
@property (nonatomic, retain) NSMutableArray *faultSymtmCodeListArray;
@property (nonatomic, retain) NSMutableArray *faultSymtmCodeListArrayPicker;

@property (nonatomic, retain) NSMutableArray *faultPrblmCodeGroupArray;
@property (nonatomic, retain) NSMutableArray *faultPrblmCodeGroupArrayPicker;
@property (nonatomic, retain) NSMutableArray *faultPrblmCodeListArray;
@property (nonatomic, retain) NSMutableArray *faultPrblmCodeListArrayPicker;

@property (nonatomic, retain) NSMutableArray *faultCauseCodeGroupArray;
@property (nonatomic, retain) NSMutableArray *faultCauseCodeGroupArrayPicker;
@property (nonatomic, retain) NSMutableArray *faultCauseCodeListArray;
@property (nonatomic, retain) NSMutableArray *faultCauseCodeListArrayPicker;

@property (nonatomic, retain) NSMutableArray *faultAllDataArray;
@property (nonatomic, retain) NSMutableDictionary *faultDataDictionary;
@property (nonatomic, retain) NSMutableDictionary *SpareDataDictionary;

@property (nonatomic) NSInteger taskId;
//**************************************************************************************
//*                          End Completed Order
//**************************************************************************************

//**************************************************************************************
//*                         Start colleague
//*
//*
//*
//**************************************************************************************
//Get Service Colleague List - Database table field array
@property (nonatomic, retain) NSArray *ZGSCSMST_EMPLY01FeildArray;
@property (nonatomic, retain) NSMutableArray *colleagueListArray;





//Get Service Order by Colleague
@property (nonatomic, retain) NSArray *ZGSCSMST_SRVCDCMNT01_COLLEAGUEFeildArray;
@property (nonatomic, retain) NSMutableArray *colleagueTaskListArray;
@property (nonatomic, retain) NSMutableDictionary  *colleagueTaskDataDictionary;
//**************************************************************************************
//*                          End colleague
//**************************************************************************************



@property (nonatomic,retain) NSString *partnerTaskID;
@property (nonatomic,retain) NSString *partnerTaskItem;



//Queue
@property (nonatomic,retain) dispatch_group_t Task_Group;
@property (nonatomic,retain) dispatch_queue_t Main_Queue;
@property (nonatomic,retain) dispatch_queue_t Concurrent_Queue_High;
@property (nonatomic,retain) dispatch_queue_t Concurrent_Queue_Default;
@property (nonatomic,retain) dispatch_queue_t Concurrent_Queue_Low;


//Diagnose
@property (nonatomic, retain) NSMutableArray *diagonseArray;


//Service Note
@property (nonatomic, retain) NSString *serviceNote;
@property (nonatomic, retain) NSString *serviceNoteViewTitle;


+(ServiceManagementData *)sharedManager;


-(void) dailNumber2;
-(void) dailNumber1;

-(BOOL)createEditableCopyOfDatabaseIfNotThere:(NSString *)DBName;
-(BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString *)DBName;
-(NSString *)documentDirectoryServiceManagemenetDBPath:(NSString *)DBName;
-(BOOL)insertDataIntoServiceManagemenetDB:(NSString *)passedQuery:(NSString *)DBName;
-(BOOL)excuteSqliteQryString:(NSString *)_qryStr Database:(NSString *)_dbName Description:(NSString *)_desc Option:(NSInteger)_optn;
-(BOOL)excuteSqliteQryString:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn;

-(NSMutableArray *)fetchDataFrmSqlite:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn;
-(NSMutableArray *)fetchDataFrmSqlite_v2:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn;
-(BOOL)updateDataIntoSqlite:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn;

-(int)fetchTotalRecordsCount:(NSString *)DBName:(NSString *)tableName;
-(void)fetchAndUpdateTaskList:(NSString *)passedQuery:(NSInteger )arrayIndex;
-(BOOL)updateTaskList:(NSString *)passedQuery;
-(BOOL)updateConfirmationDB:(NSString *)passedQuery;
-(void)deleteDataFromServiceManagmentDB:(NSString *)passedQuery;


-(void)fetchAndUpdateCompletedTaskList:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchColleagueList:(NSString *)passedQuery:(NSInteger)arrayIndex;
-(void)fetchColleagueTaskList:(NSString *)passedQuery:(NSInteger)arrayIndex;
@end
