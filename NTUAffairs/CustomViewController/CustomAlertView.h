//
//  CustomAlertView.h
//  ObjectivePlurkApp_ver3
//
//  Created by fawkes1234 on 2010/9/4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomAlertView;

@protocol CustomAlertViewDelegate

@optional
- (void) customAlertViewWasCancelled:(CustomAlertView *)alert;

@end



@interface CustomAlertView : UIViewController {
	IBOutlet UILabel *alertTextLabel;
	IBOutlet UIView *alertView;
    IBOutlet UIView *backgroundView;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UIImageView *errorImageView;
	
	NSString *_text;
	
	id<NSObject, CustomAlertViewDelegate> delegate;
}

- (id)initWithText:(NSString *)text;


@property (nonatomic, assign) IBOutlet id<CustomAlertViewDelegate, NSObject> delegate;
@property (nonatomic, retain) IBOutlet  UILabel *alertTextLabel;
@property (nonatomic, retain) IBOutlet  UIView *alertView;
@property (nonatomic, retain) IBOutlet  UIView *backgroundView;
@property (nonatomic, retain) IBOutlet  UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet  UIImageView *errorImageView;

- (IBAction)show;
- (IBAction)dismiss;

@end
