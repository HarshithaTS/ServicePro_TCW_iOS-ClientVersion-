

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import <UIKit/UIKit.h>

@interface CheckedNetwork : NSObject {

}

+ (BOOL) connectedToNetwork;

+ (NSString *) getResponseFromSAP:(NSMutableArray *)_rreqstStrAry:(NSString *)_ccallingAPI:(NSString *)_ttargetDatabase:(NSInteger)_ccreatedbflag:(NSString *)_ooptn;
+(NSString *)downloadData:(NSMutableArray *)_reqstStrAry:(NSString *)_callingAPI:(NSString *)_targetDatabase:(NSInteger)_createdbflag:(NSString *)_optn;

@end
