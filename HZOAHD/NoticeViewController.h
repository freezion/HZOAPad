//
//  NoticeViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-2.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Employee.h"
#import "MBProgressHUD.h"
#import "NoticeDetailViewController.h"
#import "Notice.h"
#import "NoticeCell.h"
#import "AddNoticeViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"

@interface NoticeViewController : UITableViewController<EGORefreshTableHeaderDelegate, UINavigationBarDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
    
}

@property (nonatomic, strong) NSMutableArray *noticeList;

@end
