//
//  ShowDetailTaskLocation.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*--Displaying deatils is task location address....*/

#import "ShowDetailTaskLocation.h"
#import "ServiceManagementData.h"


@implementation ShowDetailTaskLocation

@synthesize myTableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = NSLocalizedString(@"ShowDetailTaskLocation_Task_Address_Details",@"");
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.myTableView.userInteractionEnabled = FALSE;
	
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

//calculation cell height... the cell height will be automitically increased depending upon the display text..
-(CGFloat)cellHeightCalculation:(NSString *)cellLabelValue
{
	
	NSLog(@"cellLabelValue=%@",cellLabelValue);
	int countChar = cellLabelValue.length;
	
	if(countChar>250)
		return 240.0f;
	else if(countChar>205)
		return 195.0f;
	else if(countChar>180)
		return 150.0f;
	else if(countChar>135)
		return 105.0f;
	else if(countChar>90)
		return 85.0f;
	else
		return 65.0f;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	return [self cellHeightCalculation:[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@",[objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
										[objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG2"],
                                        [objServiceManagementData.taskDataDictionary objectForKey:@"NICKNAME"],
										[objServiceManagementData.taskDataDictionary objectForKey:@"HOUSE_NO"],
										[objServiceManagementData.taskDataDictionary objectForKey:@"STREET"],
										[objServiceManagementData.taskDataDictionary objectForKey:@"CITY"],
										[objServiceManagementData.taskDataDictionary objectForKey:@"REGION"],
										[objServiceManagementData.taskDataDictionary objectForKey:@"COUNTRYISO"]
										]];
	
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                           
                           [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"REGIO"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"LAND1"]
                           ];
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[myTableView release], myTableView = nil;
    [super dealloc];
}


@end
