//
//  UINavigationBar+CustomNavigatorBar.h
//  Bullet
//
//  Created by aJia on 12/11/13.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (TPCategory)
-(UIImage*)barBackground;
-(void)setBackgroundImage:(UIImage*)image;
-(void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
@end
