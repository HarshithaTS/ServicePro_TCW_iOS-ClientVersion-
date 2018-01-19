//
//  
// 
//This common class we can use, to create labels, textfiled, imageview, textview...
//  
//  
//

#import "Design.h"


@implementation Design


//Textfiled formation..
+(UITextField *)textFieldFormation:(float)x andY:(float)y andWidth:(float)Width andHeight:(float)Height withTag:(int)tag sender:(id)sender {
	
	UITextField *textFieldNormal;
	CGRect frame = CGRectMake(x, y,Width, Height);
	textFieldNormal = [[UITextField alloc] initWithFrame:frame];
	
	textFieldNormal.textColor = [UIColor blackColor];
	textFieldNormal.font = [UIFont systemFontOfSize:13.0];
	textFieldNormal.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	//textFieldNormal.textAlignment = UITextAlignmentLeft;
	
	textFieldNormal.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	textFieldNormal.returnKeyType = UIReturnKeyDone;
	textFieldNormal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textFieldNormal.clearButtonMode = UITextFieldViewModeWhileEditing;  // has a clear 'x' button to the right
	textFieldNormal.backgroundColor = [UIColor clearColor];
	textFieldNormal.tag = tag;	// tag this control so we can remove it later for recycled cells
	
	
	if(tag == 1)
		textFieldNormal.enabled =  FALSE;
	
	textFieldNormal.borderStyle = UITextBorderStyleRoundedRect;
	
	textFieldNormal.delegate = sender;
	
	return textFieldNormal;
}


//Label formation..
+(UILabel *)LabelFormation:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag {
	
	//UILabel *lblTemp;
	CGRect frame = CGRectMake(x, y, Width, Height);
	UILabel *lblTemp = [[[UILabel alloc]initWithFrame:frame] autorelease];
	lblTemp.numberOfLines = 0;
	//lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.textColor = [UIColor blackColor];
	
	if(tag == 1)
		lblTemp.font= [UIFont boldSystemFontOfSize:fontSize];
	else 
		lblTemp.font = [UIFont systemFontOfSize:fontSize];
	
	
	lblTemp.tag = tag;
	return lblTemp;
}
//Label formation..
+(UILabel *)LabelFormationWithColor:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag {
	
	//UILabel *lblTemp;
	CGRect frame = CGRectMake(x, y, Width, Height);
	UILabel *lblTemp = [[[UILabel alloc]initWithFrame:frame] autorelease];
	lblTemp.numberOfLines = 0;
	//lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blueColor];
	//lblTemp.textColor = [UIColor blackColor];
	
	if(tag == 1)
		lblTemp.font= [UIFont boldSystemFontOfSize:fontSize];
	else
		lblTemp.font = [UIFont systemFontOfSize:fontSize];
	
	
	lblTemp.tag = tag;
	return lblTemp;
}

+(UILabel *)LabelFormationWithColorGray:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag {
	
	//UILabel *lblTemp;
	CGRect frame = CGRectMake(x, y, Width, Height);
    UILabel *lblTemp = [[[UILabel alloc]initWithFrame:frame] autorelease];
	lblTemp.numberOfLines = 0;
	lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor grayColor];
	
	if(tag == 1)
		lblTemp.font= [UIFont boldSystemFontOfSize:fontSize];
	else
		lblTemp.font = [UIFont systemFontOfSize:fontSize];
	
	
	lblTemp.tag = tag;
	return lblTemp;
}
+(UILabel *)LabelFormationMultiWithColorGray:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag {
	
	//UILabel *lblTemp;
	CGRect frame = CGRectMake(x, y, Width, Height);
	UILabel *lblTemp = [[[UILabel alloc]initWithFrame:frame] autorelease];
	lblTemp.numberOfLines = 4;
	lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor grayColor];
	
	if(tag == 1)
		lblTemp.font= [UIFont boldSystemFontOfSize:fontSize];
	else
		lblTemp.font = [UIFont systemFontOfSize:fontSize];
	
	
	lblTemp.tag = tag;
	return lblTemp;
}


//Label formation..
+(UILabel *)TableLabelFormationWithColor_iphone:(CGFloat)fontSize:(int)tag {
	//UILabel *lblTemp;
		CGRect frame = CGRectMake(5.0, 5.0, 140, 40);
	UILabel *lblTemp = [[[UILabel alloc]initWithFrame:frame] autorelease];
	lblTemp.numberOfLines = 0;
	lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blueColor];
	//lblTemp.textColor = [UIColor blackColor];
	
	if(tag == 1)
		lblTemp.font= [UIFont boldSystemFontOfSize:fontSize];
	else
		lblTemp.font = [UIFont systemFontOfSize:fontSize];
	
	
	lblTemp.tag = tag;
	return lblTemp;
}

//Label formation..
+(UILabel *)TableLabelFormationWithColor_ipad:(CGFloat)fontSize:(int)tag:(NSString*)deviceType {
	
	//UILabel *lblTemp;
    CGRect frame;
    if ([deviceType isEqualToString:@"IPAD"]) 
        frame = CGRectMake(30.0, 5.0, 140.0, 40);
    else if ([deviceType isEqualToString:@"IPHONE"])
        frame = CGRectMake(5.0, 5.0, 140, 40);
    else
        frame = CGRectMake(5.0, 5.0, 140, 40);
    
    UILabel *lblTemp = [[[UILabel alloc]initWithFrame:frame]autorelease];
	lblTemp.numberOfLines = 1;
	lblTemp.textAlignment = UITextAlignmentLeft;
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blueColor];
	//lblTemp.textColor = [UIColor blackColor];
	
	if(tag == 1)
		lblTemp.font= [UIFont boldSystemFontOfSize:fontSize];
	else
		lblTemp.font = [UIFont systemFontOfSize:fontSize];
	
	
	lblTemp.tag = tag;
	return lblTemp;
}

