//
//  ChooseMostViewController.h
//  HZOAHD
//
//  Created by Li Feng on 13-2-4.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMailViewController.h"
#import "SwitchViewController.h"
#import "SelectContactViewController.h"
#import "FrequentContactViewController.h"

@interface ChooseMostViewController : UITableViewController{
    NSMutableArray *mostList;
    UIButton *buttonId;
    id<SwitchViewDelegate> delegateSwitchView;
    id<AddMailDelegate> delegateMail;
    id<AddNoticeDelegate> delegateNotice;
    id<SelectContactDelegate> delegateSelectContact;
    id<FrequentContactDelegate> delegateFrequentContact;
}
@property (nonatomic, retain) NSMutableArray *mostList;
@property (nonatomic, retain) UIButton *buttonId;
@property (nonatomic, retain) id<AddMailDelegate> delegateMail;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;
@property (nonatomic, retain) id<AddNoticeDelegate> delegateNotice;
@property (nonatomic, retain) id<SelectContactDelegate> delegateSelectContact;
@property (nonatomic, retain) id<FrequentContactDelegate> delegateFrequentContact;

@end
