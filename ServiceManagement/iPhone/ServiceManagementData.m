//
//  ServiceManagementData.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 25/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceManagementData.h"
#import "sqlite3.h"
#import "CurrentDateTime.h"
#import "AppDelegate_iPhone.h"
static ServiceManagementData *sharedManager;
//CurrentDateTime *objCurrentDateTime;


@implementation ServiceManagementData



//Service Order Task Listing and Editing
@synthesize serviceReportsDB;
@synthesize serviceOrderConfirmationListingDB;
@synthesize gssSystemDB;
@synthesize errorlistArray;
@synthesize taskStatusMaster;
@synthesize taskStatusMappingArray;
@synthesize taskStatusTxtArray;
@synthesize taskStatusMaster_temp;
@synthesize taskResultTxtArray;
@synthesize taskResultTypeTxtArray;
@synthesize taskSetTypeArray;       //Added on sep 27 2016

@synthesize dataTypeArray;
@synthesize  ZGSCSMST_SRVCDCMNT01FiledArray;
@synthesize  ZGSCSMST_SRVCACTVTYLIST10FiledArray;
@synthesize  ZGSCSMST_CAUSECODELIST10FiledArray;
@synthesize  ZGSCSMST_CAUSECODEGROUPLIST10FiledArray;
@synthesize  ZGSCSMST_PRBLMCODELIST10FiledArray;
@synthesize  ZGSCSMST_PRBLMCODEGROUPLIST10FiledArray;
@synthesize  ZGSCSMST_SYMPTMCODELIST10FiledArray;
@synthesize  ZGSCSMST_SYMPTMCODEGROUPLIST10FiledArray;
@synthesize  ZGSCSMST_EMPLYMTRLLIST10FiledArray;

@synthesize materialListArrayPicker;
@synthesize materialListArray;
@synthesize activityListArray;
@synthesize activityListArrayPicker;
@synthesize taskListArray;
@synthesize taskDataDictionary;
@synthesize editTaskId;
@synthesize selectedRowIndex;
@synthesize NUMBER_EXT;
@synthesize ACTIVITY_NUMBER_EXT;
@synthesize SRVCACTVTY10ID;
@synthesize faultEditFlag;
@synthesize spareAddFlag;

@synthesize objectiveID;
@synthesize SymptomGroupCode;
@synthesize ProblemGroupCode;
@synthesize CauseGroupCode;

@synthesize SymptomListCode;
@synthesize ProblemListCode;
@synthesize CauseListCode;

@synthesize FaultResultCode;
@synthesize FaultResultText;

@synthesize MatResultText;

//Service Order Confirmation Listing 
@synthesize serviceOrderConfirmationListingDataTypeArray;
@synthesize ZGSCSMST_SRVCACTVTY10FiledArray;
@synthesize ZGSCSMST_SRVCSPARE10FiledArray;
@synthesize ZGSCSMST_SRVCCNFRMTN12FiledArray;

@synthesize ActivityArray;
@synthesize serviceOrderActivityArray;
@synthesize serviceOrderSelectedActivityArray;
@synthesize serviceOrderActivityTempArray;
@synthesize serviceOrderConfirmationArray;
@synthesize serviceOrderSpareArray;
@synthesize serviceOrderSpareTempArray;
@synthesize serviceConfirmationFaultArray;


//Service Cofirmation Creation
@synthesize updatedActivityArrayFlag;
@synthesize serviceOrderConfirmationCreationDataTypeArray;
@synthesize ZGSCSMST_SRVCCNFRMTN20FeildArray;
@synthesize ZGSCSMST_SRVCCNFRMTNACTVTY20FeildArray;
@synthesize ZGSCSMST_SRVCCNFRMTNFAULT20FeildArray;
@synthesize ZGSCSMST_SRVCCNFRMTNMTRL20FeildArray;

//Service Confirmation Response
@synthesize Z_GSCBTMI_ORDER21FeildArray;


//Completed Tasks Listing and details - selvan
@synthesize cDataTypeArray;
@synthesize sortedArrayList;
@synthesize ZGSCSMST_SRVCRPRTDATA10FieldArray;	
@synthesize taskId;


//Fault Code
@synthesize faultSymtmCodeGroupArray;
@synthesize faultSymtmCodeGroupArrayPicker;
@synthesize faultSymtmCodeListArray;
@synthesize faultSymtmCodeListArrayPicker;
@synthesize faultPrblmCodeGroupArray;
@synthesize faultPrblmCodeGroupArrayPicker;
@synthesize faultPrblmCodeListArray;
@synthesize faultPrblmCodeListArrayPicker;
@synthesize faultCauseCodeGroupArray;
@synthesize faultCauseCodeGroupArrayPicker;
@synthesize faultCauseCodeListArray;
@synthesize faultCauseCodeListArrayPicker;

@synthesize faultAllDataArray;
@synthesize faultDataDictionary;
@synthesize SpareDataDictionary;


//Get Colleague list
@synthesize  ZGSCSMST_EMPLY01FeildArray;
@synthesize ZGSCSMST_SRVCDCMNT01_COLLEAGUEFeildArray;
@synthesize colleagueListArray;
@synthesize colleagueTaskListArray;
@synthesize colleagueTaskDataDictionary;

//-------end--------


@synthesize serviceAttachment;



@synthesize partnerTaskItem;
@synthesize partnerTaskID;



