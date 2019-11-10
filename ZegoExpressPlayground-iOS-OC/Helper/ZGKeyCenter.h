//
//  ZGKeyCenter.h
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Sky on 2019/5/10.
//  Copyright © 2019 Zego. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 本示例不提供 ZGKeyCenter.m 需要用户自行实现，提供两个函数，如
 
 // 从即构主页申请
 + (unsigned int)appID {
    return 1234567890;
 }
 
 // 从即构主页申请
 + (NSString *)appSign {
     return @"0123456789abcdefghijklmnopqrstuzwxyz0123456789abcdefghijklmnopqr";
 }
 
 请提前在即构管理控制台获取 AppID 与 AppSign.
*/

NS_ASSUME_NONNULL_BEGIN

@interface ZGKeyCenter : NSObject

+ (unsigned int)appID;
+ (NSString *)appSign;

@end

NS_ASSUME_NONNULL_END
