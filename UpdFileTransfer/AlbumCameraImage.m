//
//  CaseCameraImage.m
//  ElandSearch
//
//  Created by rang on 13-8-11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AlbumCameraImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+TPCategory.h"
@implementation AlbumCameraImage
-(void)showCameraInController:(UIViewController*)controller{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    //picker.allowsEditing=YES;//是否允許編輯
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        //[picker release];
        return;
    }
    [controller presentViewController:picker animated:YES completion:nil];
    //[picker release];
}
-(void)showAlbumInController:(UIViewController*)controller{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    //picker.allowsEditing=YES;//是否允許編輯
   //相簿
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [controller presentViewController:picker animated:YES completion:^{}];
    //[picker release];
}
#pragma mark -
#pragma mark UIImagePickerController  Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block NSString *fileName=[NSString stringWithFormat:@"%@.png",[NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMddHHmmss"]];
    if(picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary){//相册
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            if ([representation filename]&&[[representation filename] length]>0) {
                fileName= [representation filename];
            }
            UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:fromFileName:)]) {
                [self.delegate photoFromAlbumCameraWithImage:image fromFileName:fileName];
            }
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:^(NSError *error) {
                          UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
                          if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:fromFileName:)]) {
                              [self.delegate photoFromAlbumCameraWithImage:image fromFileName:fileName];
                          }
                      }];
    
    }else{//拍照
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:fromFileName:)]) {
            [self.delegate photoFromAlbumCameraWithImage:image fromFileName:fileName];
        }
    }
   
	
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
