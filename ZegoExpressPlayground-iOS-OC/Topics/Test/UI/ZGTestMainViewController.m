//
//  ZGTestMainViewController.m
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Patrick Fu on 2019/10/12.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_Test

#import "ZGTestMainViewController.h"
#import "ZGTestSettingTableViewController.h"
#import "ZGTestTopicManager.h"
#import "ZegoLogView.h"

@interface ZGTestMainViewController () <ZGTestViewDelegate, ZGTestDataSource>


// View
@property (weak, nonatomic) IBOutlet UIView *publishView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UILabel *publishQualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *playQualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *logInfoLabel;

@end

@implementation ZGTestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TestTableVCSegue"]) {
        ZGTestSettingTableViewController *vc = segue.destinationViewController;
        [vc setZGTestViewDelegate:self];
        self.manager = [[ZGTestTopicManager alloc] init];
        [self.manager setZGTestDataSource:self];
        vc.manager = self.manager;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)setupView {
    UIBarButtonItem *logButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self action:@selector(showLogView)];
    self.navigationItem.rightBarButtonItem = logButtonItem;
    
    self.publishQualityLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.publishQualityLabel.textColor = [UIColor whiteColor];
    
    self.playQualityLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.playQualityLabel.textColor = [UIColor whiteColor];
}

- (void)showLogView {
    [ZegoLogView show];
}

- (nonnull UIView *)getPlayView {
    return self.playView;
}

- (nonnull UIView *)getPublishView {
    return self.publishView;
}

#pragma mark - ZGTestDataSource

- (void)onPublisherQualityUpdate:(ZegoPublishStreamQuality *)quality {
    NSString *networkQuality = @"";
    switch (quality.level) {
        case 0:
            networkQuality = @"☀️";
            break;
        case 1:
            networkQuality = @"⛅️";
            break;
        case 2:
            networkQuality = @"☁️";
            break;
        case 3:
            networkQuality = @"🌧";
            break;
        case 4:
            networkQuality = @"❌";
            break;
        default:
            break;
    }
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"FPS: %d fps\n", (int)quality.videoSendFPS];
    [text appendFormat:@"Bitrate: %.2f kb/s \n", quality.videoKBPS];
    [text appendFormat:@"Resolution: %dx%d \n", (int)quality.videoResolution.width, (int)quality.videoResolution.height];
    [text appendFormat:@"HardwareEncode: %@ \n", quality.isHardwareEncode ? @"✅" : @"❎"];
    [text appendFormat:@"NetworkQuality: %@", networkQuality];
    self.publishQualityLabel.text = text;
}

- (void)onPlayerQualityUpdate:(ZegoPlayStreamQuality *)quality {
    NSString *networkQuality = @"";
    switch (quality.level) {
        case 0:
            networkQuality = @"☀️";
            break;
        case 1:
            networkQuality = @"⛅️";
            break;
        case 2:
            networkQuality = @"☁️";
            break;
        case 3:
            networkQuality = @"🌧";
            break;
        case 4:
            networkQuality = @"❌";
            break;
        default:
            break;
    }
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"FPS: %d fps\n", (int)quality.videoRecvFPS];
    [text appendFormat:@"Bitrate: %.2f kb/s \n", quality.videoKBPS];
    [text appendFormat:@"Resolution: %dx%d \n", (int)quality.videoResolution.width, (int)quality.videoResolution.height];
    [text appendFormat:@"HardwareDecode: %@ \n", quality.isHardwareDecode ? @"✅" : @"❎"];
    [text appendFormat:@"NetworkQuality: %@", networkQuality];
    self.playQualityLabel.text = text;
}

- (void)onActionLog:(NSString *)logInfo {
    self.logInfoLabel.text = logInfo;
}

@end

#endif
