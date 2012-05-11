//
//  WizSyncSearch.m
//  Wiz
//
//  Created by 朝 董 on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WizSyncSearch.h"
#import "WizDbManager.h"

@implementation WizSyncSearch
@synthesize keyWord;
@synthesize searchDelegate;
- (void) dealloc
{
    [keyWord release];
    [searchDelegate release];
    [super dealloc];
}
- (void) onDocumentsByKey:(id)retObject
{
    busy = NO;
    NSArray* obj = retObject;
	[[WizDbManager shareDbManager] updateDocuments:obj];
    [self.searchDelegate didSearchSucceed];
}
- (BOOL) start
{
    busy = YES;
    return [self callDocumentsByKey:self.keyWord];
}
- (void) onError:(id)retObject
{
    busy = NO;
    [self.searchDelegate didSearchFild];
    [super onError:retObject];
}
@end