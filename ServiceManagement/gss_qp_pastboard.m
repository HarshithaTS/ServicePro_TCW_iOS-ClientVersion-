//
//  gss_qp_pastboard.m
//  gss.qp.pastboard
//
//  Created by GSS Mysore on 19/11/12.
//  Copyright (c) 2012 GSS Mysore. All rights reserved.
//

#import "gss_qp_pastboard.h"

@implementation gss_qp_pastboard

@synthesize pastBoardItemArray;
@synthesize pastBoardObj;

NSString *pastBoard_Name = @"gss_qp_pastboard";
NSString *error_Pb_Name = @"gss_qp_error_pb";

-(BOOL) createPastBord:(NSMutableArray *) qpDataArray:(NSString *)pastBoardName{
    NSString *PBNAME = @"gss.qp.pastboard";
    //Remove or clear past board
    [UIPasteboard removePasteboardWithName:PBNAME];
    //Create pastboard with pastboardname
    UIPasteboard *obj_pastBoardObj = [UIPasteboard pasteboardWithName:PBNAME create:YES];
    [obj_pastBoardObj setPersistent:YES];
    //Overwrite array into pastboard
    [obj_pastBoardObj setItems:qpDataArray];
    return YES;
}
-(NSMutableArray *) readPastBord:(NSString *) pastBoardName{
    NSString *PBNAMEREAD = @"gss.qp.pastboard";
    //get pasteboard with predefine name
    self.pastBoardObj = [UIPasteboard pasteboardWithName:PBNAMEREAD create:NO];
    
    if (self.pastBoardObj) {
        NSArray *dataArray = [[[NSArray alloc] init] autorelease];
        dataArray = [self.pastBoardObj items];
        NSMutableArray *pbItemArray = [NSMutableArray arrayWithArray:dataArray];
        return pbItemArray;
    }
    else
        return nil;
}

//***************Start Message Handler*****************************

-(BOOL) setItemIntoPastBord:(NSMutableArray *) qpDataArray:(NSString *)pastBoardName{
    return [self createPastBord:qpDataArray :@"gss_qp_pastboard"];}

-(NSMutableArray *) getItemFromPastBord:(NSString *) pastBoardName{
    return [self readPastBord:@"gss_qp_pastboard"];
    
}
//****************End Message Handler*******************************


//****************Error Message Handler*****************************
-(BOOL) setEItemsIntoPastBoard:(NSMutableArray *) qpDataArray:(NSString *)pastBoardName
{
    NSString *ERRORPBNAME = @"gss.qp.err.pb";
    //Remove or clear past board
    [UIPasteboard removePasteboardWithName:ERRORPBNAME];
    //Create pastboard with pastboardname
    UIPasteboard *obj_err_pastBoardObj = [UIPasteboard pasteboardWithName:ERRORPBNAME create:YES];
    [obj_err_pastBoardObj setPersistent:YES];
    //Overwrite array into pastboard
    [obj_err_pastBoardObj setItems:qpDataArray];
    return YES;
    //return [self createPastBord:qpDataArray :@"gss_qp_errorpb"];
    
}

-(NSMutableArray *) getErrorItemsFromPastBoard:(NSString *) pastBoardName{
    NSString *ERRORPBNAMEREAD = @"gss.qp.err.pb";
    //get pasteboard with predefine name
    UIPasteboard *obj_err_read_pastBoardObj = [UIPasteboard pasteboardWithName:ERRORPBNAMEREAD create:NO];
    
    if (obj_err_read_pastBoardObj) {
        NSArray *dataArray = [[[NSArray alloc] init] autorelease];
        dataArray = [obj_err_read_pastBoardObj items];
        NSMutableArray *pbItemArray = [NSMutableArray arrayWithArray:dataArray];
        return pbItemArray;
    }
    else
        return nil;
    //return [self readPastBord:@"gss_qp_errorpb"];
}



@end
