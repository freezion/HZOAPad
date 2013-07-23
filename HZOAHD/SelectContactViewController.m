//
//  SelectContactViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-12.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "SelectContactViewController.h"
#import "ContactViewController.h"
#import "ChooseEmployeeViewController.h"
#import "JSTokenButton.h"

@interface SelectContactViewController ()

@end

@implementation SelectContactViewController

@synthesize listContactId;
@synthesize delegate;
@synthesize tokens;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	// Configure content view
    self.view.backgroundColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.925 alpha:1.0];
	[self.navigationItem setTitle:@"添加被邀请人"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
    tokenFieldView = [[TITokenFieldView alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
	[self.view addSubview:tokenFieldView];
	
	[tokenFieldView.tokenField setDelegate:self];
    [tokenFieldView.tokenField setPromptText:@""];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
	[tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
	
	UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.tag = 2;
	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[tokenFieldView.tokenField setRightView:addButton];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [tokenFieldView.tokenField setRightViewMode:UITextFieldViewModeAlways];
    
    
    int i = 0;
    NSLog(@"%d",[tokens count]);
    for (TIToken *token in tokens) {
        NSLog(@"%@", token.title);
        TIToken *tokenLocal = [tokenFieldView.tokenField addTokenWithTitle:token.title];
        [tokenLocal setAccessibilityValue:[NSString stringWithFormat:@"%d", i]];
        [tokenLocal setIdValue:token.idValue];
        [tokenLocal setValue:token.value];
        [tokenLocal setTintColor:((i % 3) == 0 ? [TIToken redTintColor] : ((i % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
        i ++;
    }
    
    [tokenFieldView.tokenField becomeFirstResponder];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pweeetty.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self resizeViews];
}

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButtonId:(UIButton *)buttonId
{
    TIToken * token = [tokenFieldView.tokenField addTokenWithTitle:contactName];
    [token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
    NSUInteger tokenCount = tokenFieldView.tokenField.tokens.count;
    [token setAccessibilityValue:[NSString stringWithFormat:@"%d", tokenCount]];
    [token setValue:[NSString stringWithFormat:@"%d", tokenCount]];
    [token setIdValue:contactId];
    // If the size of the token might change, it's a good idea to layout again.
    [tokenFieldView.tokenField layoutTokensAnimated:YES]; 
    Employee *employee = [[Employee alloc] init];
    employee._id = contactId;
    employee._name = contactName;
    employee._forCC = @"2";
    [Employee insertTmpContact:employee];
    [token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
    
    [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", tokenCount]];
}

- (void)showContactsPicker:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SwitchViewController *switchViewController=[storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateSelectContact=self;
    switchViewController.buttonId = sender;
    UINavigationController *swichNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:swichNavController animated:YES];
}

- (void) deleteContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId {
    NSArray *arrayTokens = [tokenFieldView.tokenField tokens];
    for (TIToken *token in arrayTokens) {
        if ([token.idValue isEqualToString:contactId]) {
            [tokenFieldView.tokenField removeToken:token];
        }
    }

}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
	[tokenFieldView setFrame:((CGRect){tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height - keyboardHeight}})];
}

- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
	if (token.idValue != nil) {
        [self.listContactId removeObjectForKey:token.idValue];
    }
    return YES;
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	
}

- (void)textViewDidChange:(UITextView *)textView {	
	CGFloat oldHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
    
	[tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];
}

- (void)backAction:(id) sender {
    int count = [self.listContactId count];
    
    NSLog(@"%d",count);
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
    
    [delegate selectContactViewController:self didSelectContact:count withTokens:tokenFieldView.tokenField.tokens withInvations:receiveList withListContactId:listContactId];
    
//    int count = [self.listContactId count];
//    //    NSEnumerator *enumeratorValue = [self.listContactId objectEnumerator];
//    NSString *receiveList = @"";
//    //    int i = 0;
//    //    for (NSString *contactId in enumeratorValue) {
//    //        if (i == (count - 1)) {
//    //            receiveList = [receiveList stringByAppendingFormat:@"%@", contactId];
//    //        } else {
//    //            receiveList = [receiveList stringByAppendingFormat:@"%@,", contactId];
//    //        }
//    //        i ++;
//    //    }
//    
//    int j = 0;
//    for (JSTokenButton *button in toField.tokens) {
//        NSString *value = button.titleLabel.text;
//        receiveList = [receiveList stringByAppendingFormat:@"%@", value];
//        if (j != [toField.tokens count] - 1) {
//            receiveList = [receiveList stringByAppendingString:@","];
//        }
//        j ++;
//    }
//    
//    [delegate invitEmployeeViewController:self didSelectContact:count withTokens:toField.tokens withInvations:receiveList withListContactId:listContactId];
}

@end
