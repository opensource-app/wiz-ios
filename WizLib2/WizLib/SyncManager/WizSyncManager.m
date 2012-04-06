//
//  WizSyncManager.m
//  WizLib
//
//  Created by 朝 董 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WizSyncManager.h"
#import "WizApi.h"
#import "WizGetLogKeys.h"
#import "WizSyncBase.h"
#import "WizDownloadObject.h"

#define TypeOfObjectGUID    @"TypeOfObjectGUID"
#define TypeOfObjectType    @"TypeOfObjectType"
@interface WizSyncManager()
{
    NSMutableArray* uploadQueue;
    NSMutableArray* downlooadQueue;
    NSMutableArray* errorQueue;
    NSMutableDictionary* commonParams;
    WizGetLogKeys* logApi;
    WizDownloadObject* downloader;
}
@property (atomic, retain) WizDownloadObject* downloader;
- (void) downloadNext;
- (void) startDonwloader;

@end
@implementation WizSyncManager
static WizSyncManager* shareManager = nil;

+ (id) shareManager
{
    @synchronized(shareManager)
    {
        if (shareManager == nil) {
            shareManager = [[super allocWithZone:NULL] init];
        }
        return shareManager;
    }
}
+ (id) allocWithZone:(NSZone *)zone
{
    return [[self shareManager] retain];
}
- (id) retain
{
    return self;
}
- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}
- (id) copyWithZone:(NSZone*)zone
{
    return self;
}
- (id) autorelease
{
    return self;
}
- (oneway void) release
{
    return;
}
- (NSString*) kbGuid
{
    return [commonParams objectForKey:TypeOfCommonParamKbGUID];
}
- (NSString*) token
{
    return [commonParams objectForKey:TypeOfCommonParamToken];
}
- (NSURL*) apiUrl
{
    return [commonParams objectForKey:TypeOfCommonParamApiUrl];
}
- (void) restartSync
{
    NSLog(@"when solve error count is %d",[errorQueue count]);
    for (WizApi* each in errorQueue) {
        if ([each isKindOfClass:[WizSyncBase class]]) {
            [each startSync];
        }
        else if ([each isKindOfClass:[WizDownloadObject class]])
        {
            [self startDonwloader];
        }
        [errorQueue removeObject:each];
    }
}
- (void) addErrorApiToQueque:(WizApi*)api
{
    NSInteger index = [errorQueue indexOfObject:api];
    if (index != NSNotFound) {
        return;
    }
    [errorQueue addObject:api];
    NSLog(@"error count is %d",[errorQueue count]);
}
- (void) didRefreshLogInfo:(NSNotification*)nc
{
    [WizNotificationCenter removeObserverForReshreshToken:self];
    NSDictionary* keys = [WizNotificationCenter getRefrshLogKeys:nc];
    NSString* token = [keys valueForKey:TypeOfCommonParamToken];
    [commonParams setObject:token forKey:TypeOfCommonParamToken];
    NSURL* urlAPI = [[NSURL alloc] initWithString:[keys valueForKey:TypeOfCommonParamApiUrl]];
    [commonParams setObject:urlAPI forKey:TypeOfCommonParamApiUrl];
    [urlAPI release];
    NSString* kbGuid = [keys valueForKey:TypeOfCommonParamKbGUID];
    [commonParams setObject:kbGuid forKey:TypeOfCommonParamKbGUID];
    [self restartSync];
}
- (void) refreshLogInfo
{
    [commonParams setObject:@"" forKey:TypeOfCommonParamToken];
    [commonParams setObject:@"" forKey:TypeOfCommonParamKbGUID];
    [commonParams setObject:@"" forKey:TypeOfCommonParamApiUrl];
    [WizNotificationCenter addObserverForRefreshToken:self selector:@selector(didRefreshLogInfo:)];
    [logApi getLoginKeys];
}

- (void) willSolveTokenUnactive:(NSNotification*)nc
{
    WizApi* errorApi = [WizNotificationCenter getErrorWizApiFromNc:nc];
    [self addErrorApiToQueque:errorApi];
    [self refreshLogInfo];
}
- (BOOL) startSyncAccountInfo
{
    WizSyncBase* sync = [[WizSyncBase alloc] init];
    return [sync startSync];
}
//
- (void) willSolveWithServerError:(NSNotification*)nc
{
    WizApi* api = [WizNotificationCenter getErrorWizApiFromNc:nc];
    [self addErrorApiToQueque:api];
    [self restartSync];
    
}
//download
- (void) downloadNext
{
    if ([downlooadQueue count] >0) {
        [downlooadQueue removeObjectAtIndex:0];
        [self startDonwloader];
    }
}
- (void) startDonwloader
{
    if (self.downloader.busy) {
        return;
    }
    if ([downlooadQueue count] == 0) {
        return;
    }
    NSDictionary* dic = [downlooadQueue objectAtIndex:0];
    NSString* guid = [dic valueForKey:TypeOfObjectGUID];
    NSString* type = [dic valueForKey:TypeOfObjectType];
    if ([type isEqualToString:WizDocumentKeyString]) {
        [self.downloader downloadDocument:guid];
    }
    else if ([type isEqualToString:WizAttachmentKeyString])
    {
        [self.downloader downloadAttachment:guid];
    }
}
- (void) downloadDocument:(NSString*)guid
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:guid,TypeOfObjectGUID,WizDocumentKeyString,TypeOfObjectType,nil];
    [downlooadQueue addObject:dic];
    [self startDonwloader];
}
- (void) downloadAttachment:(NSString*)guid
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:guid,TypeOfObjectGUID,WizAttachmentKeyString,TypeOfObjectType,nil];
    [downlooadQueue addObject:dic];
    [self startDonwloader];
}
- (id) init
{
    self = [super init];
    if (self) {
        uploadQueue = [[NSMutableArray alloc] init];
        downlooadQueue = [[NSMutableArray alloc] init];
        errorQueue = [[NSMutableArray alloc] init];
        commonParams = [NSMutableDictionary dictionaryWithCapacity:3];
        [commonParams setObject:@"" forKey:TypeOfCommonParamToken];
        [commonParams setObject:@"" forKey:TypeOfCommonParamKbGUID];
        [commonParams setObject:@"" forKey:TypeOfCommonParamApiUrl];
        logApi = [[WizGetLogKeys alloc] init];
        [WizNotificationCenter addObserverForTokenUnactive:self selector:@selector(willSolveTokenUnactive:)];
        [commonParams retain];
        WizDownloadObject* a = [[WizDownloadObject alloc] init];
        self.downloader = a;
        [WizNotificationCenter addObserverForDownloadDone:self selector:@selector(downloadNext)];
        [a release];
        //
        [WizNotificationCenter addObserverForServerError:self selector:@selector(willSolveWithServerError:)];
    }
    return self;
}
@end