//--------------------queue-------------------
@synthesize Task_Group;
@synthesize Main_Queue;
@synthesize Concurrent_Queue_High;
@synthesize Concurrent_Queue_Default;
@synthesize Concurrent_Queue_Low;


//------------------Diagnose------------------
@synthesize diagonseArray;


//Service Note
@synthesize serviceNote;
@synthesize serviceNoteViewTitle;


//Shared function, creating a single ton instance for this class.
+(ServiceManagementData *)sharedManager
{		
	@synchronized(self)
	{
		if(!sharedManager)
			sharedManager = [[ServiceManagementData alloc] init];
	}
	
	return sharedManager;
}


-(id)init
{
	if(self = [super init])
	{
        
        
        //Block Execution Return from Gss_Webservice - End
        
        //#################################################################################################################################
        
        //Dispatch - Group / Queue - Intilization
        
        Task_Group = dispatch_group_create();
        
        Main_Queue = dispatch_get_main_queue();
        
        Concurrent_Queue_High = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
        Concurrent_Queue_Default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        Concurrent_Queue_Low = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0);

        //status
        
        //taskStatusMappingArray = [[[NSMutableArray alloc] init]autorelease];
        //taskStatusArray= [[[NSMutableArray alloc] init]autorelease];
        
        self.taskStatusMaster_temp = [[[NSMutableDictionary alloc] init]autorelease];
        self.taskStatusMappingArray = [[[NSMutableArray alloc] init] autorelease];
		//task list related arrays..
		self.taskListArray = [[[NSMutableArray alloc] init]autorelease];
		
		self.taskDataDictionary = [[[NSMutableDictionary alloc] init]autorelease];
		
		
        self.colleagueListArray = [[[NSMutableArray alloc] init]autorelease];
        self.colleagueTaskListArray = [[[NSMutableArray alloc] init]autorelease];
        self.colleagueTaskDataDictionary = [[[NSMutableDictionary alloc] init]autorelease];
		//objCurrentDateTime = [[[CurrentDateTime alloc] init]autorelease];
		
        
        self.diagonseArray = [[[NSMutableArray alloc] init] autorelease];
        
        
        self.gssSystemDB = @"gssSystemDB.sqlite";
        
		self.serviceReportsDB = @"ServiceReportsDB.sqlite";
        
        
		
		//Task list related, Table names
		self.dataTypeArray = [NSArray arrayWithObjects:
                         @"ZGSXSMST_SRVCDCMNT10",
						 @"ZGSXSMST_SRVCACTVTYLIST10",
						 @"ZGSXSMST_CAUSECODELIST10",
						 @"ZGSXSMST_CAUSECODEGROUPLIST10",
                              
						 @"ZGSXSMST_PRBLMCODELIST10",      
						 @"ZGSXSMST_PRBLMCODEGROUPLIST10",
						 @"ZGSXSMST_SYMPTMCODELIST10",
						 @"ZGSXSMST_SYMPTMCODEGROUPLIST10",
                              
						 @"ZGSXSMST_EMPLYMTRLLIST10",
						 @"ZGSCSMST_SRVCRPRTDATA10",
                         @"ZGSXCAST_EMPLY01", 
                         @"ZGSCSMST_SRVCDCMNT10_COLLEAGUE",
                              
                         @"SERVICE-DOX-TRANSFER",
                         @"ZGSXSMST_SRVCACTVTY10",
                         @"ZGSXSMST_SRVCSPARE10",
                         @"ZGSXSMST_SRVCCNFRMTN12",
                         
                          @"YTCCSMST_SRVCDCMNT10",nil];
		
	
		//Below 9 arays for table filed names...
        //CREATE TABLE ZGSCSMST_SRVCDCMNT01 (ZGSCSMST_SRVCDCMNT01Id INTEGER PRIMARY KEY, OBJECT_ID TEXT, PROCESS_TYPE TEXT, ZZKEYDATE TEXT, PARTNER TEXT, NAME_ORG1 TEXT, NAME_ORG2 TEXT, STRAS TEXT, ORT01 TEXT, REGIO TEXT, PSTLZ TEXT, LAND1 TEXT, STATUS TEXT, STATUS_TXT30 TEXT, STATUS_REASON TEXT, CP1_PARTNER TEXT, CP1_NAME1_TEXT TEXT, CP1_TEL_NO TEXT, CP1_TEL_NO2 TEXT, CP2_PARTNER TEXT, CP2_NAME1_TEXT TEXT, CP2_TEL_NO TEXT, CP2_TEL_NO2 TEXT, DESCRIPTION TEXT, PRIORITY TEXT, IB_IBASE TEXT, IB_INSTANCE TEXT, SERIAL_NUMBER TEXT, REFOBJ_PRODUCT_ID TEXT, IB_DESCR TEXT, IB_INST_DESCR TEXT, REFOBJ_PRODUCT_DESCR TEXT, TIMEZONE_FROM TEXT, ZZETADATE TEXT, ZZETATIME TEXT, PROCESS_TYPE_DESCR TEXT, NOTE TEXT, ZZFIRSTSERVICEPRODUCT TEXT, ZZFIRSTSERVICEPRODUCTDESCR TEXT);

		self.ZGSCSMST_SRVCDCMNT01FiledArray = [NSArray arrayWithObjects:@"OBJECT_ID",
										  @"PROCESS_TYPE",
										  @"ZZKEYDATE",
										  @"PARTNER",
										  @"NAME_ORG1",
										  @"NAME_ORG2",
										  @"STRAS",
										  @"ORT01", 
										  @"REGIO",
										  @"PSTLZ",
										  @"LAND1",
										  @"STATUS",
										  @"STATUS_TXT30",
										  @"STATUS_REASON",
										  @"CP1_PARTNER",
										  @"CP1_NAME1_TEXT",
										  @"CP1_TEL_NO",
										  @"CP1_TEL_NO2",
										  @"CP2_PARTNER",									  
										  @"CP2_NAME1_TEXT",
										  @"CP2_TEL_NO",
										  @"CP2_TEL_NO2",
										  @"DESCRIPTION",
										  @"PRIORITY",
										  @"IB_IBASE",
										  @"IB_INSTANCE",
										  @"SERIAL_NUMBER",							  
										  @"REFOBJ_PRODUCT_ID",
                                          @"IB_DESCR",
                                          @"IB_INST_DESCR",
                                          @"REFOBJ_PRODUCT_DESCR",
                                          @"TIMEZONE_FROM",
                                          @"ZZETADATE",
                                          @"ZZETATIME",
                                          @"PROCESS_TYPE_DESCR",
                                          @"NOTE",
                                          @"ZZFIELDNOTE",
                                          @"ZZFIRSTSERVICEPRODUCT",
                                          @"ZZFIRSTSERVICEPRODUCTDESCR",
                                          @"ZZFIRSTSERVICEITEM",
                                               nil];
        
        
   	
		
		
		
		//Service Order Confirmation Listing 
		self.serviceOrderConfirmationListingDB = @"ServiceOrderConfirmationListingDB.sqlite";
		self.serviceOrderActivityArray = [[NSMutableArray alloc] init];
	
	}
	
	return self;
}

