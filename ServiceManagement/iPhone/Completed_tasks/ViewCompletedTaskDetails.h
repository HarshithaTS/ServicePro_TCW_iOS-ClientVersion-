//
//  ViewCompletedTaskDetails.h
//  ServiceManagement
//
//  Created by gss on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewCompletedTaskDetails : UITableViewController {
	IBOutlet UITableView *myTableView;
	UITextView *displayText,*workText;
	UILabel *objectid,*processtype,*partner,*contactperson,*netvalue,*periority,*description,*podatesold,*createdby,*concatstatuser,*postingdate,*sdate,*edate,*laborhrs,*travelhrs,*totalhrs,*equipno,*reqstartdate;
	UILabel *headerDetails;
	BOOL printed;

}
@property (nonatomic, retain) UITextView *displayText,*workText;


-(id)convertDataAsTableDatasource;
@end
