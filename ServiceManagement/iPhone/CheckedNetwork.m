

//This class for chekcing the device reachablity for host or not.. 

#import "CheckedNetwork.h"
#import "QSStrings.h"


/*--this header file for SOAP call--*/
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
//#import "Z_GSSMWFM_HNDL_EVNTRQST00.h"




#import "TouchXML.h"
#import "ServiceManagementData.h"

/*This header file is needed for rendering the, image, textfiled, textview like that*/
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate_iPhone.h"
#import <sqlite3.h>
#import "UIDevice+IdentifierAddition.h"
#import "OpenUDID.h"

#import "iOSMacros.h"
#import <AdSupport/ASIdentifierManager.h>
#import "UIDevice+IdentifierAddition.h"
//#import "gss_NetConnCheck.h"


@implementation CheckedNetwork


+(NSString *) GetCurrentTimeStamp {
    //Find Device Date and Time
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd HHmmss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    
    NSLog(@"Date String %@", dateString);
    
    return dateString;
    //End
}


+ (BOOL) connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (NSString *) getResponseFromSAP:(NSMutableArray *)_rreqstStrAry:(NSString *)_ccallingAPI:(NSString *)_ttargetDatabase:(NSInteger)_ccreatedbflag:(NSString *)_ooptn{
    
   NSString  *_responseStatus;
    
   // gss_NetConnCheck *ogss_NetConnCheck = [[gss_NetConnCheck alloc]init];
    
    //call net connection check lib
    //if (![ogss_NetConnCheck connectedToNetwork])
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {
        
        
        
        _responseStatus = [self downloadData:_rreqstStrAry:_ccallingAPI:_ttargetDatabase:_ccreatedbflag:_ooptn];
        NSLog(@"response status %@", _responseStatus);
    
    }
    else
    {
        _responseStatus = @"";// @"Could not connect to the server.";
    }
    
    return _responseStatus;
    
}

