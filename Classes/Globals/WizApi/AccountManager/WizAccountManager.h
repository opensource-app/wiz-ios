//
//  WizAccountManager.h
//  Wiz
//
//  Created by 朝 董 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WizAccount;
@interface WizAccountManager : NSObject
+ (WizAccountManager *) defaultManager;
- (NSArray*) accounts;
- (BOOL) findAccount: (NSString*)userId;
- (NSString*) accountPasswordByUserId:(NSString *)userID;
- (void) setDefalutAccount:(NSString*)accountUserId;
- (BOOL) registerActiveAccount:(NSString*)userId;
- (NSString*) activeAccountUserId;
- (void) addAccount: (NSString*)userId password:(NSString*)password;
- (void) changeAccountPassword: (NSString*)userId password:(NSString*)password;
- (void) logoutAccount;
- (void) removeAccount: (NSString*)userId;
//
@end
