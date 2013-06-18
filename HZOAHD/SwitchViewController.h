//
//  SwitchViewController.h
//  HZOAHD
//
//  Created by Li Feng on 13-2-4.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMailViewController.h"
#import "AddNoticeViewController.h"
#import "SelectContactViewController.h"
#import "FrequentContactViewController.h"

@class ChooseEmployeeViewController;
@class ChooseMostViewController;


@protocol SwitchViewDelegate <NSObject>
- (void) dismissViewController;
@end


@interface SwitchViewController : UIViewController<SwitchViewDelegate>{
    ChooseEmployeeViewController *chooseEmployeeViewController;
    ChooseMostViewController *chooseMostViewController;
    int status;
    UIButton *buttonId;
    id<SwitchViewDelegate> delegateSwitchView;
    id<AddMailDelegate> delegateMail;
    id<AddNoticeDelegate> delegateNotice;
    id<SelectContactDelegate> delegateSelectContact;
    id<FrequentContactDelegate>delegateFrequentContact;
    
}
@property (nonatomic, retain) ChooseMostViewController *chooseMostViewController;
@property (nonatomic, retain) ChooseEmployeeViewController *chooseEmployeeViewController;
@property (nonatomic, retain) UIButton *buttonId;
@property (nonatomic) int status;
@property (nonatomic, retain) id<AddMailDelegate> delegateMail;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;
@property (nonatomic, retain) id<AddNoticeDelegate> delegateNotice;
@property (nonatomic, retain) id<SelectContactDelegate> delegateSelectContact;
@property (nonatomic, retain) id<FrequentContactDelegate> delegateFrequentContact;

@end