//Call SAP Webservice and download data
+(NSString *)downloadData:(NSMutableArray *)_reqstStrAry:(NSString *)_callingAPI:(NSString *)_targetDatabase:(NSInteger)_createdbflag:(NSString *)_optn{
    
    //NSString *_responseStr = [NSString stringWithFormat:@"444-Invalid API '%@' Called",_callingAPI];
    NSString *_responseStr = @"";
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    
    //NSString* openUDID = [OpenUDID value];
    //NSLog(@"UDID: %@", openUDID);
    
    
    //NSString *deviceString = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO",[[[UIDevice currentDevice] uniqueDeviceIdentifier] uppercaseString]];
    
    [objAppDelegate_iPHone GetDeviceid];
    
    
    NSString *deviceString = objAppDelegate_iPHone.deviceMACID;
    NSLog(@"Unique Device Identifier:\n%@",deviceString);
    
    //Calling Soap servive
    //SOAP Input Part
    
    
    Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:objAppDelegate_iPHone.service_url];
    binding.logXMLInOut = YES;

	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];
    par1.Cdata = deviceString;
    
    
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
    NSString *para3;
   // if (objAppDelegate_iPHone.FullSet)
   //     para3 = [NSString stringWithFormat:@"EVENT[.]%@[.]VERSION[.]0[.]RESPONSE-TYPE[.]FULL-SETS",_callingAPI];
   // else
        para3 = [NSString stringWithFormat:@"EVENT[.]%@[.]VERSION[.]0",_callingAPI];
    
    //NSLog(@"para 3 %@",para3);
	par3.Cdata =  para3;
	
    //Passing parameters in soap service
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par3];
    
    for (int rowIndex=0; rowIndex < [_reqstStrAry count]; rowIndex++) {
        Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *mPara = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
        mPara.Cdata = [_reqstStrAry objectAtIndex:rowIndex];
        NSLog(@"sap request array %@",[_reqstStrAry objectAtIndex:rowIndex]);
        [objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:mPara];
    }
    
    //SOAP Input part end
    
    Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
    request.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01;
	
    
    NSLog(@"Calling SAP With Input Values!!");
    
    
    Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request];
    
    
  
    //Get the response here, and create CXMLDocument object for parse the response
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:resp.getResponseData options:0 error:nil];
    
    NSLog(@"Convert Response to XMLDocument!!");
    NSLog(@"Start Parsing!!");
    [objServiceManagementData.diagonseArray addObject:[NSString stringWithFormat:@"Start parsing: %@", [self GetCurrentTimeStamp]]];
    
    //Sarted to parsing the response...
    NSArray *nodes = NULL;
    BOOL _resErrorFlag = FALSE;

    //Start - Selvan - 06/08/2012 Included sap response error check
    //First check the response contain any error message
    nodes = [doc nodesForXPath:@"//DpostMssg" error:nil];
    
    if ([nodes count] != 0) 
    {
        for(CXMLDocument *node in nodes)
        {		
              for(CXMLNode *childNode in [node children])
            {
                if([[childNode name] isEqualToString:@"item"])
                {
                    for(CXMLNode *childNode2 in [childNode children])
                    {
                        if ([[childNode2 name] isEqualToString:@"Type"]) {
                            if ([childNode2 stringValue] != nil) {
                                if ([[childNode2 stringValue] isEqualToString: @"E"]) {
                                    objAppDelegate_iPHone.mErrorFlagSAP = TRUE;
                                    _resErrorFlag = TRUE;
                    
                                }
                                else if ([[childNode2 stringValue] isEqualToString: @"S"]) {
                                    objAppDelegate_iPHone.mErrorFlagSAP = FALSE;
                                    _resErrorFlag = TRUE;
                                }
                            }
                        }
                        else if ([[childNode2 name] isEqualToString:@"Message"]) {
                            
                            if ([childNode2 stringValue] != nil) {
                                _responseStr = [childNode2 stringValue];

                            }
                        }
                    }
                }
                
            }
        }
        
    }
    else
    {
        if (resp.error != nil) {
            _resErrorFlag = TRUE;
            _responseStr = [resp.error localizedDescription];
            objAppDelegate_iPHone.mErrorFlagSAP = TRUE;
        }
        else{
            _resErrorFlag = FALSE;
            objAppDelegate_iPHone.mErrorFlagSAP = FALSE;
        }
    }
    
   //If errorflag is not true then create/re-create database to fetch data from sap server/
    //Even if server not responding, the app will show exist data from local database.
    if (!_resErrorFlag && _createdbflag == 1) {
        //Create ServiceReport Database
        [objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceReportsDB];	
        
    }
    
    if (!_resErrorFlag && _createdbflag == 99) {
      
    //create error table db
    [objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.gssSystemDB];
    
    //End - Selvan
    }
    
     
    NSMutableDictionary *dataTypeDictionary = [[NSMutableDictionary alloc] init];
     NSMutableArray *tempArry = [[[NSMutableArray alloc] init] autorelease];
    BOOL _dataTypeFoundFlag = FALSE;
    BOOL _dataValueFoundFlag = FALSE;
    
    if ([_optn isEqualToString:@"GETDATA"]) {
        
        //Check output xml tag
        nodes = [doc nodesForXPath:@"//DpostOtpt" error:nil];
        for(CXMLDocument *node in nodes)
        {
            for(CXMLNode *childNode in [node children])
            {
                //NSLog(@"childNode  Name =%@     Value = %@",[childNode name],[childNode stringValue]);
                
                if([[childNode name] isEqualToString:@"item"])
                {
                    
                    for(CXMLNode *childNode2 in [childNode children])
                    {
                        
                        
                        NSLog(@"childNode2 name=%@  value=%@",[childNode2 name],[childNode2 stringValue]);
                        
                        if([childNode2 stringValue]!=nil)
                        {
                            //Splite cdata value and store into nsarray
                            NSMutableArray *dataTypeValueArray = [[NSMutableArray alloc] init];
                            
                            dataTypeValueArray = [(NSArray *) [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"] mutableCopy];
                            
                            
                            NSLog(@"datatyepvalue %@",dataTypeValueArray);
                            
                            //NSArray *getArrayAfterSplit = [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"];
                            
                            //Check first array value has datatype then move datatype array to dictionary
                            NSString *cdataStr = [NSString stringWithFormat:@"%@", [dataTypeValueArray objectAtIndex:0]];
                            NSLog(@" dataTypeValueArray %@",cdataStr);
                            
                            
                            
                            //Check Diagnosis Service value
                            NSString *cdataDiagnoseStr = [NSString stringWithFormat:@"%@", [dataTypeValueArray objectAtIndex:1]];
                            
                            //New code for diagnose
                            if ([cdataDiagnoseStr hasPrefix:@"API-BEGIN"] || [cdataDiagnoseStr hasPrefix:@"API-END"]){
                                [objServiceManagementData.diagonseArray addObject:cdataDiagnoseStr];
                            }
                            //
                            
                            
                            //Get all table fields
                            if (![cdataStr hasPrefix:@"NOTATION"] && ![cdataStr hasPrefix:@"EVENT-RESPONSE"] && [cdataStr hasPrefix:@"DATA-TYPE"] ) {
                                
                                NSString *dicKey = [NSString stringWithFormat:@"%@",[dataTypeValueArray objectAtIndex:1]];
                                
                                [dataTypeValueArray removeObjectAtIndex:0];
                                [dataTypeValueArray removeObjectAtIndex:0];
                                
                                [dataTypeDictionary setObject:dataTypeValueArray forKey:dicKey];
                                
                                
                                _dataTypeFoundFlag = TRUE;
                                
                                NSLog(@"Updated datatype Dictionary: %@", dataTypeDictionary);
                            }
                            //Get all table values
                            if (![cdataStr hasPrefix:@"NOTATION"] && ![cdataStr hasPrefix:@"EVENT-RESPONSE"] && ![cdataStr hasPrefix:@"DATA-TYPE"] && _dataTypeFoundFlag == TRUE)
                            {
                                
                                NSArray *allKeys = [dataTypeDictionary allKeys];
                                // NSLog(@"nsarray %@", allKeys);
                                
                                
                                for (int index=0; index<[allKeys count]; index++)
                                {
                                    NSString *tableName = [allKeys objectAtIndex:index];
                                    
                                    
                                    NSMutableArray *dataTypeFieldArray = [dataTypeDictionary objectForKey:tableName];
                                    
                                    //NSLog(@"datatypefieldarray %@",dataTypeFieldArray);
                                    
                                    
                                    NSString *createFieldStr = @"";
                                    
                                    for(int i=0;i<[dataTypeFieldArray count];i++)
                                    {
                                        
                                        createFieldStr = [createFieldStr stringByAppendingString:[dataTypeFieldArray objectAtIndex:i]];
                                        createFieldStr = [createFieldStr stringByAppendingString:@" TEXT"];
                                        
                                        if(i<([dataTypeFieldArray count]- 1))
                                        {
                                            createFieldStr = [createFieldStr stringByAppendingString:@","];
                                            
                                        }
                                        
                                    }
                                    
                                    //Create table into Sqlite DB
                                    NSString *creatStmt = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",tableName,createFieldStr];
                                    //[sharedDBHandler excuteSqliteQryString:creatStmt :_targetDatabase :@"CREATE TABLE" :1];
                                    
                                    NSLog(@"Create query %@",creatStmt);
                                    
                                    [objServiceManagementData excuteSqliteQryString:creatStmt Database:_targetDatabase Description:@"CREATE TABLE" Option:1];
                                    
                                    
                                    if([cdataStr isEqualToString: tableName])
                                    {
                                        
                                        if ([_callingAPI isEqualToString:@"SERVICE-DOX-FOR-COLLEAGUE-GET"] && [tableName isEqualToString:@"ZGSXSMST_SRVCDCMNT10"]) {
                                            tableName = @"ZGSCSMST_SRVCDCMNT10_COLLEAGUE";
                                            //tableName = [objServiceManagementData.dataTypeArray objectAtIndex:11];
                                        }
                                        
                                        NSString *tempFiledStr = @"";
                                        NSString *tempValueStr = @"";
                                        
                                        
                                        
                                        NSMutableArray *dataTypeFieldArray = [dataTypeDictionary objectForKey:tableName];
                                        
                                        //NSLog(@"datatypefieldarray %@",dataTypeFieldArray);
                                        
                                        
                                        NSString *createFieldStr = @"";
                                        
                                        for(int i=0;i<[dataTypeFieldArray count];i++)
                                        {
                                            
                                            createFieldStr = [createFieldStr stringByAppendingString:[dataTypeFieldArray objectAtIndex:i]];
                                            createFieldStr = [createFieldStr stringByAppendingString:@" TEXT"];
                                            
                                            if(i<([dataTypeFieldArray count]- 1))
                                            {
                                                createFieldStr = [createFieldStr stringByAppendingString:@","];
                                                
                                            }
                                            
                                        }
                                        
                                        dataTypeFieldArray = [dataTypeDictionary objectForKey:cdataStr];
                                        //NSLog(@"dataTypeValueArray %@",dataTypeValueArray);
                                        
                                        for(int i=0;i<[dataTypeFieldArray count];i++)
                                        {
                                            if ([_callingAPI isEqualToString:@"DOCUMENT-ATTACHMENT-GET"])
                                            {
                                                [tempArry addObject:[dataTypeValueArray objectAtIndex:i+1]];
                                            }
                                            
                                            tempFiledStr = [tempFiledStr stringByAppendingString:[dataTypeFieldArray objectAtIndex:i]];
                                            
                                            NSLog(@"datatypearra  %@",dataTypeFieldArray);
                                            NSLog(@"datatyepvalue %@",dataTypeValueArray);
                                            
                                            tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                                            tempValueStr = [tempValueStr stringByAppendingString:[[[dataTypeValueArray objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] ];
                                            tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                                            
                                            if(i<([dataTypeFieldArray count]- 1))
                                            {
                                                tempFiledStr = [tempFiledStr stringByAppendingString:@","];
                                                tempValueStr = [tempValueStr stringByAppendingString:@","];
                                            }
                                            
                                        }
                                        
                                        
                                        _dataValueFoundFlag = TRUE;
                                        
                                        
                                        
                                        
                                        //Inserting data into Sqlite DB
                                        NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",tableName,tempFiledStr,tempValueStr];
                                        
                                        if ([_callingAPI isEqualToString:@"DOCUMENT-ATTACHMENT-GET"]) {
                                            //objServiceManagementData.serviceAttachment = tempArry;
                                        }
                                        
                                       NSLog(@"task list insert query %@", sqlQuery);
                                        
                                        
                                        //if ([sharedDBHandler excuteSqliteQryString:creatStmt :_targetDatabase :@"CREATE TABLE" :1] || tableName == tmpTableName)
                                        {
                                            
                                            //tmpTableName = tableName;
                                            
                                            if ([objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:_targetDatabase]){
                                                
                                                _resErrorFlag = FALSE;
                                                
                                            }
                                            else {
                                                _resErrorFlag = TRUE;
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
    if (!_resErrorFlag  && _dataTypeFoundFlag && _dataValueFoundFlag)
        _responseStr = @"555-Success";
    else if (!_resErrorFlag && [_optn isEqualToString:@"UPDATEDATA"])
        _responseStr = @"555-Success";
    
    NSLog(@"Stop parsing");
    
    [objServiceManagementData.diagonseArray addObject:[NSString stringWithFormat:@"Stop parsing: %@", [self GetCurrentTimeStamp]]];
    
    return _responseStr;	
}





@end
