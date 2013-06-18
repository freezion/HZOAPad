//
//  CopyrightViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-11-19.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopyrightViewController : UIViewController{
    UILabel *appVersionLbl;
    UIButton *urlButton;
}

@property (nonatomic, retain) IBOutlet UILabel *appVersionLbl;
@property (nonatomic, retain) IBOutlet UIButton *urlButton;

- (IBAction)gotoUrl:(id)sender;
- (IBAction) goAppStore:(id)sender;

@end
