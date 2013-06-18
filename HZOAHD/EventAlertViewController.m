//
//  EventAlertViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "EventAlertViewController.h"

@interface EventAlertViewController ()

@end

@implementation EventAlertViewController
@synthesize delegate;
@synthesize selectedIndex;
@synthesize timerInterval;
@synthesize cellNone;
@synthesize cellFifteen;
@synthesize cellThirty;
@synthesize cellFortyfive;
@synthesize cellOneHour;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)]; 
    if (selectedIndex == 0) {
        cellNone.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 1) {
        cellFifteen.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 2) {
        cellThirty.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 3) {
        cellFortyfive.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 4) {
        cellOneHour.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void) viewWillAppear:(BOOL)animated {

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

- (void)backAction:(id) sender {
    [delegate eventAlertViewController:self didSelectAlert:timerInterval withSelectIndex:selectedIndex withLabelTitle:[self retTextByIndex:selectedIndex]];
}

- (NSString *) retTextByIndex:(int) selectIndex {
    NSString *text = @"无";
    if (selectIndex == 0) {
        text = cellNone.textLabel.text;
    } else if (selectIndex == 1) {
        text = cellFifteen.textLabel.text;
    } else if (selectIndex == 2) {
        text = cellThirty.textLabel.text;
    } else if (selectIndex == 3) {
        text = cellFortyfive.textLabel.text;
    } else if (selectIndex == 4) {
        text = cellOneHour.textLabel.text;
    }
    return text;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    int i = indexPath.row;
    timerInterval = nil;
    if (i == 1) {
        double timer = 15 * 60;
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } else if (i == 2) {
        double timer = 30 * 60; 
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } else if (i == 3) {
        double timer = 45 * 60;
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } else if (i == 4) {
        double timer = 60 * 60;
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } 
}

@end
