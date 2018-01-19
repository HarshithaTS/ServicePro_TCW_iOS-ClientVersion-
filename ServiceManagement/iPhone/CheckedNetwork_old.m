

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


//#import "gss_NetConnCheck.h"


@implementation CheckedNetwork

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


+ (NSString *) getResponseFromSAP:(NSMutableArray *)_reqstStrAry:(NSString *)_callingAPI:(NSString *)_targetDatabase:(NSInteger)_createdbflag:(NSString *)_optn{
    
   NSString  *_responseStatus;
    
   // gss_NetConnCheck *ogss_NetConnCheck = [[gss_NetConnCheck alloc]init];
    
    //call net connection check lib
    //if (![ogss_NetConnCheck connectedToNetwork])
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {
        _responseStatus = [self downloadData:_reqstStrAry:_callingAPI:_targetDatabase:_createdbflag:_optn];
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
    
    NSString *deviceString = objAppDelegate_iPHone.deviceMACID;
    NSLog(@"Unique Device Identifier:\n%@",deviceString);
    
    //Calling Soap servive
    //SOAP Input Part
    
 /*
    Z_GSSMWFM_HNDL_EVNTRQST00_BndngBinding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00 Z_GSSMWFM_HNDL_EVNTRQST00_BndngBinding]initWithAddress:objAppDelegate_iPHone.service_url];
    binding.logXMLInOut = YES;
    
    Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 alloc] init];
    par1.Cdata = deviceString;
    Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 alloc] init];
    par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
    Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 alloc] init];
    NSString *para3 = [NSString stringWithFormat:@"EVENT[.]%@[.]VERSION[.]0",_callingAPI];
	par3.Cdata =  para3;

    
    
    //Passing parameters in soap service
	Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbstDatarcrd01 *objZ_Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbstDatarcrd01 alloc] init];
	[objZ_Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01.item addObject:par1];
	[objZ_Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01.item addObject:par2];
	[objZ_Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01.item addObject:par3];
    
    for (int rowIndex=0; rowIndex < [_reqstStrAry count]; rowIndex++) {
        Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 *mPara = [[Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01 alloc] init];
        mPara.Cdata = [_reqstStrAry objectAtIndex:rowIndex];
        NSLog(@"sap request array %@",[_reqstStrAry objectAtIndex:rowIndex]);
        [objZ_Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01.item addObject:mPara];
    }
    
    //SOAP Input part end
    
    Z_GSSMWFM_HNDL_EVNTRQST00_ZGssmwfmHndlEvntrqst00 *request = [[Z_GSSMWFM_HNDL_EVNTRQST00_ZGssmwfmHndlEvntrqst00 alloc] init];
    request.DpistInpt = objZ_Z_GSSMWFM_HNDL_EVNTRQST00_ZgssmbssDatarcrd01;
    
  
  Z_GSSMWFM_HNDL_EVNTRQST00_BndngBindingResponse *resp = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request];
  
  */
    
  
    
    Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:objAppDelegate_iPHone.service_url];
    binding.logXMLInOut = YES;

	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];
    par1.Cdata = deviceString;
    
    
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
    NSString *para3 = [NSString stringWithFormat:@"EVENT[.]%@[.]VERSION[.]0",_callingAPI];
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
    
    
    Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request];
  
    //Get the response here, and create CXMLDocument object for parse the response
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:resp.getResponseData options:0 error:nil];
    
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
                    //NSLog(@"childNode2 name=%@  value=%@",[childNode2 name],[childNode2 stringValue]);
                    
                    if([childNode2 stringValue]!=nil)
                    {
                        //Splite cdata value and store into nsarray
                        NSMutableArray *dataTypeValueArray = [[NSMutableArray alloc] init];
                        
                        dataTypeValueArray = [(NSArray *) [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"] mutableCopy];
                        
                        
                        //NSArray *getArrayAfterSplit = [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"];
                        
                        //Check first array value has datatype then move datatype array to dictionary
                        NSString *cdataStr = [NSString stringWithFormat:@"%@", [dataTypeValueArray objectAtIndex:0]];
                        //NSLog(@" dataTypeValueArray %@",cdataStr);
                        
                        
                        //Get all table fields
                        if (![cdataStr hasPrefix:@"NOTATION"] && ![cdataStr hasPrefix:@"EVENT-RESPONSE"] && [cdataStr hasPrefix:@"DATA-TYPE"]) {
                            
                            NSString *dicKey = [NSString stringWithFormat:@"%@",[dataTypeValueArray objectAtIndex:1]];
                            
                            [dataTypeValueArray removeObjectAtIndex:0]; 
                            [dataTypeValueArray removeObjectAtIndex:0]; 
                            
                            [dataTypeDictionary setObject:dataTypeValueArray forKey:dicKey];
                            
                            _dataTypeFoundFlag = TRUE;
                            //NSLog(@"Updated datatype Dictionary: %@", dataTypeDictionary);
                        }
                        //Get all table values
                        if (![cdataStr hasPrefix:@"NOTATION"] && ![cdataStr hasPrefix:@"EVENT-RESPONSE"] && ![cdataStr hasPrefix:@"DATA-TYPE"] && _dataTypeFoundFlag == TRUE) 
                        {
                            
                            NSArray *allKeys = [dataTypeDictionary allKeys];
                            //NSLog(@"nsarray %@", allKeys);
                            
                            for (int index=0; index<[allKeys count]; index++) 
                            {
                                NSString *tableName = [allKeys objectAtIndex:index];
                                
                                if([cdataStr isEqualToString: tableName])
                                {
                                    
                                    
                                    
                                    if ([_callingAPI isEqualToString:@"SERVICE-DOX-FOR-COLLEAGUE-GET"] && [tableName isEqualToString:@"ZGSXSMST_SRVCDCMNT10"]) {
                                        tableName = [objServiceManagementData.dataTypeArray objectAtIndex:11];
                                        }
                                    
                                    NSString *tempFiledStr = @"";
                                    NSString *tempValueStr = @"";
                                    
                                    NSArray *dataTypeFieldArray = [dataTypeDictionary objectForKey:cdataStr]; 
                                    
                                    //NSLog(@"datatypearra  %@",dataTypeFieldArray);
                                    //NSLog(@"datatyepvalue %@",dataTypeValueArray);
                                   
                                    tempValueStr = [tempValueStr stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
                                    //NSLog(@"value str :%@",tempValueStr);
                                    
                                    for(int i=0;i<[dataTypeFieldArray count];i++)
                                    {
                                        
                                        if ([_callingAPI isEqualToString:@"DOCUMENT-ATTACHMENT-GET"]) {
                                            
                                            //if ([[dataTypeFieldArray objectAtIndex:i] isEqualToString:@"ATTCHMNT_CNTNT"]) {
                                                
                                               // NSData* imageData = [QSStrings decodeBase64WithString:[dataTypeValueArray objectAtIndex:i+1]];
                                                //NSLog(@"data %@",[dataTypeValueArray objectAtIndex:i+1]);
                                                
                                                //NSData* imageData = [dataTypeValueArray objectAtIndex:i+1];
                                                //NSString *tmpImgName = [NSString stringWithFormat:@"test.pdf"];
                                                
                                                //---write the date to file--
                                                //[imageData writeToFile:[self filePath:tmpImgName] atomically:YES];
                                                
                                                
                                           // }
                                            [tempArry addObject:[dataTypeValueArray objectAtIndex:i+1]];
                                        }
                                        
                                        tempFiledStr = [tempFiledStr stringByAppendingString:[dataTypeFieldArray objectAtIndex:i]];
                                        
                                        
                                        
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
                                   
                                    //STORE SERVER ATTACHMENT
                                    if ([_callingAPI isEqualToString:@"DOCUMENT-ATTACHMENT-GET"]) {
                                        objServiceManagementData.serviceAttachment = tempArry;
                                    }
                                    
                                    NSLog(@"task list insert query %@", sqlQuery);
                                    
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
    
    if (!_resErrorFlag  && _dataTypeFoundFlag && _dataValueFoundFlag)
        _responseStr = @"555-Success";
    else if (!_resErrorFlag && [_optn isEqualToString:@"UPDATEDATA"])
        _responseStr = @"555-Success";
    
    return _responseStr;	
}





@end
