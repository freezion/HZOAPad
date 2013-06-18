//
//  GCArraySectionController.h
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRetractableSectionController.h"
#import "AddNoticeViewController.h"
#import "AddMailViewController.h"
#import "ContactCell.h"
#import "Employee.h"
#import "SelectContactViewController.h"
#import "FrequentContactViewController.h"
#import "SwitchViewController.h"


//This is a GCRetractableSectionController that take a NSArray and display it like the simple example did.
//You can use it directly in your project if your retractable controller is simple!

@interface GCArraySectionController : GCRetractableSectionController {

    id<AddMailDelegate> delegateMail;
    id<SelectContactDelegate> delegateSelectContact;
    id<FrequentContactDelegate> delegateFrequentContact;
    id<SwitchViewDelegate> delegateSwitchView;
    id<AddNoticeDelegate> delegateNotice;
    //id<FrequentContactDismissViewDelegate>delegateFreConDis;
    
}

@property (nonatomic, copy, readwrite) NSString* title;
@property (nonatomic, retain) id<AddMailDelegate> delegateMail;
@property (nonatomic, retain) id<SelectContactDelegate> delegateSelectContact;
@property (nonatomic, retain) id<FrequentContactDelegate> delegateFrequentContact;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;
@property (nonatomic, retain) id<AddNoticeDelegate> delegateNotice;
//@property (nonatomic, retain) id<FrequentContactDismissViewDelegate>delegateFreConDis;

- (id)initWithArray:(NSArray*) array viewController:(UIViewController *)givenViewController;

@end
