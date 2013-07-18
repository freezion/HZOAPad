//
//  TmpMailViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-18.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MailCell.h"
#import "Mail.h"

@interface TmpMailViewController : UITableViewController <UINavigationBarDelegate, UINavigationControllerDelegate, EGORefreshTableHeaderDelegate, UIAlertViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL editFlag;
    NSString *deleteList;
}

@property (nonatomic, strong) NSMutableArray *mailList;
@property (nonatomic) BOOL editFlag;
@property (retain, nonatomic) NSString *deleteList;

@end
