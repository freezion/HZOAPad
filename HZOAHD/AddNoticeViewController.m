//
//  TokenFieldExampleViewController.m
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import "AddNoticeViewController.h"
#import "ContactViewController.h"
#import "SystemConfig.h"
#import "ChooseEmployeeViewController.h"

@interface AddNoticeViewController (Private)
- (void)resizeViews;
@end

@implementation AddNoticeViewController
@synthesize listContactId;
@synthesize removeList;
@synthesize content;
@synthesize buttonChoose;
@synthesize dictionary;
@synthesize keys;
@synthesize values;
@synthesize typeId;
@synthesize messageView;
@synthesize subTitle;
@synthesize _toField;
@synthesize toButton;
@synthesize typeLabel;
@synthesize subTitleLabel;
@synthesize sp2;
@synthesize sp3;
@synthesize didSelectSystemConfig;


- (void)viewDidLoad {
	
    [super viewDidLoad];
        
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"新公告"];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(doSend)];
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    [[self navigationItem] setRightBarButtonItem:sendButton];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
	
//	_toRecipients = [[NSMutableArray alloc] init];
//	
//	[[_toField label] setText:@"收件人:"];
//	[_toField setDelegate:self];
//    //[_toField addSubview:toButton];
//    
//    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(-20, _toField.bounds.size.height-1, 1024, 1)];
//    [separator1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
//    [_toField addSubview:separator1];
//    [separator1 setBackgroundColor:[UIColor lightGrayColor]];
//
    self.listContactId = [NSMutableDictionary dictionary];    
//    self.removeList = [[NSMutableArray alloc] initWithCapacity:50];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (IBAction)chooseNoticeType:(id)sender {
    
    [subTitle resignFirstResponder];
    [messageView resignFirstResponder];
    //[_toField.textField resignFirstResponder];
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-260, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    pickerView.tag = 10;
    pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
    if (didSelectSystemConfig==nil) {
        [buttonChoose setTitle:((SystemConfig *)[values objectAtIndex:0]).name forState:UIControlStateNormal];
    }
    [self.view addSubview:pickerView];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    pickerView.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
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

- (void)doSend {
    if ([self checkNoticeField]) {
        int count = [self.listContactId count];
        NSLog(@"数量: %d", count);
        //get userKeychain
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
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
    
        Notice *notice = [[Notice alloc] init];
        notice.ID = @"";
        notice.title = subTitle.text;
        notice.context = messageView.text;
        notice.date = [NSUtil parserDateToString:[NSDate date]];
        notice.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        notice.reciver = receiveList;
        notice.readed = @"";
        if (didSelectSystemConfig == nil) {
            SystemConfig *systemConfig = [values objectAtIndex:0];
            notice.typeId = systemConfig.typeId;
        } else {
            notice.typeId = didSelectSystemConfig.typeId;
        }
        notice.typeName = @"";
        notice.deptment = @"";
        notice.status = @"2";
        [Notice serviceAddNotice:notice];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self doCancel];
    }
}

- (BOOL) checkNoticeField {
    BOOL flag = YES;
    //int count = [self.listContactId count];
    NSString *subTitleValue = [subTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *messageViewValue = [messageView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([subTitleValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入公告标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];       
        flag = NO;
    } else if ([messageViewValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入公告内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    }
    return flag;
}

- (void)doCancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName 
{
    [_toField addTokenWithTitle:contactName representedObject:contactId];
    [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", _toField.tokens.count]];
//    TIToken * token = [tokenFieldView.tokenField addTokenWithTitle:contactName];
//    [token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
//    NSUInteger tokenCount = tokenFieldView.tokenField.tokens.count;
//    [token setAccessibilityValue:[NSString stringWithFormat:@"%d", tokenCount]];
//    // If the size of the token might change, it's a good idea to layout again.
//    [tokenFieldView.tokenField layoutTokensAnimated:YES]; 
//    
//    [token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
//    
//    [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", tokenCount]];
}

- (IBAction)showContactsPicker:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SwitchViewController *switchViewController=[storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateNotice=self;
    //switchViewController.buttonId=sender;
    
    UINavigationController *swichNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:swichNavController animated:YES];}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	//[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
	//[self resizeViews];
}

#pragma mark - pickerView
#pragma mark 处理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [values count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 
    return ((SystemConfig *)[values objectAtIndex:row]).name;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    didSelectSystemConfig=[values objectAtIndex:row];
    [buttonChoose setTitle:didSelectSystemConfig.name forState:UIControlStateNormal];
    [buttonChoose setTitle:didSelectSystemConfig.name forState:UIControlStateHighlighted];
    
    
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
                             [sp2  setFrame:CGRectMake(0, [_toField frame].size.height + [_toField frame].origin.y + 60, 1024, 1)];
                             [sp3  setFrame:CGRectMake(0, [_toField frame].size.height + [_toField frame].origin.y + 120, 1024, 1)];
							 [typeLabel setFrame:CGRectMake(typeLabel.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 20, typeLabel.frame.size.width, typeLabel.frame.size.height)];
                             [buttonChoose setFrame:CGRectMake(buttonChoose.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 20, buttonChoose.frame.size.width, buttonChoose.frame.size.height)];
                             [subTitleLabel setFrame:CGRectMake(subTitleLabel.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 70, 100, 42)];
                             [subTitle setFrame:CGRectMake(subTitle.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 80, subTitle.frame.size.width, subTitle.frame.size.height)];
                             [messageView setFrame:CGRectMake(messageView.frame.origin.x, [_toField frame].size.height + [_toField frame].origin.y + 140, 1024, self.view.frame.size.height - [_toField frame].size.height - 60)];
						 }
						 completion:nil];
	}
}

@end