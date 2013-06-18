//
//  PopViewController.h
//  HZOAHD
//
//  Created by 潘 群 on 12-11-29.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import "Mail.h"

@interface PopViewController : UIViewController {
    UIGlossyButton *replyButton;
    UIGlossyButton *forwardButton;
    UIGlossyButton *replyAllButton;
    Mail *mail;
}

@property (nonatomic, retain) IBOutlet UIGlossyButton *replyButton;
@property (nonatomic, retain) IBOutlet UIGlossyButton *forwardButton;
@property (nonatomic, retain) IBOutlet UIGlossyButton *replyAllButton;
@property (nonatomic, retain) Mail *mail;

- (IBAction)showReplyEmailView:(id)sender;

- (IBAction)showReplyAllEmailView:(id)sender;

- (IBAction)showForwardEmailView:(id)sender;

@end
