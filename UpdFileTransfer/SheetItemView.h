//
//  SheetItemView.h
//  UpdFileTransfer
//
//  Created by rang on 15-3-28.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SheetItemView;
@protocol SheetItemViewDelegate <NSObject>
- (void)selectedIOSItemWithTarget:(SheetItemView*)sender;
- (void)selectedAndroidItemWithTarget:(SheetItemView*)sender;
- (void)selectedCancelItemWithTarget:(SheetItemView*)sender;
@end

@interface SheetItemView : UIView{
    UIView *_bgView;
}
@property (nonatomic,assign) id<SheetItemViewDelegate> delegate;
- (IBAction)iosClick:(id)sender;
- (IBAction)androidClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

- (void)show;
- (void)hide;
@end


