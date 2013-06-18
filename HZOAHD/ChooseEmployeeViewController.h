//
//  ChooseEmployeeViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-24.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoticeViewController.h"
#import "AddMailViewController.h"
#import "ContactCell.h"
#import "Employee.h"
#import "SelectContactViewController.h"
#import "GCArraySectionController.h"
#import "FrequentContactViewController.h"
#import "SwitchViewController.h"
#import "AddNoticeViewController.h"


@interface ChooseEmployeeViewController : UITableViewController{
    
    id<AddMailDelegate> delegateMail;
    id<SelectContactDelegate> delegateSelectContact;
    id<FrequentContactDelegate> delegateFrequentContact;
    //id<FrequentContactDismissViewDelegate>delegateFreConDis;
    id<SwitchViewDelegate> delegateSwitchView;
    id<AddNoticeDelegate> delegateNotice;
    UIButton *buttonId;
    NSMutableDictionary *dictionary;
    NSMutableArray* retractableControllers;
    GCArraySectionController *arrayController;
}

@property (nonatomic, retain) GCArraySectionController *arrayController;
@property (nonatomic, retain) NSMutableArray* retractableControllers;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) UIButton *buttonId;

@property (nonatomic, retain) id<AddMailDelegate> delegateMail;
@property (nonatomic, retain) id<SelectContactDelegate> delegateSelectContact;
@property (nonatomic, retain) id<FrequentContactDelegate> delegateFrequentContact;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;
//@property (nonatomic, retain) id<FrequentContactDismissViewDelegate>delegateFreConDis;
@property (nonatomic, retain) id<AddNoticeDelegate> delegateNotice;

@end
