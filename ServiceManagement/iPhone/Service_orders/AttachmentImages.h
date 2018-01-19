

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface AttachmentImages : UITableViewController <UIScrollViewDelegate>
{
	NSMutableArray *entries;   // the main data model for our UITableView
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
    CustomAlertView *customAlt;
}

@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void) getServerAttachment;
-(void) loadImageFromSAP:(NSIndexPath *)indexPath;
- (void)modalViewDone;
-(NSString *) filePath: (NSString *) fileName;
- (BOOL) searchTableView;
@end