//calling while trying to back Service Orders (Task) list page
-(void) dailNumber2
{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    NSString *telphone = [NSString stringWithFormat:@"tel:%@",delegate.colleagueTelNo];
    
    
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telphone]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }
}
//calling while trying to back Service Orders (Task) list page
-(void) dailNumber1
{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    NSString *telphone2 = [NSString stringWithFormat:@"tel:%@",delegate.colleagueTelNo2];
    
    
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telphone2]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }
}
//Returning the device document directory path..
-(NSString *)documentDirectoryServiceManagemenetDBPath:(NSString *)DBName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	NSString *path = [documentPath stringByAppendingPathComponent:DBName];
	return path;
}


//Checking the DB is present or not in device document folder, is not present copy the blank DB from application bundle to document folder...
//if  present then remove the older and copy new one and insert data from SAP..
//or you can do both...depends on the requirement..
-(BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString *)DBName {
	
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DBName];
    success = [fileManager fileExistsAtPath:writableDBPath];

	if(success)
	{
		if([fileManager isDeletableFileAtPath:writableDBPath])
		{
			success = [fileManager removeItemAtPath:writableDBPath error:&error];
		}
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	}
	else 
    {
        if(!success)
        {
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        }
        else
			NSLog(@"Database already exists");	
	
  
	}
	return success;
}


-(BOOL)createEditableCopyOfDatabaseIfNotThere:(NSString *)DBName {
	
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DBName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    else
        NSLog(@"Database already exists");
    
	return success;
}
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************
//Optimized sqlite db layer -  written by selvan
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************

//Inserting data in Sqlite, for the task list array...
-(BOOL)insertDataIntoServiceManagemenetDB:(NSString *)passedQuery:(NSString *)DBName{
	
	BOOL returnFlag = TRUE;
    
	@try {
		
		sqlite3_stmt *sqlStatement = nil;
		
		if(sqlStatement == nil)
		{
			if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:DBName] UTF8String],&database) == SQLITE_OK)
			{
				const char *sqlQuery= [[NSString stringWithFormat:@"%@",passedQuery] UTF8String];
				
				if(sqlite3_prepare_v2(database, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
				{
					returnFlag = FALSE;
				}
			}
		}
        
		if(SQLITE_DONE != sqlite3_step(sqlStatement))
			returnFlag = FALSE;
		else {
			sqlite3_last_insert_rowid(database);
		}
        
		
		sqlite3_reset(sqlStatement);
		sqlite3_close(database);
		
	}
	@catch (NSException * e) {
		returnFlag = FALSE;
	}	
	
	return returnFlag;
}

//Execute all sqlite query
-(BOOL)excuteSqliteQryString:(NSString *)_qryStr Database:(NSString *)_dbName Description:(NSString *)_desc Option:(NSInteger)_optn

{
	
    
    BOOL returnFlag = TRUE;
	
	@try {
		sqlite3_stmt *stmt = nil;
		
		if(stmt == nil)
		{
			if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:_dbName] UTF8String],&database) == SQLITE_OK)
			{
				const char *sqlQuery = [_qryStr UTF8String];
				if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) != SQLITE_OK)
					returnFlag = FALSE;
			}
		}
		
		if(SQLITE_DONE != sqlite3_step(stmt))
			returnFlag = FALSE;
		
		sqlite3_reset(stmt);
        sqlite3_close(database);
	}
	@catch (NSException *e){
		NSLog(@"Exception=%@",e);
		returnFlag = FALSE;
	}
	
	
	return returnFlag;
}

