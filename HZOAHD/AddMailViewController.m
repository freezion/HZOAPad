//
//  AddMailViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "AddMailViewController.h"
#import "ContactViewController.h"
#import "SystemConfig.h"
#import "ChooseEmployeeViewController.h"
#import "Mail.h"
#import "FrequentContactViewController.h"
#import "SwitchViewController.h"

@interface AddMailViewController ()

@end

@implementation AddMailViewController
@synthesize listContactId;
@synthesize removeList;
@synthesize typeId;
@synthesize values;
@synthesize buttonChoose;
@synthesize _toField;
@synthesize _ccField;
@synthesize _bccField;
@synthesize toButton;
@synthesize ccButton;
@synthesize bccButton;
@synthesize typeLabel;
@synthesize messageText;
@synthesize typeSwitch;
@synthesize listCCContactId;
@synthesize subTitleLabel;
@synthesize titleText;
@synthesize sp1;
@synthesize mail;
@synthesize saveTmpButton;
@synthesize mailType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    typeId = @"0";
    NSMutableArray *systemConfigs = [SystemConfig loadSystemConfigById:@"2"];
    self.values = systemConfigs;
    
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"新邮件"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    self.listContactId = [NSMutableDictionary dictionary];
    self.listCCContactId = [NSMutableDictionary dictionary];
    self.removeList = [[NSMutableArray alloc] initWithCapacity:50];
    
    
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 60)];
    senderLabel.text = @"发件人:";
    [self.view addSubview:senderLabel];
    
    UILabel *senderName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 60)];
    senderName.text = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    [self.view addSubview:senderName];
    
    senderId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    
    [[_toField label] setText:@"收件人:"];
    [_toField setDelegate:self];
    
    [_toField addSubview:toButton];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0, _toField.bounds.size.height-1, _toField.bounds.size.width + 24, 1)];
    [separator1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_toField addSubview:separator1];
    [separator1 setBackgroundColor:[UIColor lightGrayColor]];
    
    [[_ccField label] setText:@"抄送:"];
    [_ccField setDelegate:self];
    [_ccField addSubview:ccButton];
    
    UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(0, _ccField.bounds.size.height-1, _ccField.bounds.size.width + 24, 1)];
    [separator2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_ccField addSubview:separator2];
    [separator2 setBackgroundColor:[UIColor lightGrayColor]];
    
    
    if (mail == nil) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
        UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(doSend)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        [[self navigationItem] setRightBarButtonItem:sendButton];
    
        _toRecipients = [[NSMutableArray alloc] init]; 
        
    }
    else {
        UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(doSend)];
        [[self navigationItem] setRightBarButtonItem:sendButton];
        saveTmpButton.hidden = YES;
        if (mailType == kMailTypeReplyMail) {
            [self.navigationItem setTitle:[@"Re:" stringByAppendingString:mail.title]];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
            [[self navigationItem] setLeftBarButtonItem:cancelButton];
            NSMutableString *recipient = [NSMutableString string];
            
            NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
            [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
            
            [_toField addTokenWithTitle:mail.senderName representedObject:recipient];
            
            int i = 0;
            NSArray *senderIds = [mail.sender componentsSeparatedByString:@","];
            for (NSString *senderIdentity in senderIds) {
                if (![senderIdentity isEqualToString:@""]) {
                    [self.listContactId setObject:senderId forKey:[NSString stringWithFormat:@"%d", i]];
                    i ++;
                }
            }

            titleText.text = [@"Re:" stringByAppendingString: mail.title];
            messageText.text = [NSString stringWithFormat:@"\n\n在 %@, %@ 写道: \n %@", mail.date, mail.senderName, mail.context];
            
        }
        //全部回复
        else if (mailType == kMailTypeReplyAllMail) {
            [self.navigationItem setTitle:[@"Re:" stringByAppendingString:mail.title]];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
            [[self navigationItem] setLeftBarButtonItem:cancelButton];
            NSMutableString *recipient = [NSMutableString string];
            
            NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
            [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        
            
            int i = 0;
            NSArray *senderIds = [mail.sender componentsSeparatedByString:@","];
            for (NSString *senderIdentity in senderIds) {
                if (![senderIdentity isEqualToString:@""]) {
                    [self.listContactId setObject:senderId forKey:[NSString stringWithFormat:@"%d", i]];
                    i ++;
                }
            }
            
            NSArray *daIds =[mail.ccList componentsSeparatedByString:@","];
            //int j = 0;
            for (NSString *daId in daIds) {
                if (![daId isEqualToString:@""]) {
                    [self.listContactId setObject:daId forKey:[NSString stringWithFormat:@"%d", i]];
                      i ++;
                }
            }
            
            NSArray *receiveIds=[mail.reciver componentsSeparatedByString:@","];
            //int k = 0;
            for (NSString *receiveId in receiveIds) {
                if (![receiveId isEqualToString:@""]) {
                    [self.listContactId setObject:receiveId forKey:[NSString stringWithFormat:@"%d", i]];
                    i ++;
                }
            }
            
            if ([listContactId count]>10) {
                
                NSString *allReceiveName=[mail.senderName stringByAppendingFormat:@"%@ %d %@",@"等",[listContactId count],@"个人"];
                [_toField addTokenWithTitle:allReceiveName representedObject:recipient];
            }else{
                
                [_toField addTokenWithTitle:mail.senderName representedObject:recipient];
                
                NSArray *das = [mail.ccListName componentsSeparatedByString:@","];
                for (NSString *da in das) {
                    [_toField addTokenWithTitle:da representedObject:recipient];
                }
                
                NSArray *receives=[mail.reciverName componentsSeparatedByString:@","];
                for (NSString *receive in receives) {
                    [_toField addTokenWithTitle:receive representedObject:recipient];
                }
            }
            
            titleText.text = [@"Re:" stringByAppendingString: mail.title];
            messageText.text = [NSString stringWithFormat:@"\n\n在 %@, %@ 写道: \n %@", mail.date, mail.senderName, mail.context];
            
        }
        else if (mailType == kMailTypeForwardMail) {
            [self.navigationItem setTitle:[@"Fw:" stringByAppendingString:mail.title]];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
            [[self navigationItem] setLeftBarButtonItem:cancelButton];
            titleText.text = [@"Fw:" stringByAppendingString: mail.title];
            messageText.text = [NSString stringWithFormat:@"\n\n在 %@, %@ 转发邮件内容: \n %@", mail.date, [usernamepasswordKVPairs objectForKey:KEY_USERNAME], mail.context];
            
        }
        else if (mailType == kMailTypeTmpMail){
             [self.navigationItem setTitle:mail.title];
//            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
//            [[self navigationItem] setLeftBarButtonItem:cancelButton];
            NSMutableString *recipient = [NSMutableString string];
            
            NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
            [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
            
            [_toField addTokenWithTitle:mail.senderName representedObject:recipient];
            
            NSArray *das = [mail.ccListName componentsSeparatedByString:@","];
            for (NSString *da in das) {
                [_ccField addTokenWithTitle:da representedObject:recipient];
            }
            int i = 0;
            NSArray *senderIds = [mail.sender componentsSeparatedByString:@","];
            for (NSString *senderIdentity in senderIds) {
                if (![senderIdentity isEqualToString:@""]) {
                    [self.listContactId setObject:senderId forKey:[NSString stringWithFormat:@"%d", i]];
                    i ++;
                }
            }
            NSArray *daIds =[mail.ccList componentsSeparatedByString:@","];
            int j = 0;
            for (NSString *daId in daIds) {
                if (![daId isEqualToString:@""]) {
                    [self.listCCContactId setObject:daId forKey:[NSString stringWithFormat:@"%d", j]];
                    j ++;
                }
            }
            titleText.text =  mail.title;
            messageText.text = mail.context;

            
        }
        else {
            if (![mail.reciverName isEqualToString:@""] && mail.reciverName != nil) {
                NSArray *reciverList = [mail.reciver componentsSeparatedByString:@","];
                NSArray *reciverNameList = [mail.reciverName componentsSeparatedByString:@","];
                for (int i = 0; i < [reciverNameList count]; i ++) {
                    [_toField addTokenWithTitle:[reciverNameList objectAtIndex:i] representedObject:[reciverList objectAtIndex:i]];
                    [self.listContactId setObject:[reciverList objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
                }
            }
            if (![mail.ccListName isEqualToString:@""] && mail.ccListName != nil) {
                NSArray *ccListList = [mail.ccList componentsSeparatedByString:@","];
                NSArray *ccListNameList = [mail.ccListName componentsSeparatedByString:@","];
                for (int i = 0; i < [ccListNameList count]; i ++) {
                    [_ccField addTokenWithTitle:[ccListNameList objectAtIndex:i] representedObject:[ccListList objectAtIndex:i]];
                    [self.listCCContactId setObject:[ccListList objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
                }
            }
        }
    }
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)doSend {
    if ([self checkEmailField]) {
        int count = [self.listContactId count];
        NSLog(@"数量: %d", count);
        // go webservice here
        NSEnumerator *enumeratorValue = [self.listContactId objectEnumerator];
        NSString *receiveList = @"";
        int i = 0;
        for (NSString *contactId in enumeratorValue) {
            if (i == (count - 1)) {
                receiveList = [receiveList stringByAppendingFormat:@"%@", contactId];
            } else {
                receiveList = [receiveList stringByAppendingFormat:@"%@,", contactId];
            }
            i ++;
        }
        
        int countCC = [self.listCCContactId count];
        NSLog(@"数量: %d", countCC);
        // go webservice here
        enumeratorValue = [self.listCCContactId objectEnumerator];
        NSString *CCList = @"";
        i = 0;
        for (NSString *contactId in enumeratorValue) {
            if (i == (countCC - 1)) {
                CCList = [CCList stringByAppendingFormat:@"%@", contactId];
            } else {
                CCList = [CCList stringByAppendingFormat:@"%@,", contactId];
            }
            i ++;
        }
        if (mail) {
            NSLog(@"%@",mail.ID);
            mail.title = titleText.text;
            mail.context = messageText.text;
            mail.date = [NSUtil parserDateToString:[NSDate date]];
            mail.reciver = receiveList;
            mail.ccList = CCList;
            mail.status=@"1";
        }
        else{
            mail = [[Mail alloc] init];
            mail.ID = @"";
            mail.title = titleText.text;
            mail.context = messageText.text;
            mail.date = [NSUtil parserDateToString:[NSDate date]];
            mail.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
            mail.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
            mail.reciver = receiveList;
            mail.ccList = CCList;
            mail.reciverName = @"";
            mail.fileId = @"";
            mail.fileName = @"";
            mail.readed = @"0";
            mail.importId = typeId;
            mail.importName = @"";
            mail.deptment = @"";
            // 已发送 1
            mail.status = @"1";
        }
        [Mail serviceAddEmail:mail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self doCancel];
    }
}

- (IBAction)doSaveTmp:(id)sender {
    int count = [self.listContactId count];
    NSLog(@"数量: %d", count);
    // go webservice here
    NSEnumerator *enumeratorValue = [self.listContactId objectEnumerator];
    NSString *receiveList = @"";
    int i = 0;
    for (NSString *contactId in enumeratorValue) {
        if (i == (count - 1)) {
            receiveList = [receiveList stringByAppendingFormat:@"%@", contactId];
        } else {
            receiveList = [receiveList stringByAppendingFormat:@"%@,", contactId];
        }
        i ++;
    }
    
    int countCC = [self.listCCContactId count];
    if ([receiveList isEqualToString:@""] || receiveList == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"在保存草稿之前请选择一个收件人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"数量: %d", countCC);
    // go webservice here
    enumeratorValue = [self.listCCContactId objectEnumerator];
    NSString *CCList = @"";
    i = 0;
    for (NSString *contactId in enumeratorValue) {
        if (i == (countCC - 1)) {
            CCList = [CCList stringByAppendingFormat:@"%@", contactId];
        } else {
            CCList = [CCList stringByAppendingFormat:@"%@,", contactId];
        }
        i ++;
    }
    
    mail = [[Mail alloc] init];
    mail.ID = @"";
    mail.title = titleText.text;
    mail.context = messageText.text;
    mail.date = [NSUtil parserDateToString:[NSDate date]];
    mail.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    mail.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    mail.reciver = receiveList;
    mail.ccList = CCList;
    mail.reciverName = @"";
    mail.fileId = @"";
    mail.fileName = @"";
    mail.readed = @"0";
    mail.importId = typeId;
    mail.importName = @"";
    mail.deptment = @"";
    // 已发送 1
    mail.status = @"0";
    [Mail serviceSaveEmail:mail];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    [self doCancel];
    
}

- (BOOL) checkEmailField {
    BOOL flag = YES;
    int count = [self.listContactId count];
    
    NSString *subTitleValue = [titleText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *messageViewValue = [messageText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([subTitleValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮件主题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];       
        flag = NO;
    } else if (count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择收件人，或者选择的收件人不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    } else if ([messageViewValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮件内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    } 
    return flag;
}

- (void)doCancel {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId
{
    if (buttonId == toButton) {
        [_toField addTokenWithTitle:contactName representedObject:contactId];
        [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", _toField.tokens.count]];
    }
    else {
        [_ccField addTokenWithTitle:contactName representedObject:contactId];
        [self.listCCContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", _ccField.tokens.count]];
    }
}

- (IBAction)showContactsPicker:(id)sender {

    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SwitchViewController *switchViewController=[storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateMail=self;
    switchViewController.buttonId=sender;
    
    UINavigationController *swichNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:swichNavController animated:YES];
}

- (IBAction)chooseEmailType:(id)sender {
    [subTitle resignFirstResponder];
    [tokenFieldView resignFirstResponder];
    [messageView resignFirstResponder];
    typeSwitch = (UISwitch *)sender;
    if (![typeSwitch isOn]) {
        typeId = @"0";
        typeLabel.text = @"普通";
        [typeLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    } else {
        typeId = @"1";
        typeLabel.text = @"紧急";
        [typeLabel setTextColor:[UIColor redColor]];
    }
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
}

#pragma mark - pickerView
#pragma mark 处理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [values count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ((SystemConfig *)[values objectAtIndex:row]).name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    SystemConfig *systemConfig = [values objectAtIndex:row];
    [buttonChoose setTitle:systemConfig.name forState:UIControlStateNormal];
    [buttonChoose setTitle:systemConfig.name forState:UIControlStateHighlighted];
    typeId = systemConfig.ID;
}

#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	NSDictionary *recipient = [NSDictionary dictionaryWithObject:obj forKey:title];
	[_toRecipients addObject:recipient];
	//NSLog(@"Added token for < %@ : %@ >\n%@", title, obj, _toRecipients);
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{	
	[_toRecipients removeObjectAtIndex:index];
    
    [self.listContactId removeObjectForKey:[NSString stringWithFormat:@"%d", index]];
    [self.listCCContactId removeObjectForKey:[NSString stringWithFormat:@"%d", index]];
	//NSLog(@"Deleted token %d\n%@", index, _toRecipients);
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSMutableString *recipient = [NSMutableString string];
	
	NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = [[tokenField textField] text];
	for (int i = 0; i < [rawStr length]; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if ([rawStr length])
	{
		[tokenField addTokenWithTitle:rawStr representedObject:recipient];
	}
    
    return NO;
}

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
	if ([[note object] isEqual:_toField])
	{
		[UIView animateWithDuration:0.0
						 animations:^{
                             [_ccField setFrame:CGRectMake(0, [_toField frame].size.height + [_toField frame].origin.y, [_ccField frame].size.width, [_ccField frame].size.height)];
                             [subTitleLabel setFrame:CGRectMake(subTitleLabel.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 80, [subTitleLabel frame].size.width, [subTitleLabel frame].size.height)];
                             [titleText setFrame:CGRectMake(titleText.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 78, [titleText frame].size.width, [titleText frame].size.height)];
                             [sp1 setFrame:CGRectMake(0, [_toField frame].size.height + [_toField frame].origin.y + 120, 1024, 1)];
                             [messageText setFrame:CGRectMake(0, _toField.frame.size.height + _toField.frame.origin.y + 122, messageText.frame.size.width, self.view.frame.size.height - 60 - _toField.frame.size.height - _ccField.frame.size.height)];
						 }
						 completion:nil];
	}
//    else if ([[note object] isEqual:_ccField])
//	{
//		[UIView animateWithDuration:0.0
//						 animations:^{
//                             [_bccField setFrame:CGRectMake(0, [_ccField frame].size.height + [_ccField frame].origin.y, [_bccField frame].size.width, [_bccField frame].size.height)];
//                             [messageText setFrame:CGRectMake(0, _ccField.frame.size.height + _ccField.frame.origin.y + 60, messageText.frame.size.width, self.view.frame.size.height - 60 - _toField.frame.size.height - _ccField.frame.size.height - _bccField.frame.size.height)];
//						 }
//						 completion:nil];
//	}
//    else if ([[note object] isEqual:_bccField])
//	{
//		[UIView animateWithDuration:0.0
//						 animations:^{
//                             [messageText setFrame:CGRectMake(0, _bccField.frame.size.height + _bccField.frame.origin.y, messageText.frame.size.width, self.view.frame.size.height - 60 - _toField.frame.size.height - _ccField.frame.size.height - _bccField.frame.size.height)];
//						 }
//						 completion:nil];
//	}
}

@end
