//
//  SearchCustomerViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-10-24.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseContractViewController.h"

@class SearchCustomerViewController;

@protocol SearchCustomerDelegate <NSObject>
- (void)searchCustomerViewController:(SearchCustomerViewController *)controller didSelectContract:(NSString *) contractId withSelectIndex:(int) selectedIndex withCustomerSelectIndex:(int) customerSelectIndex withLabelTitle:(NSString *) title withStartDate:(NSString *) startDate withEndDate:(NSString *) endDate withCustomerId:(NSString *) customerId withCustomerName:(NSString *) customerName;
@end

@interface SearchCustomerViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, ChooseContractDelegate> {
    NSMutableArray *customerList;
    NSMutableArray *nameList;
    int contractSelectedIndex;
    int customerSelectedIndex;
    NSString *contractIdLocal;
    NSString *contractName;
    NSString *startDateLocal;
    NSString *endDateLocal;
    NSString *customerIdLocal;
    NSString *customerNameLocal;
    NSArray *searchResults;
}

@property (nonatomic, retain) id<SearchCustomerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *customerList;
@property (nonatomic, retain) NSMutableArray *nameList;
@property (nonatomic, retain) NSString *contractIdLocal;
@property (nonatomic, retain) NSString *contractName;
@property (nonatomic, retain) NSString *startDateLocal;
@property (nonatomic, retain) NSString *endDateLocal;
@property (nonatomic, retain) NSString *customerIdLocal;
@property (nonatomic, retain) NSString *customerNameLocal;
@property (nonatomic) int contractSelectedIndex;
@property (nonatomic) int customerSelectedIndex;
@property IBOutlet UISearchBar *searchBar;

@end
