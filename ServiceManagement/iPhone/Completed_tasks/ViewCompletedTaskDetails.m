//
//  ViewCompletedTaskDetails.m
//  ServiceManagement
//
//  Created by gss on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewCompletedTaskDetails.h"
#import "ServiceManagementData.h"
#import "QuartzCore/QuartzCore.h"
#import "Design.h"
@implementation ViewCompletedTaskDetails
@synthesize displayText;
@synthesize workText;




#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	self.title = NSLocalizedString(@"Task Details",@"");

    [super viewDidLoad];
	
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(void) goBack{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}	

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //return <#number of sections#>;
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return <#number of rows in section#>;
	return 10;
}
//Calculating label height... caling from cell for row at index path.. to display the text in table view...
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType
{
	int countChar =  cellTextDisplay.length;
	
	if(displayType==1)
	{
		if(countChar>38)
			return 70.0f;
		else if(countChar>16)
			return 50.0f;
		else
			return 30.0f;
	}
	else if(displayType==2)
	{
		if(countChar>42)
			return 70.0f;
		else if(countChar>21)
			return 50.0f;
		else
			return 30.0f;		
	}
	
	return 30.0f;
}


-(CGFloat)cellHeightCalculation:(NSString *)cellTextDisplay:(int)displayType
{
	int countChar =  cellTextDisplay.length;
	
	if(displayType==1)
	{
		if(countChar>52)
			return 75.0f;
		else if(countChar>28)
			return 52.0f;
		else
			return 35.0f;
	}
	else
	{
		if(countChar>52)
			return 65.0f;
		else if(countChar>26)
			return 45.0f;
		else
			return 30.0f;		
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat rowHeight;
	
	if(indexPath.row == 0 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Type",@""):1];
	}
	else if(indexPath.row == 1 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_ID",@""):1];
	}
	else if(indexPath.row == 2 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Date",@""):1];
	}
	else if(indexPath.row == 3 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Partner",@""):1];
	}
	else if(indexPath.row == 4 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Name",@""):1];
	}
	else if(indexPath.row == 5 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_desc",@""):1];
	}
	else if(indexPath.row == 6 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_periority",@""):1];
		
	}
	else if(indexPath.row == 7 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Contact",@""):1];
		
	}
	else if(indexPath.row == 8 )
	{
		return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Status",@""):1];
		
	}
	else if(indexPath.row == 9 )
	{
		//return [self cellHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Status",@""):1];
		return 150.0f;
	}
	else if(indexPath.row == 10)
		return 250.0f;
	else 
		return 45.0f;
	
	
	return rowHeight;	
}// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager]; 
	NSInteger taskid_local = objServiceManagementData.taskId;
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
	}
    
    // Configure the cell...
	
	if (printed != TRUE)
	{
		if(indexPath.section == 0)
		{
			
			switch (indexPath.row) {
				case 0:				
					cell.textLabel.text = NSLocalizedString(@"Type",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					
					//LabelFormation:<#(float)x#> :<#(float)y#> :<#(float)Width#> :<#(float)Height#> :<#(int)tag#>
					processtype = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Type",@""):1]:16.0f :1];		
					processtype.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"PROCESS_TYPE_TXT"];
					processtype.textColor = [UIColor blackColor];
					processtype.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:processtype];
					[processtype release], processtype = nil;
					break;
					
				case 1:				
					cell.textLabel.text = NSLocalizedString(@"ID",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_ID",@""):1]:16.0f :1];	
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"OBJECT_ID"];
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
					
				case 2:				
					cell.textLabel.text = NSLocalizedString(@"Date",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Date",@""):1]:16.0f :1];	
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"POSTING_DATE"];
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
					
				case 3:				
					cell.textLabel.text = NSLocalizedString(@"Customer",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					NSString *partnerString = [NSString stringWithFormat:@"%@ \n %@",[[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"SOLD_TO_PARTY"],[[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"SOLD_TO_PARTY_LIST"]];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:[[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"SOLD_TO_PARTY"]:1]:16.0f :1];	
					objectid.numberOfLines = 3;
					objectid.lineBreakMode = TRUE;
					objectid.text = partnerString;
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
					
				case 4:				
					cell.textLabel.text = NSLocalizedString(@"Name",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Name",@""):1]:16.0f :1];	
					objectid.numberOfLines = 2;
					objectid.lineBreakMode = TRUE;
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"CREATED_BY"];
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
				case 5:				
					cell.textLabel.text = NSLocalizedString(@"Description",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_desc",@""):1]:16.0f :1];	
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"DESCRIPTION"];
					objectid.textColor = [UIColor blackColor];
					objectid.numberOfLines = 3;
					objectid.lineBreakMode = TRUE;
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
					
				case 6:				
					cell.textLabel.text = NSLocalizedString(@"Periority",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_periority",@""):1]:16.0f :1];	
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"PRIORITY_TXT"];
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
					
				case 7:				
					cell.textLabel.text = NSLocalizedString(@"Cont.Person",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Contact",@""):1]:16.0f :1];	
					objectid.numberOfLines = 2;
					objectid.lineBreakMode = TRUE;
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"CONTACT_PERSON_LIST"];
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
				case 8:	
					cell.textLabel.text = NSLocalizedString(@"Status",@"");
					cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					objectid = [Design LabelFormation:100.0 :0.0 :200.0 :[self labelHeightCalculation:NSLocalizedString(@"Completed_Task_Label_Status",@""):1]:16.0f :1];	
					objectid.numberOfLines = 2;
					objectid.lineBreakMode = TRUE;
					objectid.text = [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"CONCATSTATUSER"];
					
					objectid.textColor = [UIColor blackColor];
					objectid.font = [UIFont systemFontOfSize:13.0f];
					cell.userInteractionEnabled = FALSE;
					[cell.contentView addSubview:objectid];
					[objectid release], objectid = nil;
					break;
				case 9:
					//cell.textLabel.text = NSLocalizedString(@"Service Assignment",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
					
					self.workText = [Design textViewFormation:10.0 :0.0 :300.0 :100.0 :3 :self];
					self.workText.backgroundColor = [UIColor clearColor];
					self.workText.textColor = [UIColor blackColor];
					
					self.workText.layer.masksToBounds = YES;
					self.workText.layer.cornerRadius = 2.0;
					self.workText.layer.borderWidth = 0.5;
					self.workText.layer.borderColor =  [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];			
					
					
					
					self.workText.text = [NSString stringWithFormat:@"Work Start Date : %@\nWork End Date : %@\nLabor Hrs.: %@  Travel Hrs.: %@\nTotal Hrs.: %@\nEquipment No.:%@ %@",
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"WRK_START_DATE"],
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"WRK_END_DATE"],
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"HRS_LABOR"],
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"HRS_TRAVEL"],
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"HRS_TOTAL"],
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"EQUIP_NO"],
										  [[objServiceManagementData.taskListArray objectAtIndex:taskid_local] objectForKey:@"PO_DATE_SOLD"]];
					cell.userInteractionEnabled = FALSE;
					self.workText.font = [UIFont systemFontOfSize:12.0f];
					[cell.contentView addSubview:workText];
					
					
					
					printed = TRUE;
					break;
					
					
			}
		}
	}
	return cell;
}



-(id)convertDataAsTableDatasource{
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager]; 
	NSInteger indexPath = objServiceManagementData.taskId;
	NSString *cmpltOrderRow;
	cmpltOrderRow = nil;
	if ([cmpltOrderRow count] >0)
		
	{
		cmpltOrderRow = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"OBJECT_ID"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"PROCESS_TYPE"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"PROCESS_TYPE_TXT"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"SOLD_TO_PARTY_LIST"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"SOLD_TO_PARTY"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"CONTACT_PERSON_LIST"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"NET_VALUE"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"CURRENCY"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"PRIORITY_TXT"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"DESCRIPTION"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"PO_DATE_SOLD"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"CREATED_BY"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"CONCATSTATUSER"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"POSTING_DATE"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"WRK_START_DATE"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"WRK_END_DATE"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"HRS_LABOR"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"HRS_TRAVEL"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"HRS_TOTAL"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"EQUIP_NO"],
						 [[objServiceManagementData.taskListArray objectAtIndex:indexPath] objectForKey:@"REQ_START_DT"]];
		
	}
	return cmpltOrderRow;
	
	
	
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
    [super dealloc];
	//[self.displayText release], displayText = nil;
}


@end

