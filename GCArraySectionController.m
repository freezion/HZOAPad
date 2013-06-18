//
//  GCArraySectionController.m
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCArraySectionController.h"
#import "Employee.h"

@interface GCArraySectionController ()

@property (nonatomic, retain) NSArray* content;

@end

@implementation GCArraySectionController

@synthesize content, title;
@synthesize delegateMail;
@synthesize delegateSelectContact;
@synthesize delegateFrequentContact;
@synthesize delegateSwitchView;
@synthesize delegateNotice;
//@synthesize delegateFreConDis;


- (id)initWithArray:(NSArray *)array viewController:(UIViewController *)givenViewController {
    if ((self = [super initWithViewController:givenViewController])) {
        self.content = array;
    }
    return self;
}

#pragma mark -
#pragma mark Subclass

- (NSUInteger)contentNumberOfRow {
    return [self.content count];
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

- (Employee *)titleContentForEmployee:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

- (void)didSelectContentCellAtRow:(NSUInteger)row  withButtonId:(UIButton *) buttonId {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
    Employee *employee = [self.content objectAtIndex:row];
    [delegateMail showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateSelectContact showContact:employee._id theName:employee._name];
    [delegateFrequentContact addFrequentContact:employee._id :employee._name];
    [delegateNotice showContact:employee._id theName:employee._name];
    [delegateSwitchView dismissViewController];
}

- (void)dealloc {
    self.content = nil;
    self.title = nil;
    
    [super dealloc];
}

@end
