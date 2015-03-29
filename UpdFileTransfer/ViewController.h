//
//  ViewController.h
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : BasicViewController

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
- (IBAction)sendFileClick:(id)sender;
- (IBAction)receiveFileClick:(id)sender;

@end

