//
//  MailDetailViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mail.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "UIButton+Property.h"

@protocol MailDetailDelegate <NSObject>

-(void)takeMailType:(NSString *)type;

@end

@interface MailDetailViewController : UIViewController<MailDetailDelegate, UIPopoverControllerDelegate> {
    UILabel *titleLabel;
    UILabel *senderLabel;
    UILabel *receiveLabel;
    UILabel *dateTime;
    UILabel *ccLabel;
    UIWebView *context;
    Mail *mail;
    UIButton *buttonName;
    UIButton *button;
    UIButton *moreButton;
    NSArray *arrayFileIds;
    NSArray *arrayFileNames;
    NSString *frontFlag;
    UIPopoverController *popover;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *senderLabel;
@property (nonatomic, retain) IBOutlet UILabel *receiveLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateTime;
@property (nonatomic, retain) IBOutlet UIWebView *context;
@property (nonatomic, retain) IBOutlet UIButton *moreButton;
@property (nonatomic, retain) IBOutlet UILabel *ccLabel;
@property (nonatomic, retain) Mail *mail;
@property (nonatomic, retain) UIButton *buttonName;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) NSString *mailType;
@property (nonatomic, retain) NSArray *arrayFileIds;
@property (nonatomic, retain) NSArray *arrayFileNames;
@property (nonatomic, retain) NSString *frontFlag;

- (IBAction)showPop:(id)sender forEvent:(UIEvent*)event;
- (IBAction)launchSafari:(id)sender;

@end
