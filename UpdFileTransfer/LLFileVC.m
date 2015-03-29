//
//  LLFileVC.m
//  DocumentPreview
//
//  Created by aJia on 13/1/24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "LLFileVC.h"
@interface LLFileVC ()

@end

@implementation LLFileVC
@synthesize docInteractionController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithURL:(NSURL *)aURL{
    if (self=[super init]) {
        _isShowing = NO;
        _docURL = [aURL retain];
    }
    return self;
}
-(void)showFile{
    if (_docURL) {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:_docURL];
        self.docInteractionController.delegate = self;
        
        //[self.docInteractionController setName:@"aa"];
        if (![self.docInteractionController presentPreviewAnimated:YES]){
        }
        
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if (!_isShowing) {
        [self showFile];
    }else{
        //[self dismissModalViewControllerAnimated:NO];
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        [self dismissViewControllerAnimated:NO completion:nil];
        }
    
    }
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action{
    BOOL canPerform = NO;
    if (action == @selector(copy:))
        canPerform = YES;
    return canPerform;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller performAction:(SEL)action{
    BOOL handled = NO;
    if (action == @selector(copy:)){
        handled = YES;
    }
    return handled;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    return self.view.frame;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{
    _isShowing = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }else {
        return NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [docInteractionController release];
    [_docURL release];
    
    [super dealloc];
}
@end
