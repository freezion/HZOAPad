//
//  EventAlertViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventAlertViewController;

@protocol EventAlertViewDelegate <NSObject>
- (void)eventAlertViewController:(EventAlertViewController *)controller didSelectAlert:(NSString *) timer withSelectIndex:(int) selectedIndex withLabelTitle:(NSString *) title;
@end

@interface EventAlertViewController : UITableViewController {
    int selectedIndex;
    NSString *timerInterval;
    UITableViewCell *cellNone;
    UITableViewCell *cellFifteen;
    UITableViewCell *cellThirty;
    UITableViewCell *cellFortyfive;
    UITableViewCell *cellOneHour;
}

@property (nonatomic, retain) id<EventAlertViewDelegate> delegate;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) NSString *timerInterval;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellNone;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellFifteen;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellThirty;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellFortyfive;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellOneHour;

@end
