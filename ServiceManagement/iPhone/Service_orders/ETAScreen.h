//
//  SignaturePreview.h
//  ServiceManagement
//
//  Created by gss on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAScreen : UIViewController{
    IBOutlet UIButton *buttonClose;
    IBOutlet UIImageView *imagePreview;
}


@property (nonatomic, retain) IBOutlet UIImageView *imagePreview;
@property (nonatomic, retain) IBOutlet UIButton *buttonClose;
-(IBAction)closeButtonClick:(id)sender;
@end