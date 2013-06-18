//
//  ContactViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-3.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoticeViewController.h"
#import "AddMailViewController.h"

#import "ContactCell.h"
#import "Employee.h"
#import "SelectContactViewController.h"

@interface ContactViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	NSArray *list;
    id<AddNoticeDelegate> delegate;
    id<AddMailDelegate> delegateMail;
    id<SelectContactDelegate> delegateContact;
    UIButton *buttonId;
    NSMutableDictionary *dictionary;
}

@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) UIButton *buttonId;
@property (nonatomic, retain) id<AddNoticeDelegate> delegate;
@property (nonatomic, retain) id<AddMailDelegate> delegateMail;
@property (nonatomic, retain) id<SelectContactDelegate> delegateContact;

@end
