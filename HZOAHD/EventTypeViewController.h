//
//  EventTypeViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemConfig.h"

@class EventTypeViewController;

@protocol EventTypeViewDelegate <NSObject>
- (void)eventTypeViewController:(EventTypeViewController *)controller didSelectType:(NSString *) typeId withSelectIndex:(int) selectedIndex withLabelTitle:(NSString *) title withOriginType:(NSString *) OriginEventType;
@end

@interface EventTypeViewController : UITableViewController {
    int selectedIndex;
    NSString *typeId;
    NSString *typeName;
    SystemConfig *didSelectSystemConfig;
    NSMutableArray *values;
    NSString *typeLabelTxt;
    
}

@property (nonatomic, retain) id<EventTypeViewDelegate> delegate;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) NSString *typeName;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) SystemConfig *didSelectSystemConfig;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSString *typeLabelTxt;

@end
