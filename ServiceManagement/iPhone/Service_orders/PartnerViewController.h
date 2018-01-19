//
//  PartnerViewController.h
//  ServicePro
//
//  Created by GSS Mysore on 12/19/13.
//
//

#import <UIKit/UIKit.h>

@interface PartnerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

IBOutlet UITableView *partnerTableView;

    
   
}

@property (nonatomic,retain)  NSString *teleNumFirst;
@property (nonatomic,retain)  NSString *teleNumSecond;

@property (nonatomic,retain) NSMutableArray *partnerData;

-(UITableViewCell *)taskTableViewCellWithIdentifier_ipad:(NSString *)identifier;
-(void)Create_Label_Service_Order:(UITableViewCell *)cell andTag:(int)LTag andFontS :(UIFont*)FontS andNOLines:(int)Lines andLdata:(NSString*)Ldata;
-(void)Create_Image_partner:(UITableViewCell *)cell andTag:(int)LTag andImageName:(NSString*)imageName andButTag:(NSInteger *)butTag;

-(NSString *) GetPartnerTypeDiscription :(NSString *) partnerType;
-(void) goBack;
-(void) dailTelePhoneNumber: (UIButton *) butName;

@end
