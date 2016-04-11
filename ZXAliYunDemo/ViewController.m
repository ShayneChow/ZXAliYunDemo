//
//  ViewController.m
//  ZXAliYunDemo
//
//  Created by Xiang on 16/4/11.
//  Copyright © 2016年 周想. All rights reserved.
//

#import "ViewController.h"
#import "AuthorizationStatusHelper.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define CropViewWidth self.view.frame.size.width
#define CropViewHeight (CropViewWidth * 2 / 3)
#define CropViewTop (self.view.frame.size.height / 2 - CropViewHeight / 2)


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView.layer.cornerRadius = 5;
    _imageView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadButtonClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"更换店铺形象" message:@"在下面选择您的照片来源" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self actionSheetButtonClicked:0];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self actionSheetButtonClicked:1];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)actionSheetButtonClicked:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.allowsEditing = YES;//设置可编辑
    
    if (buttonIndex == 0) {
        //        拍照
        if (![AuthorizationStatusHelper checkCameraAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        picker.mediaTypes = mediaTypes;
    }else if (buttonIndex == 1){
        //        相册
        if (![AuthorizationStatusHelper checkPhotoLibraryAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        picker.mediaTypes = mediaTypes;
    }
    [self presentViewController:picker animated:YES completion:nil];    // 进入照相界面or照片选择界面
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(){
//        UIImage *editedImage, *originalImage;
//        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        
//        _imageView.image = editedImage;
        
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:originalImage cropFrame:CGRectMake(0, CropViewTop, CropViewWidth, CropViewHeight) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
        
        // 保存原图片到相册中
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
//        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _imageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
