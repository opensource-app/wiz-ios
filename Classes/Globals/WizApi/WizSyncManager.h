//
//  WizSyncManager.h
//  Wiz
//
//  Created by 朝 董 on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WizSyncDescriptionDelegate <NSObject>

- (void) didChangedSyncDescription:(NSString*)description;

@end

@interface WizSyncManager : NSObject
{
    NSString* accountUserId;
    NSString* accountPassword;
    NSString* syncDescription;
        id <WizSyncDescriptionDelegate> displayDelegate;
}
@property (nonatomic, retain) id<WizSyncDescriptionDelegate> displayDelegate;
@property (retain) NSString* syncDescription;
@property (nonatomic, retain) NSString* accountUserId;
@property (nonatomic, retain) NSString* accountPassword;
//upload
- (BOOL) isUploadingDocument:(NSString*)documentGUID;
- (BOOL) isUploadingAttachment:(NSString*)attachmentGUID;
- (BOOL) uploadDocument:(NSString*)documentGUID;
- (BOOL) uploadAttachment:(NSString*)attachmentGUID;
//download
- (BOOL) isDownloadingDocument:(NSString*)documentGUID;
- (BOOL) isDownloadingAttachment:(NSString*)attachmentGUID;
- (void) downloadAttachment:(NSString*)attachmentGUID;
- (void) downloadDocument:(NSString*)documentGUID;
//
- (BOOL) startSyncInfo;
//
- (void) resignActive;
+ (id) shareManager;
@end
