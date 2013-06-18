//
//  AddMailViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TITokenField.h"
#import "JSTokenField.h"
#import "Mail.h"

@protocol AddMailDelegate <NSObject>

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *) buttonId;

@end

typedef enum {
    kMailTypeReplyMail,
    kMailTypeForwardMail,
    kMailTypeTmpMail,
    kMailTypeReplyAllMail
} MailType;

@interface AddMailViewController : UIViewController<TITokenFieldDelegate, UITextViewDelegate, AddMailDelegate, UIPickerViewDelegate, JSTokenFieldDelegate>
{
    TITokenFieldView *tokenFieldView;
	UITextView *messageView;
	UITextField *subTitle;
    UIButton *buttonChoose;
	CGFloat keyboardHeight;
    NSMutableArray *removeList;
    NSMutableDictionary *listContactId;
    NSMutableDictionary *listCCContactId;
    NSMutableArray *values;
    NSString *typeId;
    NSMutableArray *_toRecipients;
	NSMutableArray *_ccRecipients;
    JSTokenField *_toField;
	JSTokenField *_ccField;
    JSTokenField *_bccField;
    UILabel *subTitleLabel;
    UILabel *noticeLabel;
    NSMutableDictionary *usernamepasswordKVPairs;
    NSString *senderId;
    
    UIButton *toButton;
    UIButton *ccButton;
    UIButton *bccButton;
    UITextView *messageText;
    
    UISwitch *typeSwitch;
    UILabel *typeLabel;
    UITextField *titleText;
    UIView *sp1;
    UIButton *saveTmpButton;
    Mail *mail;
}

@property (nonatomic) MailType mailType;
@property (nonatomic, retain) IBOutlet JSTokenField *_toField;
@property (nonatomic, retain) IBOutlet JSTokenField *_ccField;
@property (nonatomic, retain) IBOutlet JSTokenField *_bccField;
@property (nonatomic, retain) IBOutlet UIButton *toButton;
@property (nonatomic, retain) IBOutlet UIButton *ccButton;
@property (nonatomic, retain) IBOutlet UIButton *bccButton;
@property (nonatomic, retain) IBOutlet UITextView *messageText;
@property (nonatomic, retain) IBOutlet UIButton *buttonChoose;
@property (nonatomic, retain) NSMutableDictionary *listContactId;
@property (nonatomic, retain) NSMutableDictionary *listCCContactId;
@property (nonatomic, retain) NSMutableArray *removeList;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) Mail *mail;
@property (nonatomic, retain) IBOutlet UISwitch *typeSwitch;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, retain) IBOutlet UITextField *titleText;
@property (nonatomic, retain) IBOutlet UIView *sp1;
@property (nonatomic, retain) IBOutlet UIButton *saveTmpButton;

- (IBAction)chooseEmailType:(id)sender;
- (IBAction)showContactsPicker:(id)sender;
- (IBAction)doSaveTmp:(id)sender;

@end
