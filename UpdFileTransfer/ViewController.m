//
//  ViewController.m
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "ViewController.h"
#import "SheetItemView.h"
#import "SendViewController.h"
#import "ReceiveViewController.h"
#import "ChooseDeviceViewController.h"
#import "UIImage+TPCategory.h"
#import "UIColor+TPCategory.h"
#define ksendBtnTag 100
#define krecevieBtnTag 200
@interface ViewController ()<SheetItemViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:20.0], UITextAttributeFont,
                                                                     nil]];
    
    //self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.sendBtn.layer.cornerRadius=5.0;
    self.sendBtn.layer.masksToBounds=YES;
    [self.sendBtn setBackgroundImage:[UIImage createImageWithColor:UIColorMakeRGB(48, 181, 237)] forState:UIControlStateNormal];
    
    self.receiveBtn.layer.cornerRadius=5.0;
    self.receiveBtn.layer.masksToBounds=YES;
    [self.receiveBtn setBackgroundImage:[UIImage createImageWithColor:UIColorMakeRGB(48, 181, 237)] forState:UIControlStateNormal];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark -SheetItemViewDelegate Methods
- (void)selectedIOSItemWithTarget:(SheetItemView*)sender{
    if (sender.tag==ksendBtnTag) {//ios发文件
        
        
        ChooseDeviceViewController *choose=[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseDeviceVC"];
        choose.title=@"选择接收方";
        [self.navigationController pushViewController:choose animated:YES];
        
        /**
        SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"SendVC"];
        send.title=@"发文件";
        [self.navigationController pushViewController:send animated:YES];
         **/
    }
    if (sender.tag==krecevieBtnTag){//ios收文件
        ReceiveViewController *receive=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveVC"];
        receive.title=@"收文件";
        [self.navigationController pushViewController:receive animated:YES];
    }
}
- (void)selectedAndroidItemWithTarget:(SheetItemView*)sender{
    if (sender.tag==ksendBtnTag) {//android发文件
       
    }
    if (sender.tag==krecevieBtnTag) {//android收文件
        
    }
}
- (void)selectedCancelItemWithTarget:(SheetItemView*)sender{
    [sender hide];
}
#pragma mark - button click
- (IBAction)sendFileClick:(id)sender {
    NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"SheetItemView" owner:self options:nil];
    if (nibs&&[nibs count]>0) {
        SheetItemView *sheet=(SheetItemView*)[nibs objectAtIndex:0];
        sheet.tag=ksendBtnTag;
        sheet.delegate=self;
        [sheet show];
    }
}

- (IBAction)receiveFileClick:(id)sender {
    NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"SheetItemView" owner:self options:nil];
    if (nibs&&[nibs count]>0) {
        SheetItemView *sheet=(SheetItemView*)[nibs objectAtIndex:0];
        sheet.tag=krecevieBtnTag;
        sheet.delegate=self;
        [sheet show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
