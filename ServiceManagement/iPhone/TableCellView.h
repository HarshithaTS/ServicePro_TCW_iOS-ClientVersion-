//
//  TableCellView.h
//  SimpleTable
//
//  Created by Adeem on 30/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableCellView : UITableViewCell {
	IBOutlet UILabel *cellText;
    IBOutlet UITextField *cellTextFieldValue;
}

- (void)setLabelText:(NSString *)_text:(NSString *)_value;
@end
