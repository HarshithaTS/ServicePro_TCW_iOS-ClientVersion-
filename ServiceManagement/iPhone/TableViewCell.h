//
//  TableViewCell.h
//  ServiceManagement
//
//  Created by Selvan Chellam on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
{
	IBOutlet UILabel *cellText;
}

- (void)setLabelText:(NSString *)_text;
@end
