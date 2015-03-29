//
//  ReceiveViewController.h
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UdpServerManager.h"
@class HTTPServer;
@interface ReceiveViewController : BasicViewController{
    NSTimer *_timer;
    UInt64 currentDataLength;
}
@property (strong, nonatomic) HTTPServer *httpserver;
@property (nonatomic,strong) UdpServerManager *clientManger;
@property (weak, nonatomic) IBOutlet UILabel *lbFileSize;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentFileSize;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UITableView *receiveTable;
@end
