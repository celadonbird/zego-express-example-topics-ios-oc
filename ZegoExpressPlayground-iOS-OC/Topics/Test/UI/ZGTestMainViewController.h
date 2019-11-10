//
//  ZGTestMainViewController.h
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Patrick Fu on 2019/10/12.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_Test

#import <UIKit/UIKit.h>
#import "ZGTestTopicManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZGTestMainViewController : UIViewController

@property (nonatomic, strong) ZGTestTopicManager *manager;

@end

NS_ASSUME_NONNULL_END

#endif