//Execute all sqlite query
-(BOOL)excuteSqliteQryString:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn{
	BOOL returnFlag = TRUE;
	
	@try {		
		sqlite3_stmt *stmt = nil;	
		
		if(stmt == nil)
		{
			if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:_dbName] UTF8String],&database) == SQLITE_OK)
			{
				const char *sqlQuery = [_qryStr UTF8String];  			
				if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) != SQLITE_OK) 
					returnFlag = FALSE;		
			}
		}
		
		if(SQLITE_DONE != sqlite3_step(stmt))
			returnFlag = FALSE;
		
		sqlite3_reset(stmt);		
	}
	@catch (NSException *e){
		NSLog(@"Exception=%@",e);
		returnFlag = FALSE;
	}
	
	
	return returnFlag;
}
// Get Data from sqlite database and store it into target array
//_qryStr = Query String
//_dbName = Database Name
//_desc = description about what data are you fetching like that...
//_optn = Option
-(NSMutableArray *)fetchDataFrmSqlite:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn{
    
    NSMutableArray *rsltAry = [[[NSMutableArray alloc] init] autorelease];
    
    // @try {
    CurrentDateTime *objCurrentDateTime =[[[CurrentDateTime alloc] init] autorelease];
    
    if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:_dbName] UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlQuery = [_qryStr UTF8String];
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                NSInteger _clmnCnt = 0;
                NSString *_clmnName=@"";
                NSString *_clmnText=@"";
                NSString *_srchStr=@"";
                
                _clmnCnt = sqlite3_column_count(stmt);
                
                for (int _rCnt=0; _rCnt < _clmnCnt; _rCnt++) {
                    
                    _clmnName = [NSString stringWithFormat:@"%s",(char*) sqlite3_column_name(stmt, _rCnt)];
                    _clmnText = [NSString stringWithFormat:@"%s",(char*) sqlite3_column_text(stmt, _rCnt)];
                    [tempDic setObject:_clmnText forKey:_clmnName];
                    
                    //NSLog(@"%@ : %@ -> %@",_desc,_clmnName, _clmnText);
                    //Create search string
                    _srchStr = [_srchStr stringByAppendingString:_clmnText];
                    
                }
                
                //Inserting search string in to dictionary..
                [tempDic setObject:_srchStr forKey:@"SEARCH_STRING"];
                
                
                //NSLog(@"temp dic %@",tempDic);
                //*********
                if ([_desc isEqualToString:@"SERVICE ORDER"]) {
                   
                    
                    //selvan added this code on 06/02/2013
                    
                    [tempDic setObject:[tempDic objectForKey:@"ZZETADATE"] forKey:@"ETADATE"];
                   
                        if (![[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"] &&  ![[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
                        {
                
                            [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat: [tempDic objectForKey:@"ZZETADATE"]] forKey:@"ZZETADATE"];
                        }
                        else
                            [tempDic setObject:@"" forKey:@"ZZETADATE"];
                    
                 
                    
                        if ([[tempDic objectForKey:@"ZZETATIME"] isEqualToString:@"00:00:00"] && [[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
                            
                            [tempDic setObject:@"" forKey:@"ZZETATIME"];
                    
                    //Convert date to 12 Jul, 2012 format,
                  
                    [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat1: [tempDic objectForKey:@"ZZKEYDATE"]] forKey:@"DISPLAY_DUE_DATE"];
                    [tempDic setObject: [tempDic objectForKey:@"ZZKEYDATE"] forKey:@"DATE"];
                        [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat: [tempDic objectForKey:@"ZZKEYDATE"]] forKey:@"ZZKEYDATE"];
                    
                    
                    [tempDic setObject:[NSString stringWithFormat:@"%@ %@",[tempDic objectForKey:@"NAME_ORG1"],[tempDic objectForKey:@"NAME_ORG2"]] forKey:@"ORG_CUST_NAME"];
                    
                    
                    [tempDic setObject:[NSString stringWithFormat:@"%@ %@",[tempDic objectForKey:@"OBJECT_ID"],[tempDic objectForKey:@"ZZFIRSTSERVICEITEM"]] forKey:@"SORT_OBJECT_ID"];
                    

                        
                    
                }
                
                //***************
                
                [rsltAry addObject:tempDic];
                [tempDic release], tempDic = nil;
            }
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        //[objCurrentDateTime release],objCurrentDateTime=nil;
    }
    return rsltAry;
	//}
	//@catch (NSException * e) {
	//	NSLog(@"Exception=%@",e);
	//}
    
}
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************
//Optimized sqlite db layer -  written by selvan  - END
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************

// Get Data from sqlite database and store it into target array
//_qryStr = Query String
//_dbName = Database Name
//_desc = description about what data are you fetching like that...
//_optn = Option
-(NSMutableArray *)fetchDataFrmSqlite_v2:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn{
    
    NSLog(@"qUERY : %@", _qryStr);
    NSMutableArray *rsltAry = [[[NSMutableArray alloc] init] autorelease];
    
    // @try {
    
    if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:_dbName] UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlQuery = [_qryStr UTF8String];
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                NSInteger _clmnCnt = 0;
                NSString *_clmnText=@"";
                
                _clmnCnt = sqlite3_column_count(stmt);
                
                for (int _rCnt=0; _rCnt < _clmnCnt; _rCnt++) {
                    
                    _clmnText = [NSString stringWithFormat:@"%s",(char*) sqlite3_column_text(stmt, _rCnt)];

                    [rsltAry addObject:_clmnText];
                }
                
            }
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    return rsltAry;
	//}
	//@catch (NSException * e) {
	//	NSLog(@"Exception=%@",e);
	//}
    
}
//***************************************************************************************************************************************************
//

