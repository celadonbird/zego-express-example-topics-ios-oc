//
//  ZGShareLogViewController.m
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Sky on 2019/4/16.
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZGShareLogViewController.h"
#import <SSZipArchive/SSZipArchive.h>
#import "ZegoHudManager.h"

@interface ZGShareLogViewController () <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation ZGShareLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
        [self zipAndShare];
}

- (void)zipAndShare {
    // 在异步线程压缩文件·
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理各种 path
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *zegologs = [cachesPath stringByAppendingString:@"/ZegoLogs"];
        
        // 日志压缩文件路径
        NSString *dstLogFilePath = [zegologs stringByAppendingPathComponent:@"/zegoavlog.zip"];
        
        // 获取 Library/Caches/ZegoLogs 目录下的所有文件
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *files = [manager subpathsAtPath:zegologs];
        
        NSMutableDictionary *logFiles = [NSMutableDictionary dictionaryWithCapacity:1];
        NSMutableArray<NSString*> *srcLogs = [NSMutableArray arrayWithCapacity:1];
        [files enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * stop) {
            // 取出 ZegoLogs 下的 txt 日志文件
            if ([obj hasSuffix:@".txt"]) {
                NSString *logFileDir = [NSString stringWithFormat:@"%@/%@", zegologs, obj];
                [srcLogs addObject:logFileDir];
                [logFiles setObject:logFileDir forKey:obj];
            }
        }];
        
        // 压缩日志文件为 zip 格式
        BOOL ret = [SSZipArchive createZipFileAtPath:dstLogFilePath withFilesAtPaths:srcLogs];

        NSLog(@"zip ret: %d", ret);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ret) {
                UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:dstLogFilePath]];
                controller.delegate = self;
                self.documentController = controller;
                NSLog(@"self.view.bounds:%@", NSStringFromCGRect(self.view.bounds));
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    CGRect tarRect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10);
                    [controller presentOpenInMenuFromRect:tarRect inView:self.view animated:YES];
                } else {
                    [controller presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
                }
            } else {
                [ZegoHudManager showMessage:@"压缩分享文件失败"];
            }
        });
    });
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
