//
//  CustomAlertView.m
//  ObjectivePlurkApp_ver3
//
//  Created by fawkes1234 on 2010/9/4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView-AlertAnimations.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomAlertView

@synthesize alertView;
@synthesize backgroundView;
@synthesize delegate;
@synthesize alertTextLabel;
@synthesize indicatorView;
@synthesize errorImageView;

- (id)initWithText:(NSString *)text {
	if ((self = [super initWithNibName:@"CustomAlertView" bundle:nil])) {
        // Custom initialization
		_text = text;
    }
    return self;
}


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
    [super viewDidLoad];
	self.alertTextLabel.text = _text;
	self.alertView.layer.cornerRadius = 8;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
//	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark IBActions
- (IBAction)show
{
    // Retaining self is odd, but we do it to make this "fire and forget"
    [self retain];
    
    // We need to add it to the window, which we can get from the delegate
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:self.view];
//    UIWindow *window = [TTNavigator navigator].window;
//    [window addSubview:self.view];
    
    // Make sure the alert covers the whole window
    self.view.frame = window.frame;
    self.view.center = window.center;
    
    // "Pop in" animation for alert
    [alertView doPopInAnimationWithDelegate:self];
    
    // "Fade in" animation for background
    [backgroundView doFadeInAnimation];
}

- (IBAction)dismiss {
    [UIView beginAnimations:nil context:nil];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
    [self performSelector:@selector(alertDidFadeOut) withObject:nil afterDelay:0.5];
	[delegate customAlertViewWasCancelled:self];
}

#pragma mark -
- (void)viewDidUnload {
    [super viewDidUnload];
    self.alertView = nil;
    self.backgroundView = nil;
	self.alertTextLabel = nil;
}

- (void)dealloc {
    [alertView release];
    [backgroundView release];
	[alertTextLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Private Methods
- (void)alertDidFadeOut {    
    [self.view removeFromSuperview];
    [self autorelease];
}

@end
