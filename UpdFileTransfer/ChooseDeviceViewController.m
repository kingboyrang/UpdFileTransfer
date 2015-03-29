//
//  ChooseDeviceViewController.m
//  UpdFileTransfer
//
//  Created by rang on 15-3-28.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "ChooseDeviceViewController.h"
#import "ConnectionItem.h"
#import "SendViewController.h"
@interface ChooseDeviceViewController ()
@property (nonatomic,strong)  NSMutableArray *listData;
@end

@implementation ChooseDeviceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedIndex=0;
    //低部
    UIView *footer=[[UIView alloc] init];
    footer.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=footer;
    //完成按钮
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonFinishedClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=rightBtn;
    //初始化
    self.listData=[[NSMutableArray alloc] init];
    self.serverManger=[[UdpServerManager alloc] init];
    [self.serverManger start];
    
    //接收到用户通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIpFinished:) name:kNotificationIPReceivedFinishd object:nil];
}
//跳转到发送页面
- (void)buttonFinishedClick{
    if (_selectedIndex==-1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择发送对象!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"SendVC"];
    send.connectionEntity=[self.listData objectAtIndex:_selectedIndex];
    [self.navigationController pushViewController:send animated:YES];
    
}
//接收到ip地址
- (void)receiveIpFinished:(NSNotification*)notifice{
    ConnectionItem *mod=(ConnectionItem*)[notifice object];
    if (![self isExistsConnection:mod]) {
        [self.listData addObject:mod];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.listData count]-1 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}
- (BOOL)isExistsConnection:(ConnectionItem*)mod{
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"self.host =%@",mod.host];
    NSArray *arr=[self.listData filteredArrayUsingPredicate:pred];
    return arr&&[arr count]>0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.serverManger sendBroadcast];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.serverManger close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.listData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    ConnectionItem *mod=[self.listData objectAtIndex:indexPath.row];
    cell.textLabel.text=mod.name;
    cell.accessoryType=_selectedIndex==indexPath.row?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    cell.textLabel.textColor=cell.accessoryType==UITableViewCellAccessoryNone?[UIColor blackColor]:[UIColor blueColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==_selectedIndex){
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_selectedIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor=[UIColor blueColor];
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor=[UIColor blackColor];
    }
    _selectedIndex=indexPath.row;
}

@end
