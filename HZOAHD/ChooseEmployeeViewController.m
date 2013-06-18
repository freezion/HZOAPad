//
//  ChooseEmployeeViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-24.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseEmployeeViewController.h"
#import "GCSimpleSectionController.h"
#import "GCArraySectionController.h"
#import "GCCustomSectionController.h"
#import "GCEmptySectionController.h"

@interface ChooseEmployeeViewController ()

@end

@implementation ChooseEmployeeViewController

@synthesize dictionary;
@synthesize delegateSelectContact;
@synthesize delegateMail;
@synthesize list;
@synthesize buttonId;
@synthesize retractableControllers;
@synthesize arrayController;
@synthesize delegateFrequentContact;
@synthesize delegateSwitchView;
@synthesize delegateNotice;
//@synthesize delegateFreConDis;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择发送人";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    self.dictionary = [[NSMutableDictionary alloc] init];
	//分配给list
	self.list = [NSArray arrayWithArray:[Employee getAllEmployee]];
    for (int i = 0; i < [list count]; i ++) {
        Employee *employee = [list objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        BOOL flag = NO;
        for (NSString *currentValue in [dictionary allKeys])
        {
            if ([currentValue isEqualToString:employee._partyName]) {
                flag = YES;
            }
        }
        if (flag) {
            array = [dictionary objectForKey:employee._partyName];
            [array addObject:employee];
            [dictionary setObject:array forKey:employee._partyName];
        } else {
            [array addObject:employee];
            [dictionary setObject:array forKey:employee._partyName];
        }
    }
    self.retractableControllers = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSArray *value = [dictionary objectForKey:key];
        arrayController = [[GCArraySectionController alloc] initWithArray:value viewController:self];
        arrayController.title = NSLocalizedString(key,);
        arrayController.delegateMail = delegateMail;
        arrayController.delegateSelectContact = delegateSelectContact;
        arrayController.delegateFrequentContact=delegateFrequentContact;
        arrayController.delegateSwitchView=delegateSwitchView;
        arrayController.delegateNotice=delegateNotice;
        //arrayController.delegateFreConDis=delegateFreConDis;
        [self.retractableControllers addObject:arrayController];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)doCancel {
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *listData =[self.dictionary objectForKey:[self.dictionary.allKeys objectAtIndex:section]];
//    return [listData count];
    GCRetractableSectionController *sectionController = [self.retractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GCRetractableSectionController *sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    
    return [sectionController cellForRow:indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSString *contactId = cell.textTwo.text;
//    [delegate showContact:contactId theName:cell.textOne.text];
//    [delegateMail showContact:contactId theName:cell.textOne.text withButton:buttonId];
//    [delegateContact showContact:contactId theName:cell.textOne.text];
//    [self dismissModalViewControllerAnimated:YES];
    
    
    GCRetractableSectionController *sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row withButtonId:buttonId];
}

@end
