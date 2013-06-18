//
//  MyFolderViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-8.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Employee.h"
#import "MBProgressHUD.h"
#import "MyFolder.h"
#import "FileViewController.h"

@interface MyFolderViewController : UITableViewController<UINavigationBarDelegate, UINavigationControllerDelegate, EGORefreshTableHeaderDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSArray *folderList;
@property (strong,nonatomic) NSMutableArray *filteredCandyArray;
@property IBOutlet UISearchBar *searchBar;

@end
