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

- (void)didSelectContentCellAtRow:(NSUInteger)row withButtonId:(UIButton *) buttonId withIndexPath:(NSIndexPath *) indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    Employee *employee = [self.content objectAtIndex:row];
    BOOL flag = YES;
    UITableViewCell *thisCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        if (buttonId.tag == 0) {
            [Employee deleteTmpContact:employee._id withForCC:@"0"];
        } else if (buttonId.tag == 1) {
            [Employee deleteTmpContact:employee._id withForCC:@"1"];
        } else {
            [Employee deleteTmpContact:employee._id withForCC:@"2"];
        }
        flag = NO;
    }
    NSArray *selectedList = [[NSArray alloc] init];
    if (buttonId.tag == 0) {
        selectedList = [Employee getTmpContactByCC:@"0"];
    } else if (buttonId.tag == 1) {
        selectedList = [Employee getTmpContactByCC:@"1"];
    } else {
        selectedList = [Employee getTmpContactByCC:@"2"];
    }
    if (selectedList) {
        for (int i = 0; i < selectedList.count; i ++) {
            Employee *tmpEmployee = [selectedList objectAtIndex:i];
            if ([tmpEmployee._id isEqualToString:employee._id]) {
                flag = NO;
                break;
            }
        }
    }
    if (flag) {
        [delegateMail showContact:employee._id theName:employee._name withButton:buttonId];
        [delegateSelectContact showContact:employee._id theName:employee._name withButtonId:buttonId];
    } else {
        [delegateMail deleteContact:employee._id theName:employee._name withButton:buttonId];
        [delegateSelectContact deleteContact:employee._id theName:employee._name withButton:buttonId];
    }
    if (delegateFrequentContact) {
        [delegateFrequentContact addFrequentContact:employee._id :employee._name];
        [delegateSwitchView dismissViewController];
    }
    //[delegateMail showContact:employee._id theName:employee._name withButton:buttonId];
    //[delegateSelectContact showContact:employee._id theName:employee._name];
    
    //[delegateNotice showContact:employee._id theName:employee._name];
    //[delegateSwitchView dismissViewController];
}

- (void)dealloc {
    self.content = nil;
    self.title = nil;
    
    [super dealloc];
}

@end
