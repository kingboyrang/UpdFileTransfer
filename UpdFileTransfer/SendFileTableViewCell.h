//
//  SendFileTableViewCell.h
//  UpdFileTransfer
//
//  Created by rang on 15-3-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileInfoCenter.h"
@interface SendFileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labProgress;
@property (weak, nonatomic) IBOutlet UILabel *labFileSize;
@property (weak, nonatomic) IBOutlet UILabel *labFileName;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progresView;
- (void)sendFile:(FileInfoCenter*)info remoteAdress:(NSString*)urlAddress;
@end
