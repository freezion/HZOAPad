//
//  FileViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-10-25.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFolder.h"
#import "FileCell.h"
#import "SVWebViewController.h"

@interface FileViewController : UITableViewController {
    NSString *memberId;
    NSMutableArray *fileList;
    NSString *needCancel;
}

@property (nonatomic, retain) NSString *memberId;
@property (nonatomic, retain) NSString *needCancel;
@property (nonatomic, retain) NSMutableArray *fileList;

@end
