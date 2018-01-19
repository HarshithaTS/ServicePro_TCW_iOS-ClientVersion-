//
//  SignatureCapture.h
//  ServiceManagement
//
//  Created by gss on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureCapture : UIViewController
{
    
    CGPoint lastPoint;
    UIImageView *drawImage;
    BOOL mouseSwiped;
    int mouseMoved;
    
    IBOutlet UIButton *butDone;
    IBOutlet UIView *viewControllerSignature;
    
    NSString *TaskOrderID;
    
    

}

@property (nonatomic, retain) IBOutlet UIButton *butDone;
@property (nonatomic, retain) IBOutlet UIView *viewControllerSignature;
@property (nonatomic,retain)  NSString *TaskOrderID;

-(void) doneClick;
- (BOOL) saveImage;
- (NSString *) filePath: (NSString *) fileName;

@end
