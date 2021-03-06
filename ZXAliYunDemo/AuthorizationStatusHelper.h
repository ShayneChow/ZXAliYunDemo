//
//  AuthorizationStatusHelper.h
//  HuanMoney
//
//  Created by Xiang on 16/3/30.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationStatusHelper : NSObject

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

@end
