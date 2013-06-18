//
//  FrequentContactViewController.m
//  HZOAHD
//
//  Created by Li Feng on 13-1-31.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "FrequentContactViewController.h"
#import "ChooseEmployeeViewController.h"
#import "GCRetractableSectionController.h"

@implementation FrequentContactViewController


@synthesize mostList;
@synthesize tableviewCustom;
@synthesize employee;
//@synthesize delegateFreConDis;
@synthesize delegateFrequentContact;


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
    self.title=@"常用联系人";
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAdd target:self action:@selector(addEmployees:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    
    mostList = [Employee getAllMostContact];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)addEmployees:(id)sender
{

    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SwitchViewController *switchViewController = [storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateFrequentContact = self;
    switchViewController.status = 1;
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];

}

- (void) addFrequentContact:(NSString *) contactId:(NSString *) contactName
{
    Employee *emp = [[Employee alloc] init];
    emp._id=contactId;
    emp._name=contactName;
    [Employee insertMostContact:emp];
    mostList = [Employee getAllMostContact];
    [self.tableviewCustom reloadData];
   
}
//- (void) dismissViewController{
//    [self dismissModalViewControllerAnimated:YES];
//}
- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mostList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    employee = [self.mostList objectAtIndex:indexPath.row];
    cell.textOne.text=employee._name;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        Employee *emps=(Employee *)[self.mostList objectAtIndex:indexPath.row];
        [Employee deleteMostContact:emps];
        [self.mostList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}


@end
