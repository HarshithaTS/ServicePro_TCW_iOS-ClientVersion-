//
//  ImagePreview.h
//  ServiceManagement
//
//  Created by gss on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreview : UIViewController{
    
    IBOutlet UIButton *buttonClose;
    IBOutlet UIImageView *imagePreview;
    
}
@property (nonatomic, retain) IBOutlet UIButton *buttonClose;
@property (nonatomic, retain) IBOutlet UIImageView *imagePreview;

-(IBAction)closeButtonClick:(id)sender;
@end