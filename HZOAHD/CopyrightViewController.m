//
//  CopyrightViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-11-19.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "CopyrightViewController.h"
#import "SystemConfig.h"

@interface CopyrightViewController ()

@end

@implementation CopyrightViewController
@synthesize appVersionLbl;
@synthesize urlButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"好" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    self.navigationItem.rightBarButtonItem = okButton;
   
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    appVersionLbl.text=app_Version;
    
    double app_Ver=[app_Version doubleValue];
    NSString *currVersion = [SystemConfig getVersion];
    
    if (app_Ver<[currVersion doubleValue]) {
        [urlButton setTitle:@"点击下载新版本" forState:UIControlStateNormal];
    }else{
        
    }
    
}

- (IBAction) goAppStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hua-zhong-she-nei-ban-gong/id562881419?mt=8"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelClick:(id) sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoUrl:(id)sender {
    NSURL* url = [[NSURL alloc] initWithString:@"http://www.shcs.com.cn/"];
    [[ UIApplication sharedApplication]openURL:url];
}

@end
