//
//  SelectContactViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-12.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TITokenField.h"

@class SelectContactViewController;

@protocol SelectContactDelegate <NSObject>
- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButtonId:(UIButton *) buttonId;
- (void) deleteContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId;
@end

@protocol SelectContactViewControllerDelegate <NSObject>
- (void)selectContactViewController:(SelectContactViewController *)controller didSelectContact:(int) count withTokens:(NSArray *) tokens withInvations:(NSString *) invations withListContactId:(NSMutableDictionary *) listContactId;
@end

@interface SelectContactViewController : UIViewController <TITokenFieldDelegate, UITextViewDelegate, SelectContactDelegate> {
    TITokenFieldView * tokenFieldView;
    
    CGFloat keyboardHeight;
    NSMutableDictionary *listContactId;
    
    NSArray *tokens;
}

@property (nonatomic, weak) id<SelectContactViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *listContactId;
@property (nonatomic, retain) NSArray *tokens;


@end
