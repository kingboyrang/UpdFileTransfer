//
//  SendViewController.h
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionItem.h"
#import "AlbumCameraImage.h"
@interface SendViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate,AlbumCameraDelegate>
@property (nonatomic,strong) ConnectionItem *connectionEntity;
@property (weak, nonatomic) IBOutlet UITableView *sendFileTable;

- (IBAction)openAlbumClick:(id)sender;
- (IBAction)openCameraClick:(id)sender;

@end