//Label formon...with extra parameters
+ (UILabel *)commonDisplayText:(NSString*)labelTitle:(CGFloat)frameXCoordinate:(CGFloat)frameYCoordinate:(CGFloat)frameWidth:(CGFloat)frameHeight:(int)textAlignment:(int)textColor:(int)backgroundColor:(NSString *)fontName:(CGFloat)fontSize:(int)isBoldSystemFontOfSize:(int)adjustsFontSizeToFitWidth:(NSString *)selectedLabelText
{
    

	    UILabel *textLabel = [[ [UILabel alloc ] initWithFrame:CGRectMake(frameXCoordinate, frameYCoordinate, frameWidth, frameHeight) ] autorelease];
	textLabel.numberOfLines=0;
	textLabel.text = labelTitle;
	
	if(isBoldSystemFontOfSize==0)		
		textLabel.font= [UIFont fontWithName:fontName size:fontSize];
	else if(isBoldSystemFontOfSize==1)
		textLabel.font= [UIFont boldSystemFontOfSize:fontSize];
	else if(isBoldSystemFontOfSize==2)
		textLabel.font= [UIFont systemFontOfSize:fontSize];
	
	
	
	if(adjustsFontSizeToFitWidth==1)		
		textLabel.adjustsFontSizeToFitWidth = YES;	
	
	
	//textAlignment 
	if(textAlignment==1)
		textLabel.textAlignment =  UITextAlignmentLeft;
	else if(textAlignment==2)
		textLabel.textAlignment =  UITextAlignmentRight;
	else if(textAlignment==3)
		textLabel.textAlignment =  UITextAlignmentCenter;	
	
	//textColor
	if(textColor==1)
		textLabel.textColor = [UIColor blackColor];
	else if(textColor==2)
		textLabel.textColor = [UIColor grayColor];
	else if(textColor==3)
		textLabel.textColor = [UIColor greenColor];
	else if(textColor==4)
		textLabel.textColor = [UIColor redColor];	
	
	
	if([selectedLabelText isEqualToString:labelTitle])
		textLabel.textColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
	
	//backgroundColor
	if(backgroundColor==1)
		textLabel.backgroundColor = [UIColor whiteColor];
	else if(backgroundColor==2)
		textLabel.backgroundColor = [UIColor grayColor];
	else if(backgroundColor==3)
		textLabel.backgroundColor = [UIColor greenColor];
	else if(backgroundColor==4)
		textLabel.backgroundColor = [UIColor redColor];
	else if(backgroundColor==5)
		textLabel.backgroundColor = [UIColor blackColor];
	
	return textLabel ;
}

//Textview formation...
+(UITextView *)textViewFormation:(float)x:(float)y:(float)Width:(float)Height:(int)tag :(id)sender {
	UITextView *txtViewTemp;
	CGRect frame = CGRectMake(x, y, Width, Height);
	txtViewTemp = [[UITextView alloc] initWithFrame:frame];
	txtViewTemp.textColor = [UIColor blackColor];
	//txtViewTemp.backgroundColor = [UIColor lightGrayColor];
	
	txtViewTemp.font = [UIFont systemFontOfSize:16.0];
	
	
	txtViewTemp.autocorrectionType = UITextAutocorrectionTypeNo;
	txtViewTemp.keyboardType = UIKeyboardTypeDefault;
	txtViewTemp.returnKeyType = UIReturnKeyDone;
	txtViewTemp.tag = tag;
	txtViewTemp.delegate = sender;
	
	if(tag == 3)
	{
		txtViewTemp.editable  = FALSE;
		txtViewTemp.scrollEnabled = FALSE;
		txtViewTemp.userInteractionEnabled = FALSE;
	}
	else 
	{
		txtViewTemp.editable = TRUE;
		txtViewTemp.scrollEnabled = TRUE;
		txtViewTemp.userInteractionEnabled = TRUE;
	}
		
		
	return txtViewTemp;
}

//Create alert view..
+(void)createAlertView:(NSString*)title :(NSString*)bodyText :(id)sender {
	UIAlertView *alt = [[UIAlertView alloc] initWithTitle:title message:bodyText delegate:sender cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alt show];
	[alt release];
}

//Create imageview...
+(UIImageView *)commonDisplayImage:(NSString *)imageName:(CGFloat)frameXCoordinate:(CGFloat)frameYCoordinate:(CGFloat)frameWidth:(CGFloat)frameHeight
{
	//UIImageView *logoImageView = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:imageName] ];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
	UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *logoImageView = [[[UIImageView alloc]  initWithImage:image ] autorelease];
	
	logoImageView.frame = CGRectMake(frameXCoordinate, frameYCoordinate, frameWidth, frameHeight);
	return logoImageView;	
}

-(void)dealloc {
    [super dealloc];
}

@end
