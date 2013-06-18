//
//  UITabBarController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "UITabBarController.h"

@implementation UITabBarController (rotation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
