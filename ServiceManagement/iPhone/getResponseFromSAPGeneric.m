



#import "getResponseFromSAPGeneric.h"


/*--this header file for SOAP call--*/
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"


#import "TouchXML.h"
#import "ServiceManagementData.h"

/*This header file is needed for rendering the, image, textfiled, textview like that*/
#import <QuartzCore/QuartzCore.h>

#import <sqlite3.h>
@implementation getResponseFromSAPGeneric

+ (BOOL) downloadResponseFromSAP:(NSMutableArray *)_reqstStrAry:(NSString *)_targetDatabase {
    BOOL _responseStatus = FALSE;
    
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {
        if([self downloadDataFromSAP:_reqstStrAry:_targetDatabase])
        {
            _responseStatus = TRUE;   
        }	
        else {
            _responseStatus = FALSE;
        }
    }
    else
    {
     UIAlertView *alert = [[UIAlertView alloc] 
     initWithTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_title",@"")
     message:NSLocalizedString(@"AppDelegate_netChecking_alert_msg",@"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"") 
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     
    }

    return _responseStatus;

}

//Call SAP Webservice and download data
+(BOOL)downloadDataFromSAP:(NSMutableArray *)_reqstStrAry:(NSString *)_targetDatabase{	
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    
    //Calling Soap servive
    //SOAP Input Part
    Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:service_url];	
    binding.logXMLInOut = YES;  	
    
    
    //Passing parameters in soap service
    Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
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
    
    //Start - Selvan - 06/08/2012 Included sap response error check
    //First check the response contain any error message
    nodes = [doc nodesForXPath:@"//DpostMssg" error:nil];
    if ([nodes count] != 0) 
    {
        for(CXMLDocument *node in nodes)
        {		
            //NSMutableArray *individualItemArray = [[NSMutableArray alloc] init];		
            
            for(CXMLNode *childNode in [node children])
            {
                //NSLog(@"childNode=%@",[childNode name]);	
                // NSLog(@"childNode value=%@",[childNode stringValue]);
                //NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
                
                if([[childNode name] isEqualToString:@"item"])
                {
                    
                    for(CXMLNode *childNode2 in [childNode children])
                    {
                        //NSLog(@"childNode2 name=%@",[childNode2 name]);
                        //NSLog(@"childNode2 value=%@",[childNode2 stringValue]);
                        if ([[childNode2 name] isEqualToString:@"Type"]) {
                            if ([childNode2 stringValue] != nil) {
                                if ([[childNode2 stringValue] isEqualToString: @"E"]) {
                                    objAppDelegate_iPHone.mErrorFlagSAP = TRUE;
                                    
                                    UIAlertView *alert = [[UIAlertView alloc] 
                                                          initWithTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_title",@"")
                                                          message:NSLocalizedString(@"AppDelegate_sapChecking_alert_msg",@"")
                                                          delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_cancel_title",@"") 
                                                          otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                    
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_title",@"")
                              message:NSLocalizedString(@"AppDelegate_sapChecking_alert_msg",@"")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_cancel_title",@"") 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    
    //If errorflag is not true then create/re-create database to fetch data from sap server/ 
    //Even if server not responding, the app will show exist data from local database.
    if (!objAppDelegate_iPHone.mErrorFlagSAP) {
        //Create ServiceReport Database
        [objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceReportsDB];	
        
        //Create ServiceOrderConfirmationDatabase
        [objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceOrderConfirmationListingDB];
    }
    
    //End - Selvan
    
    
    NSMutableDictionary *dataTypeDictionary = [[NSMutableDictionary alloc] init];
    
    
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
                            
                            //NSLog(@"Updated datatype Dictionary: %@", dataTypeDictionary);
                        }
                        //Get all table values
                        if (![cdataStr hasPrefix:@"NOTATION"] && ![cdataStr hasPrefix:@"EVENT-RESPONSE"] && ![cdataStr hasPrefix:@"DATA-TYPE"]) 
                        {
                            
                            NSArray *allKeys = [dataTypeDictionary allKeys];
                            //NSLog(@"nsarray %@", allKeys);
                            
                            for (int index=0; index<[allKeys count]; index++) 
                            {
                                NSString *tableName = [allKeys objectAtIndex:index];
                                
                                if([cdataStr isEqualToString: tableName])
                                {
                                    NSString *tempFiledStr = @"";
                                    NSString *tempValueStr = @"";
                                    
                                    NSArray *dataTypeFieldArray = [dataTypeDictionary objectForKey:cdataStr]; 
                                    
                                    //NSLog(@"datatypearra  %@",dataTypeFieldArray);
                                    //NSLog(@"datatyepvalue %@",dataTypeValueArray);
                                    
                                    for(int i=0;i<[dataTypeFieldArray count];i++)
                                    {
                                        tempFiledStr = [tempFiledStr stringByAppendingString:[dataTypeFieldArray objectAtIndex:i]];								
                                        tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                                        tempValueStr = [tempValueStr stringByAppendingString:[[dataTypeValueArray objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                                        tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
                                        
                                        if(i<([dataTypeFieldArray count]- 1))
                                        {
                                            tempFiledStr = [tempFiledStr stringByAppendingString:@","];
                                            tempValueStr = [tempValueStr stringByAppendingString:@","];
                                        }
                                        
                                    }
                                    
                                    //Inserting data into Sqlite DB
                                    NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",tableName,tempFiledStr,tempValueStr];
                                    
                                    NSLog(@"task list insert query %@", sqlQuery);
                                    
                                    [objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:_targetDatabase];	
                                    
                                    
                                }
                                
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }    
    
    return TRUE;	
}


@end
