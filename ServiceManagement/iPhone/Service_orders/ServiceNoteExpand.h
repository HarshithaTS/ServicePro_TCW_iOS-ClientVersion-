//
//  ServiceNoteExpand.h
//  ServicePro
//
//  Created by GSS Mysore on 5/21/14.
//
//

#import <UIKit/UIKit.h>

@interface ServiceNoteExpand : UIViewController
{
    IBOutlet UILabel *lblServiceNote;
    
    IBOutlet UIScrollView *svServiceNote;
    IBOutlet UIView *myView;
}


@property (nonatomic, retain) IBOutlet UIScrollView *svServiceNote;

@property (nonatomic, retain) IBOutlet UIView *myView;

@end
