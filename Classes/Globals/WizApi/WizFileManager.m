//
//  WizFileManger.m
//  Wiz
//
//  Created by MagicStudio on 12-4-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WizFileManager.h"
#import "WizGlobalData.h"

@implementation WizFileManager
@synthesize accountUserId;

+(NSString*) documentsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	return documentDirectory;
}

-(BOOL) ensurePathExists:(NSString*)path
{
	BOOL b = YES;
    if (![self fileExistsAtPath:path])
	{
		NSError* err = nil;
		b = [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
		if (!b)
		{
			[WizGlobals reportError:err];
		}
	}
	return b;
}
- (BOOL) ensureFileExists:(NSString*)path
{
    if (![self fileExistsAtPath:path]) {
        return [self createFileAtPath:path contents:nil attributes:nil];
    }
    return YES;
}
- (NSString*) accountPath
{
	NSString* documentPath = [WizFileManager documentsPath];
	NSString* subPathName = [NSString stringWithFormat:@"%@/", self.accountUserId]; 
	NSString* path = [documentPath stringByAppendingPathComponent:subPathName];
	[self ensurePathExists:path];
	return path;
}

+ (id) shareManager
{
    return nil;
}

- (NSString*) dbPath
{
    NSString* accountPath = [self accountPath];
	return [accountPath stringByAppendingPathComponent:@"index.db"];
}
- (NSString*) tempDbPath
{
    NSString* accountPath = [self accountPath];
	return [accountPath stringByAppendingPathComponent:@"temp.db"];
}
- (NSString*) objectFilePath:(NSString*)objectGuid
{
	NSString* accountPath = [self accountPath];
	NSString* subName = [NSString stringWithFormat:@"%@", objectGuid];
	NSString* path = [accountPath stringByAppendingPathComponent:subName];
    [self ensurePathExists:path];
	return path;
}
- (NSString*) documentIndexFilesPath:(NSString*)documentGUID
{
    NSString* documentFilePath = [self accountPath];
    NSString* indexFilesPath = [documentFilePath stringByAppendingPathComponent:@"index_files"];
    [self ensurePathExists:indexFilesPath];
    return indexFilesPath;
}
- (NSString*) documentFile:(NSString*)documentGUID fileName:(NSString*)fileName
{
    NSString* path = [self objectFilePath:documentGUID];
	NSString* filename = [path stringByAppendingPathComponent:fileName];
	return filename;
}
- (NSString*) documentIndexFile:(NSString*)documentGUID
{
	return [self documentFile:documentGUID fileName:@"index.html"];
}
- (NSString*) documentMobileFile:(NSString*)documentGuid
{
    return [self documentFile:documentGuid fileName:@"wiz_mobile.html"];
}
- (NSString*) documentAbstractFile:(NSString*)documentGUID
{
    return [self documentFile:documentGUID fileName:@"wiz_abstract.html"];
}
- (NSString*) documentFullFile:(NSString*)documentGUID
{
    return [self documentFile:documentGUID fileName:@"wiz_full.html"];
}
@end