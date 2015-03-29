//
//  SendViewController.m
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SendViewController.h"
#import "SendFileTableViewCell.h"
#import "FileInfoCenter.h"
@interface SendViewController ()
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) AlbumCameraImage *albumCamera;
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.connectionEntity.name;
    self.listData=[[NSMutableArray alloc] init];
    self.albumCamera=[[AlbumCameraImage alloc] init];
    self.albumCamera.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//打开相册
- (IBAction)openAlbumClick:(id)sender {
    [self.albumCamera showAlbumInController:self];
}
//拍照
- (IBAction)openCameraClick:(id)sender {
    [self.albumCamera showCameraInController:self];
}
#pragma mark -table source &delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"sendIdenfier";
    SendFileTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"SendFileTableViewCell" owner:self options:nil];
        if (nibs&&[nibs count]>0) {
            cell=[nibs objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    }
    FileInfoCenter *model=[self.listData objectAtIndex:indexPath.row];
    [cell sendFile:model remoteAdress:[self.connectionEntity GetRemoteAddress]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
#pragma mark -AlbumCameraDelegate Methods
- (void)photoFromAlbumCameraWithImage:(UIImage*)image fromFileName:(NSString *)fileName{
    
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    NSString *str=@"";
    float size=(float)([data length]/1024);
    if (size<1024) {
        str=[NSString stringWithFormat:@"%0.2fB",size];
    }else{
        size=size/1024;
        if (size<1024) {
            str=[NSString stringWithFormat:@"%0.2fKB",size];
        }else{
           size=size/1024;
            if (size<1024) {
                str=[NSString stringWithFormat:@"%0.2fMB",size];
            }else{
               size=size/1024;
               str=[NSString stringWithFormat:@"%0.2fGB",size];
            }
           
        }
    }
    
    FileInfoCenter *info=[[FileInfoCenter alloc] init];
    info.fileName=fileName;
    info.thumbImage=image;
    info.fileSize=str;
    info.sendStauts=FileSending;
    
    [self.listData addObject:info];
    [self.sendFileTable beginUpdates];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.listData count]-1 inSection:0];
    [self.sendFileTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.sendFileTable endUpdates];
}
@end