// Get Data from sqlite database and store it into target array
//_qryStr = Query String
//_dbName = Database Name
//_desc = description about what data are you fetching like that...
//_optn = Option
-(NSMutableArray *)fetchDataFrmSqlite_New:(NSString *)_qryStr:(NSString *)_dbName:(NSString *)_desc:(NSInteger)_optn{
    NSMutableArray *rsltAry = [[[NSMutableArray alloc] init] autorelease];
    
    // @try {
    
    CurrentDateTime *objCurrentDateTime =[[[CurrentDateTime alloc] init] autorelease];
    
    if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:_dbName] UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlQuery = [_qryStr UTF8String];
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                NSInteger _clmnCnt = 0;
                NSString *_clmnName=@"";
                NSString *_clmnText=@"";
                NSString *_srchStr=@"";
                
                _clmnCnt = sqlite3_column_count(stmt);
                
                for (int _rCnt=0; _rCnt < _clmnCnt; _rCnt++) {
                    
                    _clmnName = [NSString stringWithFormat:@"%s",(char*) sqlite3_column_name(stmt, _rCnt)];
                    _clmnText = [NSString stringWithFormat:@"%s",(char*) sqlite3_column_text(stmt, _rCnt)];
                    [tempDic setObject:_clmnText forKey:_clmnName];
                    
                    
                    //NSLog(@"%@ : %@ -> %@",_desc,_clmnName, _clmnText);
                    
                    
                    //selvan added this code on 06/02/2013
                    if([_clmnName isEqualToString:@"ZZETADATE"])
                    {
                        if (![_clmnText isEqualToString:@"0000-00-00"])
                            
                            [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat: _clmnText] forKey:@"ZZETADATE"];
                        else
                            [tempDic setObject:@"" forKey:@"ZZETADATE"];
                    }
                    if([_clmnName isEqualToString:@"ZZETATIME"])
                    {
                        if ([_clmnText isEqualToString:@"00:00:00"] && [[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
                            
                            [tempDic setObject:@"" forKey:@"ZZETATIME"];
                    }
                    //Convert date to 12 Jul, 2012 format,
                    if([_clmnName isEqualToString:@"ZZKEYDATE"])
                    {
                        [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat: _clmnText] forKey:@"ZZKEYDATE"];
                        [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat1: _clmnText] forKey:@"DISPLAY_DUE_DATE"];
                        [tempDic setObject: _clmnText forKey:@"DATE"];
                    }
                    //***************SERVICE ORDER ACTIVITY LIST START*****************************************************************
                    //*******************************************************************************************************************
                    if([_clmnName isEqualToString:@"QUANTITY"] && _optn == 2 && [_desc isEqualToString:@"SOACTIVITY"]){
                        
                        [tempDic setObject:[NSString stringWithFormat:@"%@", @""] forKey:@"QUANTITY"];
                    }
                    
                    
                    if([_clmnName isEqualToString:@"QUANTITY"] && _optn == 2 && [_desc isEqualToString:@"SOACTIVITYTEMP"]){
                        [tempDic setObject:[NSString stringWithFormat:@"%@", @""] forKey:@"QUANTITY"];
                    }
                    
                    
                    
                    if([_clmnName isEqualToString:@"TIME_FROM"] && [_desc isEqualToString:@"SOACTIVITY"]) {
                        
                        NSString *mtempid = _clmnText;
                        
                        if([mtempid length] == 6) {
                            [tempDic setObject:[objCurrentDateTime currentdate] forKey:@"DATETIME_FROM"];
                            [tempDic setObject:[objCurrentDateTime currentdate] forKey:@"DATETIME_TO"];
                            [tempDic setObject:[objCurrentDateTime getDateFromString: [objCurrentDateTime currentdate]] forKey:@"DATE_FROM"];
                            [tempDic setObject:[objCurrentDateTime getDateFromString: [objCurrentDateTime currentdate]] forKey:@"DATE_TO"];
                            [tempDic setObject:[objCurrentDateTime getTimeFromString: [objCurrentDateTime currentdate]] forKey:@"TIME_FROM"];
                            [tempDic setObject:[objCurrentDateTime getTimeFromString: [objCurrentDateTime currentdate]] forKey:@"TIME_TO"];
                        }
                    }
                    
                    if([_clmnName isEqualToString:@"PRODUCT_ID"] && [_desc isEqualToString:@"SOACTIVITY"]) {
                        
                        [tempDic setObject: _clmnText forKey:@"ACTIVITYLIST"];
                        
                    }
                    //********************************************************************************************************************
                    //**************SERVICE ORDER ACITIVTY LIST END***********************************************************************
                    
                    
                    
                    
                    //Create search string
                    _srchStr = [_srchStr stringByAppendingString:_clmnText];
                    
                }
                
                //Inserting search string in to dictionary..
                [tempDic setObject:_srchStr forKey:@"SEARCH_STRING"];
                
                
                [rsltAry addObject:tempDic];
                
                if([_desc isEqualToString:@"ACTIVITY LIST MASTER DATA"]){
                    [self.activityListArrayPicker addObject:_srchStr];
                }
                if ([_desc isEqualToString:@"MATERIAL MASTER DATA"]) {
                    [self.materialListArrayPicker addObject:_srchStr];
                }
                if ([_desc isEqualToString:@"FAULT SYMTM GROUP MASTER DATA"]) {
                    [self.faultSymtmCodeGroupArrayPicker addObject:_srchStr];;
                }
                if ([_desc isEqualToString:@"FAULT PROBLEM GROUP MASTER DATA"]) {
                    [self.faultPrblmCodeGroupArrayPicker addObject:_srchStr];
                }
                if ([_desc isEqualToString:@"FAULT CAUSE GROUP MASTER DATA"]) {
                    [self.faultCauseCodeGroupArrayPicker addObject:_srchStr];
                }
                if ([_desc isEqualToString:@"FAULT SYMTM CODE MASTER DATA"]) {
                    [self.faultSymtmCodeListArrayPicker addObject:_srchStr];
                }
                if ([_desc isEqualToString:@"FAULT PROBLEM CODE MASTER DATA"]) {
                    [self.faultPrblmCodeListArrayPicker addObject:_srchStr];
                }
                if ([_desc isEqualToString:@"FAULT CAUSE CODE MASTER DATA"]) {
                    [self.faultCauseCodeListArrayPicker addObject:_srchStr];
                }
                
                
                [tempDic release], tempDic = nil;
            }
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        
    }
    return rsltAry;
	//}
	//@catch (NSException * e) {
	//	NSLog(@"Exception=%@",e);
	//}
    
}
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************
//Optimized sqlite db layer -  written by selvan  - END
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************
//***************************************************************************************************************************************************




