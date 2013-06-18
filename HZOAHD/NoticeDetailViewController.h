//
//  NoticeDetailViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-6.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Notice.h"
#import "SBTableAlert.h"

@interface NoticeDetailViewController : UIViewController <SBTableAlertDelegate,SBTableAlertDataSource>{
    UILabel *noticeTitle;
    UILabel *sender;
    UILabel *dateTime;
    UITextView *context;
    Notice *notice;
    UIButton *attchmentButton;
    NSString *frontFlag;
    NSString *fileId;
    NSArray *arrayFileIds;
    NSArray *arrayFileNames;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *noticeTitle;
@property (nonatomic, retain) IBOutlet UILabel *sender;
@property (nonatomic, retain) IBOutlet UILabel *dateTime;
@property (nonatomic, retain) IBOutlet UILabel *noticeType;
@property (nonatomic, retain) IBOutlet UITextView *context;
@property (nonatomic, retain) IBOutlet UIButton *attchmentButton;
@property (nonatomic, retain) Notice *notice;
@property (nonatomic, retain) NSString *frontFlag;
@property (nonatomic, retain) NSString *fileId;
@property (nonatomic, retain) NSArray *arrayFileIds;
@property (nonatomic, retain) NSArray *arrayFileNames;

@end
