//
//  ChooseDeviceViewController.h
//  UpdFileTransfer
//
//  Created by rang on 15-3-28.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UdpServerManager.h"
@interface ChooseDeviceViewController : BasicTableViewController{
    NSInteger _selectedIndex;
}
@property (nonatomic,strong) UdpServerManager *serverManger;
@end
