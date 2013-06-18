//
//  FrequentContactViewController.h
//  HZOAHD
//
//  Created by Li Feng on 13-1-31.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@protocol FrequentContactDelegate <NSObject>
- (void) addFrequentContact:(NSString *) contactId:(NSString *) contactName;
@end

//@protocol FrequentContactDismissViewDelegate <NSObject>
//- (void) dismissViewController;
//@end

@interface FrequentContactViewController : UITableViewController<FrequentContactDelegate>
{

    NSMutableArray *mostList;
    UITableView *tableviewCustom;
    Employee *employee;
    //id<FrequentContactDismissViewDelegate>delegateFreConDis;
    id<FrequentContactDelegate> delegateFrequentContact;
    
    
}
@property (nonatomic, retain) NSMutableArray *mostList;
@property (nonatomic, retain) IBOutlet UITableView *tableviewCustom;
@property (nonatomic, retain) Employee *employee;
//@property (nonatomic, retain) id<FrequentContactDismissViewDelegate>delegateFreConDis;
@property (nonatomic, retain) id<FrequentContactDelegate> delegateFrequentContact;
@end
