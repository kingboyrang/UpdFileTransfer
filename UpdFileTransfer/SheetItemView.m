//
//  SheetItemView.m
//  UpdFileTransfer
//
//  Created by rang on 15-3-28.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SheetItemView.h"

@implementation SheetItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineWidth(ctx, 0.3);  //线宽
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 0.6);  //颜色
    CGContextBeginPath(ctx);
    
    CGFloat h=50;
    NSInteger total=self.bounds.size.height/h-1;
    
    for (NSInteger i=0; i<total; i++) {
        CGContextMoveToPoint(ctx, 0,(i+1)*h);  //起点坐标
        CGContextAddLineToPoint(ctx, self.bounds.size.width,(i+1)*h);   //终点坐标
    }

    CGContextStrokePath(ctx);
}


- (IBAction)iosClick:(id)sender {
    [self hide:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedIOSItemWithTarget:)]) {
            [self.delegate selectedIOSItemWithTarget:self];
        }
    }];
}

- (IBAction)androidClick:(id)sender {
    [self hide:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedAndroidItemWithTarget:)]) {
            [self.delegate selectedAndroidItemWithTarget:self];
        }
    }];
   
}

- (IBAction)cancelClick:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedCancelItemWithTarget:)]) {
        [self.delegate selectedCancelItemWithTarget:self];
    }
}
- (void)hide:(void(^)())diss{
    CGRect r=self.frame;
    r.origin.y=_bgView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=r;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _bgView.alpha=0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    if (diss) {
                        diss();
                    }
                    [_bgView removeFromSuperview];
                    [self removeFromSuperview];
                }
            }];
        }
    }];
}
- (void)hide{
    [self hide:nil];
}
- (void)show{
    if (!_bgView) {
        _bgView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor=[UIColor grayColor];
    }
    _bgView.alpha=0.5;
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    [window addSubview:_bgView];
    
    CGRect r=self.frame;
    r.origin.x=0;
    r.origin.y=_bgView.frame.size.height;
    self.frame=r;
    [window addSubview:self];
    
    r.origin.y=_bgView.frame.size.height-self.bounds.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame=r;
    }];
}
@end
