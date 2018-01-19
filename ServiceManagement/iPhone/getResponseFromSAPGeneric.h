

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <UIKit/UIKit.h>

@interface getResponseFromSAPGeneric : NSObject {

}

+ (BOOL) downloadResponseFromSAP:(NSMutableArray *)_reqstStrAry:(NSString *)_targetDatabase;
+(BOOL)downloadDataFromSAP:(NSMutableArray *)_reqstStrAry:(NSString *)_targetDatabase;
@end
