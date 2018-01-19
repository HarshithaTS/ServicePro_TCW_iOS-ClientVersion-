
#import <UIKit/UIKit.h>


@interface CustomAlertView : UIViewController {
	UIView *alertView;
	UILabel *alertLabel;
}

@property (nonatomic, retain) UIView *alertView;
@property (nonatomic, retain) UILabel *alertLabel;

-(UIView*) customAlertAppear:(NSString*) alertMessage:(float)x :(float)y :(float)width :(float)height;
- (void)removeAlertForView ;

@end