//Fetch total table records from any table, just pass the table name..
-(int)fetchTotalRecordsCount:(NSString *)DBName:(NSString *)tableName
{
	int totalRecord = 0;	
	@try {		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:DBName] UTF8String], &database) == SQLITE_OK)
		{
			const char *sqlQuery= [[NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE 1",tableName] cStringUsingEncoding:NSUTF8StringEncoding];			
			sqlite3_stmt *stmt;
			
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK){
				while(sqlite3_step(stmt) == SQLITE_ROW){
					
					totalRecord = sqlite3_column_int(stmt, 0);
				}
			}
			sqlite3_finalize(stmt);
		}
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		//exception occurred 
		NSLog(@"Exception=%@",e);
	}
	
	return totalRecord;
}


//*************************************************************************************************************************************************
//Activity & Spares Temporary Array starts here
//*************************************************************************************************************************************************
//Fetching service order activity temp array.. 
-(void)fetchServiceOrderActivityTemp:(NSString *)passedQuery:(NSInteger)arrayIndex
{	
	@try {
		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:self.serviceOrderConfirmationListingDB] UTF8String], &database) == SQLITE_OK)
		{
			
			const char *sqlQuery = [passedQuery UTF8String];
			sqlite3_stmt *stmt;
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
				while (sqlite3_step(stmt) == SQLITE_ROW) {
					
					
					NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];					
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 0)] forKey:@"ZGSCSMST_SRVCACTVTY10Id"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)] forKey:@"OBJECT_ID"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 2)] forKey:@"SRCDOC_NUMBER_EXT"];
                    
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)] forKey:@"NUMBER_EXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 4)] forKey:@"PRODUCT_ID"];
					if(arrayIndex == -2){
						[tempDic setObject:[NSString stringWithFormat:@"%@", @""] forKey:@"QUANTITY"];
					}
					else {
						[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 5)] forKey:@"QUANTITY"];
					}
                    
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 6)] forKey:@"PROCESS_QTY_UNIT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 7)] forKey:@"ZZITEM_DESCRIPTION"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 8)] forKey:@"ZZITEM_TEXT"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 9)] forKey:@"DATETIME_FROM"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 10)] forKey:@"DATETIME_TO"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 11)] forKey:@"DATE_FROM"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 12)] forKey:@"DATE_TO"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 13)] forKey:@"TIME_FROM"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 14)] forKey:@"TIME_TO"];
                    
					
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 32)] forKey:@"TIMEZONE_FROM"];
                    
					
					
					//if(arrayIndex == -1)
                    [self.serviceOrderActivityTempArray addObject:tempDic];
                    //else
                    //   [self.serviceOrderSelectedActivityArray addObject:tempDic];
					
					NSLog(@"act  %@",self.serviceOrderActivityTempArray);
                    
                    
					[tempDic release], tempDic = nil;
                }
			}
			sqlite3_finalize(stmt);
            sqlite3_close(database);
            
            
		}
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception=%@",e);
	}	
}

//Fetching and updating service order spare array.. calling from ServiceOrders.m file in below portion..
-(void)fetchServiceOrderSpareTemp:(NSString *)passedQuery:(NSInteger)arrayIndex
{	
	@try {
		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:self.serviceOrderConfirmationListingDB] UTF8String], &database) == SQLITE_OK)
		{
			const char *sqlQuery = [passedQuery UTF8String];
			sqlite3_stmt *stmt;
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
				while (sqlite3_step(stmt) == SQLITE_ROW) {
					
					
					NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];				
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 0)] forKey:@"ZGSCSMST_SRVCSPARE10Id"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)] forKey:@"OBJECT_ID"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 2)] forKey:@"NUMBER_EXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)] forKey:@"PRODUCT_ID"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 4)] forKey:@"QUANTITY"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 5)] forKey:@"PROCESS_QTY_UNIT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 6)] forKey:@"ZZITEM_DESCRIPTION"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 7)] forKey:@"ZZITEM_TEXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 8)] forKey:@"SERIAL_NUMBER"];
					
					//if(arrayIndex == -1)
					//{
                    //Inserting data in to spare array
                    [self.serviceOrderSpareTempArray addObject:tempDic];						
					//}						
					//else
					//{
                    ////updating spare array.. but now it is not calling now... may be required later...
					//	[self.serviceOrderSpareArray replaceObjectAtIndex:arrayIndex withObject:tempDic];
					//}
					
					[tempDic release], tempDic = nil;
					
				}
			}
			sqlite3_finalize(stmt);
		}
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception=%@",e);
	}	
}

