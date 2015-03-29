//
//  SendFileTableViewCell.m
//  UpdFileTransfer
//
//  Created by rang on 15-3-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SendFileTableViewCell.h"
#import "ASIFormDataRequest.h"
@interface SendFileTableViewCell ()
@property (nonatomic,strong) FileInfoCenter *entity;
@end

@implementation SendFileTableViewCell
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_progresView removeObserver:self forKeyPath:@"progress"];
}
- (void)awakeFromNib
{
    // 发送状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFileChange:) name:kNotificationFileSendStatuChanged object:nil];
    //监听进度条的值是否发生改变
    [_progresView addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"progress"]) {
        self.labProgress.textColor=[UIColor blueColor];
        float fare=[[change objectForKey:@"progress"] floatValue];
        self.labProgress.text=[NSString stringWithFormat:@"%d%%",(int)(fare*100)];
    }
}
//文件发送状态发生改变
- (void)sendFileChange:(NSNotification*)notifice{
    FileInfoCenter *mod=[notifice object];
    if (mod==self.entity) {
        //状态改变处理
        if (mod.sendStauts==FileSendSuccess) {
            self.progresView.hidden=YES;
            self.labProgress.text=@"已发送";
            self.labProgress.textColor=[UIColor grayColor];
        }else if (mod.sendStauts==FileSendFailed){
            self.progresView.hidden=YES;
            self.labProgress.text=@"发送失败";
            self.labProgress.textColor=[UIColor redColor];
        }else if (mod.sendStauts==FileSendPause){
            self.progresView.hidden=NO;
            self.labProgress.text=@"已暂停";
            self.labProgress.textColor=[UIColor blueColor];
        }else{
            self.progresView.hidden=NO;
            self.labProgress.textColor=[UIColor blueColor];
        }
    }
}
- (void)sendFile:(FileInfoCenter*)info remoteAdress:(NSString*)urlAddress{
    self.entity=info;
    self.labFileName.text=info.fileName;
    self.labFileSize.text=info.fileSize;
    self.thumbnailImageView.image=info.thumbImage;
    if (info.sendStauts==FileSendSuccess) {
        self.progresView.hidden=YES;
        self.labProgress.text=@"已发送";
        self.labProgress.textColor=[UIColor grayColor];
    }else if(info.sendStauts==FileSendFailed){
        self.progresView.hidden=YES;
        self.labProgress.text=@"发送失败";
        self.labProgress.textColor=[UIColor redColor];
       
    }else if (info.sendStauts==FileSendPause){
        self.labProgress.text=@"已暂停";
        self.labProgress.textColor=[UIColor blueColor];
    }else{
        self.progresView.progress=0.0;
        self.progresView.hidden=NO;
        self.labProgress.text=@"0%";
        self.labProgress.textColor=[UIColor blueColor];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlAddress]];
        
        [request addData:UIImagePNGRepresentation(info.thumbImage) withFileName:info.fileName andContentType:@"image/png" forKey:@"uploadnewfile"];
        [request setTimeOutSeconds:60.0];//表示30秒请求超时
        [request setRequestMethod:@"POST"];
        [request setShowAccurateProgress:YES];
        [request setUploadProgressDelegate:self.progresView];
        __block ASIFormDataRequest *manager=request;
        [request setCompletionBlock:^{
            if (manager.responseStatusCode==200) {
                self.entity.sendStauts=FileSendSuccess;
            }else{
                self.entity.sendStauts=FileSendFailed;
            }
        }];
        [request setFailedBlock:^{
            self.entity.sendStauts=FileSendFailed;
        }];
        [request startAsynchronous];
    }
}
@end
