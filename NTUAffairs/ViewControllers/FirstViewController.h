//
//  FirstViewController.h
//  NTUAffairs
//
//  Created by fawkes1234 on 2011/5/7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

typedef enum {
    LOAD_LOGIN_PAGE,
    LOAD_HOME_PAGE,
    LOAD_PROPOSE_PAGE,
    LOAD_PROPOSE_POSTED_PAGE,
    LOAD_LOGOUT_PAGE
}LOAD_PAGE;

typedef enum {
    PROPOSAL_CATEGORY_SCHOOL = 1,
    PROPOSAL_CATEGORY_TEACHING = 2,
    PROPOSAL_CATEGORY_STUDENT = 3,
    PROPOSAL_CATEGORY_FINANCE = 4,
    PROPOSAL_CATEGORY_TUITION = 5,
    PROPOSAL_CATEGORY_OTHER = 9
}PROPOSAL_CATEGORY;

@interface FirstViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate> {
    CustomAlertView *customAlertView;
    
    PROPOSAL_CATEGORY proposal_category;
    LOAD_PAGE load_page;
    UIWebView *webview;
    UITableViewCell *categorycell;
    UITableViewCell *studentcell;
    UITableViewCell *passwordcell;
    UITableViewCell *emailcell;
    UITableViewCell *subjectcell;
    UITableViewCell *contentcell;
    UITableView *tableview;
    
    CGRect tableviewOrginal;
    CGRect tableviewKeyboard;
    UITextField *studentIDtextField;
    UITextField *passwordTextField;
    UITextField *emailTextField;
    UITextField *subjectTextField;
    UITextView *contentTextView;
    UIPickerView *categoryPicker;
    UIToolbar *ActionSheetToolbar;
    UIView *actionsheetView;
    UILabel *categoryLabel;
    
    UIActionSheet *actionsheet;
}

@property (nonatomic, retain) IBOutlet UITextField *studentIDtextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (nonatomic, retain) IBOutlet UITextView *contentTextView;

@property (nonatomic, retain) IBOutlet UIPickerView *categoryPicker;
@property (nonatomic, retain) IBOutlet UIToolbar *ActionSheetToolbar;
@property (nonatomic, retain) IBOutlet UIView *actionsheetView;
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;


@property (nonatomic, retain) IBOutlet UIWebView *webview;

@property (nonatomic, retain) IBOutlet UITableViewCell *categorycell;
@property (nonatomic, retain) IBOutlet UITableViewCell *studentcell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordcell;
@property (nonatomic, retain) IBOutlet UITableViewCell *emailcell;
@property (nonatomic, retain) IBOutlet UITableViewCell *subjectcell;
@property (nonatomic, retain) IBOutlet UITableViewCell *contentcell;
@property (nonatomic, retain) IBOutlet UITableView *tableview;

#pragma Javascript
- (void)loginWithUserId:(NSString*)userid andPassword:(NSString*)password;
- (void)fillProposalWithCategory:(PROPOSAL_CATEGORY)category andReplyMail:(NSString*)email andSubject:(NSString*)subject andContent:(NSString*)content;
- (void)clickButtonWithName:(NSString*)name;

@end