//*************************************************************************************************************************************************
//Activity & Spares Temporary Array ends here
//*************************************************************************************************************************************************


//fetch completed task list calling from completed tasks -selvan

-(void)fetchAndUpdateCompletedTaskList:(NSString *)passedQuery:(NSInteger)arrayIndex
{	
	@try {
		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:self.serviceReportsDB] UTF8String], &database) == SQLITE_OK)
		{
			const char *sqlQuery = [passedQuery UTF8String];
			sqlite3_stmt *stmt;
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
				while (sqlite3_step(stmt) == SQLITE_ROW) {
					
					NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
					
					//[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 0)] forKey:@"OBJECT_ID"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)] forKey:@"PROCESS_TYPE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 2)] forKey:@"PROCESS_TYPE_TXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)] forKey:@"SOLD_TO_PARTY_LIST"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 4)] forKey:@"SOLD_TO_PARTY"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 5)] forKey:@"CONTACT_PERSON_LIST"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 6)] forKey:@"NET_VALUE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 7)] forKey:@"CURRENCY"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 8)] forKey:@"PRIORITY_TXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 9)] forKey:@"DESCRIPTION"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 10)] forKey:@"PO_DATE_SOLD"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 11)] forKey:@"CREATED_BY"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 12)] forKey:@"CONCATSTATUSER"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 13)] forKey:@"POSTING_DATE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 14)] forKey:@"WRK_START_DATE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 15)] forKey:@"WRK_END_DATE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 16)] forKey:@"HRS_LABOR"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 17)] forKey:@"HRS_TRAVEL"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 18)] forKey:@"HRS_TOTAL"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 19)] forKey:@"EQUIP_NO"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 20)] forKey:@"REQ_START_DT"];
					
					
					//NSLog(@"tempDic=%@",tempDic);
					
					
					
					//Create task search string..
					NSString *searchStr = @"";					
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@" %s ", (char*) sqlite3_column_text(stmt, 0)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 1)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 2)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 3)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 4)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 5)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 6)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 7)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 8)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@" %s ", (char*) sqlite3_column_text(stmt, 9)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 10)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 11)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 12)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 13)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 14)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 15)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 16)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 17)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 18)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 19)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 20)]];	
					/*
					 //Create task search string..
					 NSString *searchStr = @"";					
					 searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@" %s ", (char*) sqlite3_column_text(stmt, 0)]];
					 searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 13)]];
					 searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 3)]];
					 searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 4)]];
					 searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 5)]];
					 */
					//NSLog(@"searchStr=%@",searchStr);
					[tempDic setObject:searchStr forKey:@"TASK_SEARCH_STRING"];
					
					
					
					if(arrayIndex == -1)
					{
						[self.taskListArray addObject:tempDic];						
					}						
					else
					{
						//NSArray *tempArr = [[NSArray alloc] init]; 
						//[tempArr  replaceObjectAtIndex:tempDic atIndex:arrayIndex];
						//self.taskListArray = [(NSArray *)tempArr mutableCopy];
						
						//[self.taskListArray replaceObjectAtIndex:<#(NSUInteger)index#> withObject:<#(id)anObject#> replaceObjectAtIndex:tempDic atIndex:arrayIndex];
						
						[self.taskListArray replaceObjectAtIndex:arrayIndex withObject:tempDic];
					}	
					
				}
			}
			sqlite3_finalize(stmt);
		}
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception=%@",e);
	}	
}

-(void)fetchAndUpdateConfirmationFaultData:(NSString *)passedQuery:(NSInteger)arrayIndex
{
	@try {
		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:self.serviceOrderConfirmationListingDB] UTF8String], &database) == SQLITE_OK)
		{
			const char *sqlQuery = [passedQuery UTF8String];
			sqlite3_stmt *stmt;
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
                
				while (sqlite3_step(stmt) == SQLITE_ROW) {
					
					NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
					
                    
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 0)] forKey:@"SRVCCNFRMTNFAULT20Id"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)] forKey:@"NUMBER_EXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 2)] forKey:@"ZZSYMPTMCODEGROUP"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)] forKey:@"ZZSYMPTMCODE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 4)] forKey:@"ZZSYMPTMTEXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 5)] forKey:@"ZZPRBLMCODEGROUP"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 6)] forKey:@"ZZPRBLMCODE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 7)] forKey:@"ZZPRBLMTEXT"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 8)] forKey:@"ZZCAUSECODEGROUP"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 9)] forKey:@"ZZCAUSECODE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 10)] forKey:@"ZZCAUSETEXT"];
					
					
					if(arrayIndex == -1)
					{
						[self.faultAllDataArray addObject:tempDic];
                        
					}						
					else
					{
						[self.faultAllDataArray replaceObjectAtIndex:arrayIndex withObject:tempDic];
					}	
					
				}
			}
			sqlite3_finalize(stmt);
		}
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception=%@",e);
	}	
	
	
	
}

