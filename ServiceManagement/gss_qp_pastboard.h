//
//  gss_qp_pastboard.h
//  gss.qp.pastboard
//
//  Created by GSS Mysore on 19/11/12.
//  Copyright (c) 2012 GSS Mysore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface gss_qp_pastboard : NSObject
{
    UIPasteboard *pastBoardObj;
    NSMutableArray *pastBoardItemArray;
    
}


@property (nonatomic, retain) UIPasteboard *pastBoardObj;
@property (nonatomic, retain) NSMutableArray *pastBoardItemArray;


-(BOOL) createPastBord:(NSMutableArray *) qpDataArray:(NSString *)pastBoardName;
-(NSMutableArray *) readPastBord:(NSString *) pastBoardName;



-(BOOL) setItemIntoPastBord:(NSMutableArray *) qpDataArray:(NSString *)pastBoardName;
-(NSMutableArray *) getItemFromPastBord:(NSString *) pastBoardName;


-(BOOL) setEItemsIntoPastBoard:(NSMutableArray *) qpDataArray:(NSString *)pastBoardName;
-(NSMutableArray *) getErrorItemsFromPastBoard:(NSString *) pastBoardName;

@end
