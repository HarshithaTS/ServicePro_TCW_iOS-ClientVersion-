//
//  SignaturePreview.h
//  ServiceManagement
//
//  Created by gss on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignaturePreview : UIViewController{
    IBOutlet UIButton *buttonClose;
    IBOutlet UIImageView *imagePreview;
    
    NSString *TaskOrderID;
    
}


@property (nonatomic, retain) IBOutlet UIImageView *imagePreview;
@property (nonatomic, retain) IBOutlet UIButton *buttonClose;
@property (nonatomic,retain) NSString *TaskOrderID;

- (NSString *) filePath: (NSString *) fileName;

-(IBAction)closeButtonClick:(id)sender;

@end