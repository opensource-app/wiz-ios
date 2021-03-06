//
//  TreeViewBaseController.h
//  Wiz
//
//  Created by dong yishuiliunian on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationTreeNode;
@class LocationTreeViewCell;

@protocol WizTreeViewBaseMethod <NSObject>

@optional
-(void) setDetail:(LocationTreeViewCell*)cell;
-(void) reloadAllData;
@end

@interface TreeViewBaseController : UITableViewController <WizTreeViewBaseMethod,UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate> {
    NSString* accountUserId;
    NSArray* locations;
    NSMutableArray *displayNodes;
    LocationTreeNode* tree;
    UIImage* expandImage;
    UIImage* closedImage;
    BOOL isWillReloadAllData;
}
@property (assign)  BOOL isWillReloadAllData;
@property (nonatomic, retain) NSString* accountUserId;
@property (nonatomic, retain) NSArray* locations;
@property(nonatomic, retain) NSMutableArray* displayNodes;
@property(nonatomic,retain) LocationTreeNode* tree;
@property(nonatomic,retain) UIImage* expandImage;
@property(nonatomic,retain) UIImage* closedImage;

-(void)onExpand:(LocationTreeNode*)node;
-(void) setNodeRow;

@end