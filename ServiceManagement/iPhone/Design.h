//
//  
// 
//This common class we can use, to create labels, textfiled, imageview, textview...
//  
//  
//

#import <Foundation/Foundation.h>

@interface Design : NSObject {
  
}
+(UITextField *)textFieldFormation:(float)x andY:(float)y andWidth:(float)Width andHeight:(float)Height withTag:(int)tag sender:(id)sender;
+(UITextView *)textViewFormation:(float)x:(float)y:(float)Width:(float)Height:(int)tag :(id)sender;

+(void)createAlertView:(NSString*)title :(NSString*)bodyText :(id)sender;

+(UILabel *)commonDisplayText:(NSString*)labelTitle:(CGFloat)xCoordinate:(CGFloat)yCoordinate:(CGFloat)labelWidth:(CGFloat)labelHeight:(int)textAlignment:(int)textColor:(int)backgroundColor:(NSString *)fontName:(CGFloat)fontSize:(int)isBoldSystemFontOfSize:(int)adjustsFontSizeToFitWidth:(NSString *)selectedLabelText;

+(UILabel *)LabelFormation:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag;
+(UILabel *)LabelFormationWithColor:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag;
+(UILabel *)LabelFormationWithColorGray:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag;
+(UILabel *)LabelFormationMultiWithColorGray:(float)x:(float)y:(float)Width:(float)Height:(CGFloat)fontSize:(int)tag;
+(UIImageView *)commonDisplayImage:(NSString *)imageName:(CGFloat)frameXCoordinate:(CGFloat)frameYCoordinate:(CGFloat)frameWidth:(CGFloat)frameHeight;


+(UILabel *)TableLabelFormationWithColor_ipad:(CGFloat)fontSize:(int)tag;
+(UILabel *)TableLabelFormationWithColor_iphone:(CGFloat)fontSize:(int)tag;

@end
