//
//  BasicTableViewController.m
//  UpdFileTransfer
//
//  Created by rang on 15-3-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "BasicTableViewController.h"

@interface BasicTableViewController ()

@end

@implementation BasicTableViewController

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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    if ([self.navigationController.viewControllers count]>1) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, 50, 30);
        [btn setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem=backBtn;
    }
    
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
