//
//  CaseCameraImage.h
//  ElandSearch
//
//  Created by rang on 13-8-11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlbumCameraDelegate <NSObject>
- (void)photoFromAlbumCameraWithImage:(UIImage*)image fromFileName:(NSString*)fileName;
@end

@interface AlbumCameraImage : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,assign) id<AlbumCameraDelegate> delegate;
-(void)showCameraInController:(UIViewController*)controller;
-(void)showAlbumInController:(UIViewController*)controller;
@end
