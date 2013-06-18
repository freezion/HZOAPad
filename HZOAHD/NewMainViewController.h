//
//  NewMainViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 13-1-4.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate> {
    UIButton *calendarButton;
    UIButton *noticeButton;
    UIButton *emailButton;
    UIButton *folderButton;
    UIButton *changeLoginButton;
    UIButton *rightsButton;
    UIButton *exitButton;
    UIPopoverController *popover;
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) IBOutlet UIButton *noticeButton;
@property (nonatomic, retain) IBOutlet UIButton *emailButton;
@property (nonatomic, retain) IBOutlet UIButton *folderButton;
@property (nonatomic, retain) IBOutlet UIButton *changeLoginButton;
@property (nonatomic, retain) IBOutlet UIButton *rightsButton;
@property (nonatomic, retain) IBOutlet UIButton *exitButton;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)tappedButton:(id)sender;

@end
