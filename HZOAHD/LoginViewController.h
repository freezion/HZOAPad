//
//  LoginViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-7-27.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GDataXMLNode.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, NSXMLParserDelegate> {
    UITextField *txtUser;
	UITextField *txtPass;
    UIButton *btnLogin;
    MBProgressHUD *HUD;
    //BOOL _flag;
    NSString *flag;
}

@property (retain, nonatomic) IBOutlet UITextField *txtUser;
@property (retain, nonatomic) IBOutlet UITextField *txtPass;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;

- (IBAction)login:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)cancelFunc:(id) sender;

@end