-(void)fetchColleagueList:(NSString *)passedQuery:(NSInteger)arrayIndex
{	
	@try {		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:self.serviceReportsDB] UTF8String], &database) == SQLITE_OK)
		{
			const char *sqlQuery = [passedQuery UTF8String];
			sqlite3_stmt *stmt;
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
				while (sqlite3_step(stmt) == SQLITE_ROW) {
					
					NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
					
					//Inserting all the table column values in to dictionar..
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 0)] forKey:@"PARTNER"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)] forKey:@"MC_NAME1"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 2)] forKey:@"MC_NAME2"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)] forKey:@"TEL_NO"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 4)] forKey:@"TEL_NO2"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 5)] forKey:@"PLANT"];
                    [tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 6)] forKey:@"STORAGE_LOC"];
                    
					
					
					
					//Create task list search string..
					NSString *searchStr = @"";					
					//searchStr = [searchStr stringByAppendingString:selectedDate];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@" %s ", (char*) sqlite3_column_text(stmt, 0)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 1)]];
  					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 2)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 3)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 4)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 5)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 6)]];
					//Inserting search string in to dictionary..
					[tempDic setObject:searchStr forKey:@"SEARCH_STRING"];
					
					if(arrayIndex == -1)
					{
						//Adding the dictionary in the activity list array..
						//[self.faultPrblmCodeGroupArrayPicker addObject:searchStr];
						[self.colleagueListArray  addObject:tempDic];
                    }						
					else
					{	
						//This block will call while, on a prticular task is editing..
						[self.colleagueListArray replaceObjectAtIndex:arrayIndex withObject:tempDic];
					}	
					
					[tempDic release], tempDic = nil;
					
				}
			}
			sqlite3_finalize(stmt);
		}
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception=%@",e);
	}	
}

//fetching and updating  tasklist array, update is portion is calling from Edit task class..
-(void)fetchColleagueTaskList:(NSString *)passedQuery:(NSInteger)arrayIndex
{	
	@try {		
		if(sqlite3_open([[self documentDirectoryServiceManagemenetDBPath:self.serviceReportsDB] UTF8String], &database) == SQLITE_OK)
		{
			const char *sqlQuery = [passedQuery UTF8String];
			sqlite3_stmt *stmt;
			if(sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
				while (sqlite3_step(stmt) == SQLITE_ROW) {
					
					NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
					
					//Inserting all the table column values in to dictionar..
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 0)] forKey:@"ZGSCSMST_SRVCDCMNT01Id"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)] forKey:@"OBJECT_ID"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 2)] forKey:@"PROCESS_TYPE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)] forKey:@"ZZKEYDATE"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 4)] forKey:@"PARTNER"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 5)] forKey:@"NAME_ORG1"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 6)] forKey:@"NAME_ORG2"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 7)] forKey:@"CITY"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 8)] forKey:@"POSTL_COD1"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 9)] forKey:@"STREET"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 10)] forKey:@"HOUSE_NO"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 11)] forKey:@"STR_SUPPL1"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 12)] forKey:@"COUNTRYISO"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 13)] forKey:@"REGION"];
					[tempDic setObject:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 14)] forKey:@"STA"];
                    
					
                    
					//below code for display due date (as format required) in takl list, 
					NSString *selectedDate = @"";
					if([[NSString stringWithFormat:@"%s", (char*) sqlite3_column_name(stmt, 3)] isEqualToString:@"ZZKEYDATE"])
					{			
						NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						[dateFormat setDateFormat:@"yyyy-MM-dd" ];	
                        //[dateFormat setDateStyle:NSDateFormatterMediumStyle];
						NSDate *dateFromStr = [dateFormat  dateFromString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)]];		
						[dateFormat release], dateFormat = nil;
						
						NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
						[dateFormat1 setDateFormat:@"MMM d" ];
						selectedDate = [dateFormat1 stringFromDate:dateFromStr];	
                        if (selectedDate == nil) {
                            selectedDate = @"";
                        }
						[tempDic setObject:selectedDate forKey:@"DISPLAY_DUE_DATE"];						
					}
                    
                    
					
					//Create task list search string..
					NSString *searchStr = @"";					
					searchStr = [searchStr stringByAppendingString:selectedDate];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@" %s ", (char*) sqlite3_column_text(stmt, 7)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 13)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 5)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 6)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 10)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 9)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 8)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s ", (char*) sqlite3_column_text(stmt, 12)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 11)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 1)]];
					searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"%s", (char*) sqlite3_column_text(stmt, 3)]];
					
					//Inserting search string in to dictionary..
					[tempDic setObject:searchStr forKey:@"TASK_SEARCH_STRING"];
					
					
					
					if(arrayIndex == -1)
					{
						//Adding the dictionary in the task list array..
						[self.colleagueTaskListArray addObject:tempDic];	
                        
					}						
					else
					{	
						//This block will call while, on aprticular task is editing..
						[self.colleagueTaskListArray replaceObjectAtIndex:arrayIndex withObject:tempDic];
					}	
                    
					[tempDic release], tempDic = nil;
					
				}
			}
            
			sqlite3_finalize(stmt);
		}
        
	}
	@catch (NSException * e) {
		NSLog(@"Exception=%@",e);
	}	
}




@end
