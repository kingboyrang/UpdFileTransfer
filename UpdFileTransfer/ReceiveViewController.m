//
//  ReceiveViewController.m
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "ReceiveViewController.h"
#import "HTTPServer.h"
#import "AYHTTPConnection.h"
#import "UdpConfig.h"
#import "LLFileVC.h"

#define GBUnit 1073741824
#define MBUnit 1048576
#define KBUnit 1024

@interface ReceiveViewController ()
@property (nonatomic,strong) NSMutableArray *listData;
@end

@implementation ReceiveViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //低部
    UIView *footer=[[UIView alloc] init];
    footer.backgroundColor=[UIColor clearColor];
    self.receiveTable.tableFooterView=footer;
    
     self.listData=[[NSMutableArray alloc] init];
    self.clientManger=[[UdpServerManager alloc] init];
    [self.clientManger start];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIpFinished:) name:kNotificationIPReceivedFinishd object:nil];
    
    //httpserver
    currentDataLength = 0;
    [self addObservers];
    
    
    //[self initViews];
    [_progressView setHidden:YES];
    _progressView.progress=0.0;
    _labName.text=@"";
    _lbFileSize.text=@"";
    _lbCurrentFileSize.text=@"";
    
    _httpserver = [[HTTPServer alloc] init];
    [_httpserver setType:@"_http._tcp."];
    [_httpserver setPort:kUDPPORT];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"website"];
    [_httpserver setDocumentRoot:webPath];
    [_httpserver setConnectionClass:[AYHTTPConnection class]];
    //[self startServer];
}
- (void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithStart:) name:UPLOADSTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploading:) name:UPLOADING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithEnd:) name:UPLOADEND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithDisconnect:) name:UPLOADISCONNECTED object:nil];
}
//接收到ip地址
- (void)receiveIpFinished:(NSNotification*)notifice{
    NSString *host=[notifice.userInfo objectForKey:@"host"];
    NSLog(@"host =%@",host);
    
}
- (void)sendUpdData{
    [self.clientManger sendBroadcast];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendUpdData) userInfo:nil repeats:YES];
    [self startServer];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    [self.clientManger close];
    
    //httpserver
    [_httpserver stop];
    currentDataLength = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -table source &delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"sendIdenfier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
         //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    NSDictionary *item=[self.listData objectAtIndex:indexPath.row];
    cell.textLabel.text=[item objectForKey:@"name"];
    cell.detailTextLabel.text=[item objectForKey:@"size"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item=[self.listData objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *uploadFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[item objectForKey:@"name"]];
    LLFileVC *previewController=[[LLFileVC alloc] initWithURL:[NSURL fileURLWithPath:uploadFilePath]];
    [self.navigationController pushViewController:previewController animated:YES];
}

#pragma mark -httpServer
- (void) startServer
{
    NSError *error;
    if ([_httpserver start:&error])
    {
        NSLog(@"Started HTTP Server\nhttp://%@:%hu",[_httpserver hostName], [_httpserver listeningPort]);
        // [_lbHTTPServer setText:[NSString stringWithFormat:@"Started HTTP Server\nhttp://%@:%hu", [_httpserver hostName], [_httpserver listeningPort]]];
    }
    else
        NSLog(@"Error Started HTTP Server:%@", error);
}
#pragma mark -notification
- (void) uploadWithStart:(NSNotification *) notification
{
    UInt64 fileSize = [(NSNumber *)[notification.userInfo objectForKey:@"totalfilesize"] longLongValue];
    __block NSString *showFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (fileSize>GBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%.1fG", (CGFloat)fileSize / (CGFloat)GBUnit];
        if (fileSize>MBUnit && fileSize<=GBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%.1fMB", (CGFloat)fileSize / (CGFloat)MBUnit];
        else if (fileSize>KBUnit && fileSize<=MBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%lliKB", fileSize / KBUnit];
        else if (fileSize<=KBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%lliB", fileSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_labName setText:[notification.userInfo objectForKey:@"filename"]];
            [_lbFileSize setText:showFileSize];
            [_lbCurrentFileSize setText:@"0%"];
            [_progressView setHidden:NO];
        });
    });
    showFileSize = nil;
}

- (void) uploadWithEnd:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *item=[NSDictionary dictionaryWithObjectsAndKeys:_labName.text,@"name",_lbFileSize.text,@"size", nil];
        [self.listData addObject:item];
        [self.receiveTable beginUpdates];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.listData count]-1 inSection:0];
        [self.receiveTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.receiveTable endUpdates];
        
        currentDataLength = 0;
        [_progressView setHidden:YES];
        [_progressView setProgress:0.0];
        [_lbFileSize setText:@""];
        [_lbCurrentFileSize setText:@""];
        [_labName setText:@""];
    });
}

- (void) uploadWithDisconnect:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        [_progressView setHidden:YES];
        [_progressView setProgress:0.0];
        [_lbFileSize setText:@""];
        [_labName setText:@""];
        [_lbCurrentFileSize setText:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Upload data interrupt!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    });
}

- (void) uploading:(NSNotification *)notification
{
    float value = [(NSNumber *)[notification.userInfo objectForKey:@"progressvalue"] floatValue];
    currentDataLength += [(NSNumber *)[notification.userInfo objectForKey:@"cureentvaluelength"] intValue];
    __block NSString *showCurrentFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (currentDataLength>GBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fG", (CGFloat)currentDataLength / (CGFloat)GBUnit];
        if (currentDataLength>MBUnit && currentDataLength<=GBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fMB", (CGFloat)currentDataLength / (CGFloat)MBUnit];
        else if (currentDataLength>KBUnit && currentDataLength<=MBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliKB", currentDataLength / KBUnit];
        else if (currentDataLength<=KBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliB", currentDataLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress += value;
            //[_lbCurrentFileSize setText:showCurrentFileSize];
            [_lbCurrentFileSize setText:[NSString stringWithFormat:@"%d%%",(int)(_progressView.progress*100)]];
        });
    });
    showCurrentFileSize = nil;
}
@end
