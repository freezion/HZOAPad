//
//  TokenFieldExampleViewController.h
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TITokenField.h"
#import "UserKeychain.h"
#import "Notice.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "JSTokenField.h"
#import "SystemConfig.h"

@protocol AddNoticeDelegate <NSObject>

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName;

@end

@interface AddNoticeViewController : UIViewController <AddNoticeDelegate, UIPickerViewDelegate, JSTokenFieldDelegate>
{
	UITextView *messageView;
	UITextField *subTitle;
	CGFloat keyboardHeight;
    NSMutableArray *removeList;
    NSMutableDictionary *listContactId;
    NSArray *content;
    NSDictionary *dictionary;
    NSArray *keys;
    NSMutableArray *values;
    NSString *typeId;
    NSMutableArray *_toRecipients;
	NSMutableArray *_ccRecipients;
	
	JSTokenField *_toField;
	JSTokenField *_ccField;

    UILabel *noticeLabel;
    UIButton *toButton;
    UIButton *buttonChoose;
    UILabel *typeLabel;
    UILabel *subTitleLabel;
    
    SystemConfig *didSelectSystemConfig;
    UIView *sp2;
    UIView *sp3;
}

@property (nonatomic, retain) NSMutableDictionary *listContactId;
@property (nonatomic, retain) NSMutableArray *removeList;
@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) IBOutlet UITextView *messageView;
@property (nonatomic, retain) IBOutlet UITextField *subTitle;
@property (nonatomic, retain) IBOutlet JSTokenField *_toField;
@property (nonatomic, retain) IBOutlet UIButton *toButton;
@property (nonatomic, retain) IBOutlet UIButton *buttonChoose;

@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, retain) SystemConfig *didSelectSystemConfig;
@property (nonatomic, retain) IBOutlet UIView *sp2;
@property (nonatomic, retain) IBOutlet UIView *sp3;


- (IBAction)chooseNoticeType:(id)sender;
- (IBAction)showContactsPicker:(id)sender;

@end

