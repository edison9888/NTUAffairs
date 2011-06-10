//
//  FirstViewController.m
//  NTUAffairs
//
//  Created by fawkes1234 on 2011/5/7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize studentIDtextField;
@synthesize passwordTextField;
@synthesize emailTextField;
@synthesize subjectTextField;
@synthesize contentTextView;
@synthesize categoryPicker;
@synthesize ActionSheetToolbar;
@synthesize actionsheetView;
@synthesize categoryLabel;
@synthesize webview;
@synthesize categorycell;
@synthesize studentcell;
@synthesize passwordcell;
@synthesize emailcell;
@synthesize subjectcell;
@synthesize contentcell;
@synthesize tableview;

#pragma mark - UITableView animations

- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if (movedUp) {    
        self.tableview.frame = tableviewKeyboard;
        if ([self.emailTextField isFirstResponder]) {
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        if ([self.subjectTextField isFirstResponder]) {
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        if ([self.contentTextView isFirstResponder]) {
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    } else {
        self.tableview.frame = tableviewOrginal;
    }
    [UIView commitAnimations];
}

- (void)showKeyboard {
    [self setViewMovedUp:YES];
}

- (void)hideKeyboard {
    [self setViewMovedUp:NO];
}

#pragma mark - View Life Cycle


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidLoad
{
    // set title
    self.title = @"校務建言";
    
    // listen for keyboard appear notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (showKeyboard)
                                                 name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector (hideKeyboard)
                                                 name: UIKeyboardWillHideNotification object:nil];
    
    // set table view animation frame
    tableviewOrginal = CGRectMake(0, 0, self.tableview.frame.size.width, self.tableview.frame.size.height);
    tableviewKeyboard = CGRectMake(0, 0, self.tableview.frame.size.width, self.tableview.frame.size.height-167);
    
    // hide webview
    webview.frame = CGRectZero;
    
    // set default category
    proposal_category = PROPOSAL_CATEGORY_OTHER;
    
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload
{
    [self setWebview:nil];
    [self setStudentcell:nil];
    [self setPasswordcell:nil];
    [self setEmailcell:nil];
    [self setSubjectcell:nil];
    [self setContentcell:nil];
    [self setTableview:nil];
    [self setStudentIDtextField:nil];
    [self setPasswordTextField:nil];
    [self setEmailTextField:nil];
    [self setSubjectTextField:nil];
    [self setContentTextView:nil];
    [self setCategorycell:nil];
    [self setCategoryPicker:nil];
    [self setActionSheetToolbar:nil];
    [self setActionsheetView:nil];
    [self setCategoryLabel:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [webview release];
    [studentcell release];
    [passwordcell release];
    [emailcell release];
    [subjectcell release];
    [contentcell release];
    [tableview release];
    [studentIDtextField release];
    [passwordTextField release];
    [emailTextField release];
    [subjectTextField release];
    [contentTextView release];
    [categorycell release];
    [categoryPicker release];
    [ActionSheetToolbar release];
    [actionsheetView release];
    [categoryLabel release];
    [super dealloc];
}

- (IBAction)submit:(id)sender {
    customAlertView = [[[CustomAlertView alloc] initWithText:@"登入中..."] autorelease];
    [customAlertView show];
    
    // hide keyboard
    [self.studentIDtextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.subjectTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];

    // load web page
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mis.cc.ntu.edu.tw/suggest/asp/list.asp"]];
    [webview loadRequest:request];
    load_page = LOAD_LOGIN_PAGE;

}


#pragma mark - UIWebViewDeleate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    switch (load_page) {
        case LOAD_LOGOUT_PAGE:
            NSLog(@"logged out");
            break;
            
        case LOAD_PROPOSE_POSTED_PAGE:
            customAlertView.alertTextLabel.text = @"成功！";
            [customAlertView performSelector:@selector(dismiss) withObject:nil afterDelay:3.0];
            NSLog(@"propose posted");
            // logout
            NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mis.cc.ntu.edu.tw/suggest/asp/mainfunc.asp?act=%B5n%A5X"]];
            [webview loadRequest:request2];
            load_page = LOAD_LOGOUT_PAGE;
            break;
            
        case LOAD_PROPOSE_PAGE:
            NSLog(@"did load propose page");
            // fill form
            [self performSelector:@selector(fillProposal) withObject:nil afterDelay:0.5];
            // click send button
            [self performSelector:@selector(clickButtonWithName:) withObject:@"B1" afterDelay:1.0];
            load_page = LOAD_PROPOSE_POSTED_PAGE;
            break;
            
        case LOAD_HOME_PAGE:
            customAlertView.alertTextLabel.text = @"建言上傳中...";
            NSLog(@"did load propose home page");
            // now load the proposal page
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mis.cc.ntu.edu.tw/suggest/asp/propose.asp"]];
            [webview loadRequest:request];
            load_page = LOAD_PROPOSE_PAGE;
            break;
            
        case LOAD_LOGIN_PAGE:
            if (webview.tag == 33) {
                NSLog(@"did load login page");
                [self loginWithUserId:self.studentIDtextField.text andPassword:self.passwordTextField.text];
                [self performSelector:@selector(clickButtonWithName:) withObject:@"Submit" afterDelay:1.0];
                load_page = LOAD_HOME_PAGE;
            }
            webview.tag = 33;
            break;
            
        default:
            break;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (customAlertView != nil) {
        [customAlertView dismiss];
        customAlertView = nil;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    NSLog(@"didFailLoadWithError = %@",error);
}

#pragma mark - UIActionsheet

- (void)showPicker{
    actionsheet = [[UIActionSheet alloc] initWithTitle:nil
                                       delegate:self
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil];
    
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet addSubview:actionsheetView];
    [actionsheet showInView:self.view];
    [actionsheet setBounds:CGRectMake(0,0,320,499)];
    [actionsheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@" clicked index %d",buttonIndex);
}

#pragma mark - Javascript

- (void)loginWithUserId:(NSString*)userid andPassword:(NSString*)password {
    NSString *js = [NSString stringWithFormat:@"var script = document.createElement('script');"
                    "script.type = 'text/javascript';"
                    "script.text = \"function js_login() { "
                    "arr = new Array();"
                    "arr = document.getElementsByName('user');"
                    "arr.item(0).value = '%@';"
                    "arr = document.getElementsByName('pass');"
                    "arr.item(0).value = '%@';"
                    "}\";"
                    "document.getElementsByTagName('head')[0].appendChild(script);",userid,password];
    [webview stringByEvaluatingJavaScriptFromString:js];
    [webview stringByEvaluatingJavaScriptFromString:@"js_login();"];
}

//- (void)selectCategory {
//    NSString *js = [NSString stringWithFormat:@"var script = document.createElement('script');"
//                    "script.type = 'text/javascript';"
//                    "script.text = \"function js_selectCategory() { "
//                    "arr = new Array();"
//                    "arr = document.getElementsByName('catalogid');"
//                    "arr.item(0).click();"
//                    "}\";"
//                    "document.getElementsByTagName('head')[0].appendChild(script);"];
//    [webview stringByEvaluatingJavaScriptFromString:js];
//    [webview stringByEvaluatingJavaScriptFromString:@"js_selectCategory();"];
//}

- (IBAction)fillProposal {
    NSLog(@"fillProposal");
    [self fillProposalWithCategory:proposal_category andReplyMail:self.emailTextField.text andSubject:self.subjectTextField.text andContent:self.contentTextView.text];
}

- (void)fillProposalWithCategory:(PROPOSAL_CATEGORY)category andReplyMail:(NSString*)email andSubject:(NSString*)subject andContent:(NSString*)content {
    NSLog(@"%d %@ %@ %@",category,email,subject,content);
    if ([email isEqualToString:@""]) {
        // don't change email field in form
        NSString *js = [NSString stringWithFormat:@"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function js_fillproposal() { "
                        "arr = new Array();"
                        "arr = document.getElementsByName('catalogid');"
                        "arr.item(0).value = '%d';"
                        "arr = document.getElementsByName('SUBJECT');"
                        "arr.item(0).value = '%@';"
                        "arr = document.getElementsByName('content');"
                        "arr.item(0).value = '%@';"
                        "}\";"
                        "document.getElementsByTagName('head')[0].appendChild(script);"
                        ,category
                        ,subject
                        ,[content stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        [webview stringByEvaluatingJavaScriptFromString:js];
        [webview stringByEvaluatingJavaScriptFromString:@"js_fillproposal();"];
    } else {
        NSString *js = [NSString stringWithFormat:@"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function js_fillproposal() { "
                        "arr = new Array();"
                        "arr = document.getElementsByName('catalogid');"
                        "arr.item(0).value = '%d';"
                        "arr = document.getElementsByName('replyemail');"
                        "arr.item(0).value = '%@';"
                        "arr = document.getElementsByName('SUBJECT');"
                        "arr.item(0).value = '%@';"
                        "arr = document.getElementsByName('content');"
                        "arr.item(0).value = '%@';"
                        "}\";"
                        "document.getElementsByTagName('head')[0].appendChild(script);"
                        ,category
                        ,email
                        ,subject
                        ,[content stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        [webview stringByEvaluatingJavaScriptFromString:js];
        [webview stringByEvaluatingJavaScriptFromString:@"js_fillproposal();"];
    }
}

- (void)clickButtonWithName:(NSString*)name {
    NSLog(@"clickButtonWithName %@",name);
    NSString *js = [NSString stringWithFormat:
                    @"var script = document.createElement('script');"
                    "script.type = 'text/javascript';"
                    "script.text = \"function js_clickbtn() { "
                    "var arr = document.getElementsByName('%@');"
                    "arr.item(0).click()"
                    "}\";"
                    "document.getElementsByTagName('head')[0].appendChild(script);",name];
    [webview stringByEvaluatingJavaScriptFromString:js];
    [webview stringByEvaluatingJavaScriptFromString:@"js_clickbtn();"];    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 1) {
        NSLog(@"load category selector");
        [self showPicker];
        [self clickButtonWithName:@"Submit"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return studentcell.frame.size.height;
                case 1:
                    return passwordcell.frame.size.height;
            }
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    return categorycell.frame.size.height;
                case 1:
                    return emailcell.frame.size.height;
                case 2:
                    return subjectcell.frame.size.height;
                case 3:
                    return contentcell.frame.size.height;
            }
    }
    return 0;
}

#pragma mark - UITableViewDatasource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return studentcell;
                case 1:
                    return passwordcell;
            }

        case 1:
            switch (indexPath.row) {
                case 0:
                    return categorycell;
                case 1:
                    return emailcell;
                case 2:
                    return subjectcell;
                case 3:
                    return contentcell;
            }
    }
    return nil;
}

#pragma mark - UIPickerView Delegate

- (IBAction)dismissActionSheet:(id)sender {
//    - (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
    [actionsheet dismissWithClickedButtonIndex:0 animated:YES];

}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"校務";
        case 1:
            return @"教務";
        case 2:
            return @"學生事務";
        case 3:
            return @"總務";
        case 4:
            return @"學雜費";
        case 5:
            return @"其他";
        default:
            break;
    }
    return @"";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow %d",row);
    switch (row) {
        case 0:
            self.categoryLabel.text = @"校務";
            proposal_category = PROPOSAL_CATEGORY_SCHOOL;
            break;
        case 1:
            self.categoryLabel.text = @"教務";
            proposal_category = PROPOSAL_CATEGORY_TEACHING;
            break;
        case 2:
            self.categoryLabel.text = @"學生事務";
            proposal_category = PROPOSAL_CATEGORY_STUDENT;
            break;
        case 3:
            self.categoryLabel.text = @"總務";
            proposal_category = PROPOSAL_CATEGORY_FINANCE;
            break;
        case 4:
            self.categoryLabel.text = @"學雜費";
            proposal_category = PROPOSAL_CATEGORY_TUITION;
            break;
        case 5:
            self.categoryLabel.text = @"其他";
            proposal_category = PROPOSAL_CATEGORY_OTHER;
            break;
        default:
            break;
    }
}

#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;
}

@end
