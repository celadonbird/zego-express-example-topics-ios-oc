//
//  ZGTestSettingTableViewController.m
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Patrick Fu on 2019/10/24.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_Test

#import "ZGTestSettingTableViewController.h"
#import "ZGAppGlobalConfigManager.h"

NSString* const ZGTestTopicKey_RoomID = @"kRoomID";
NSString* const ZGTestTopicKey_UserID = @"kUserID";
NSString* const ZGTestTopicKey_PublishStreamID = @"kPublishStreamID";
NSString* const ZGTestTopicKey_PlayStreamID = @"kPlayStreamID";
NSString* const ZGTestTopicKey_AudioBitrate = @"kAudioBitrate";
NSString* const ZGTestTopicKey_CaptureVolume = @"kCaptureVolume";
NSString* const ZGTestTopicKey_PlayVolume = @"kPlayVolume";
NSString* const ZGTestTopicKey_BeautifyFeature = @"kBeautifyFeature";

@interface ZGTestSettingTableViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<ZGTestViewDelegate> delegate;

@property (nonatomic, copy) NSArray<NSString *> *latencyModeList;
@property (nonatomic, assign) ZegoLatencyMode selectedLatencyMode;

// Engine
@property (weak, nonatomic) IBOutlet UITextField *appIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *appSignTextField;
@property (weak, nonatomic) IBOutlet UISwitch *testEnvSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scenarioSeg;

@property (weak, nonatomic) IBOutlet UIButton *createEngineButton;
@property (weak, nonatomic) IBOutlet UIButton *destroyEngineButton;
@property (weak, nonatomic) IBOutlet UIButton *getVersionButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadLogButton;
@property (weak, nonatomic) IBOutlet UISwitch *setDebugVerboseSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setDebugVerboseLanguageSeg;
@property (weak, nonatomic) IBOutlet UIButton *setDebugVerboseButton;

// Room
@property (weak, nonatomic) IBOutlet UITextField *roomIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutRoomButton;

// Publish
@property (weak, nonatomic) IBOutlet UITextField *publishStreamIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *startPreviewButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPreviewButton;
@property (weak, nonatomic) IBOutlet UIButton *startPublishButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPublishButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *setPreviewViewModeSeg;
@property (weak, nonatomic) IBOutlet UIButton *updatePreviewViewButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setVideoMirrorModeSeg;
@property (weak, nonatomic) IBOutlet UIButton *setVideoMirrorModeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setCaptureOrientationSeg;
@property (weak, nonatomic) IBOutlet UIButton *setCaptureOrientationButton;
@property (weak, nonatomic) IBOutlet UIPickerView *setLatencyModePicker;
@property (weak, nonatomic) IBOutlet UIButton *setLatencyButton;
@property (weak, nonatomic) IBOutlet UITextField *setAudioBitrateTextField;
@property (weak, nonatomic) IBOutlet UIButton *setAudioBitrateButton;
@property (weak, nonatomic) IBOutlet UISwitch *mutePublishAudioSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mutePublishAudioButton;
@property (weak, nonatomic) IBOutlet UISwitch *mutePublishVideoSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mutePublishVideoButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableHardwareEncoderSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableHardwareEncoderButton;
@property (weak, nonatomic) IBOutlet UITextField *setCaptureVolumeTextField;
@property (weak, nonatomic) IBOutlet UIButton *setCaptureVolumeButton;

// Play
@property (weak, nonatomic) IBOutlet UITextField *playStreamIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *startPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setPlayViewModeSeg;
@property (weak, nonatomic) IBOutlet UIButton *updatePlayViewButton;
@property (weak, nonatomic) IBOutlet UISwitch *mutePlayAudioSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mutePlayAudioButton;
@property (weak, nonatomic) IBOutlet UISwitch *mutePlayVideoSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mutePlayVideoButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableHardwareDecoderSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableHardwareDecoderButton;
@property (weak, nonatomic) IBOutlet UITextField *setPlayVolumeTextField;
@property (weak, nonatomic) IBOutlet UIButton *setPlayVolumeButton;

// Preprocess
@property (weak, nonatomic) IBOutlet UISegmentedControl *setAECModeSeg;
@property (weak, nonatomic) IBOutlet UIButton *setAECModeButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableAECSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableAECButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableAGCSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableAGCButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableANSSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableANSButton;
@property (weak, nonatomic) IBOutlet UITextField *enableBeautifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *enableBeautifyButton;

// Device
@property (weak, nonatomic) IBOutlet UISwitch *enableMicSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableMicButton;
@property (weak, nonatomic) IBOutlet UISwitch *muteAudioOutputSwitch;
@property (weak, nonatomic) IBOutlet UIButton *muteAudioOutputButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableCamSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableCamButton;
@property (weak, nonatomic) IBOutlet UISwitch *useFrontCamSwitch;
@property (weak, nonatomic) IBOutlet UIButton *useFrontCamButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableAudioCaptureDeviceSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enableAudioCaptureDeviceButton;

@end

@implementation ZGTestSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.latencyModeList = @[@"Normal", @"Low", @"Normal2", @"Low2", @"Low3", @"Normal3"];
    self.setLatencyModePicker.delegate = self;
    self.setLatencyModePicker.dataSource = self;
    [self pickerView:self.setLatencyModePicker didSelectRow:0 inComponent:0];
    
    ZGAppGlobalConfig *appConfig = [[ZGAppGlobalConfigManager sharedManager] globalConfig];
    
    self.appIDTextField.text = [NSString stringWithFormat:@"%d", appConfig.appID];
    self.appIDTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.appSignTextField.text = appConfig.appSign;
    
    self.testEnvSwitch.on = appConfig.isTestEnv;
    self.scenarioSeg.selectedSegmentIndex = (int)appConfig.scenario;
    
    self.roomIDTextField.text = [self savedValueForKey:ZGTestTopicKey_RoomID];
    self.userIDTextField.text = [self savedValueForKey:ZGTestTopicKey_UserID];
    
    self.publishStreamIDTextField.text = [self savedValueForKey:ZGTestTopicKey_PublishStreamID];
    self.playStreamIDTextField.text = [self savedValueForKey:ZGTestTopicKey_PlayStreamID];
    
    self.setAudioBitrateTextField.text = [self savedValueForKey:ZGTestTopicKey_AudioBitrate];
    self.setAudioBitrateTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.setCaptureVolumeTextField.text = [self savedValueForKey:ZGTestTopicKey_CaptureVolume];
    self.setCaptureVolumeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.setPlayVolumeTextField.text = [self savedValueForKey:ZGTestTopicKey_PlayVolume];
    self.setPlayVolumeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.enableBeautifyTextField.text = [self savedValueForKey:ZGTestTopicKey_BeautifyFeature];
    self.enableBeautifyTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setZGTestViewDelegate:(id<ZGTestViewDelegate>)delegate {
    self.delegate = delegate;
}

#pragma mark - Action

- (IBAction)createEngineClick:(UIButton *)sender {
    [self.manager createEngineWithAppID:[self.appIDTextField.text intValue] appSign:self.appSignTextField.text isTestEnv:self.testEnvSwitch.on scenario:(ZegoScenario)self.scenarioSeg.selectedSegmentIndex];
}

- (IBAction)destroyEngineClick:(UIButton *)sender {
    [self.manager destroyEngine];
}

- (IBAction)getVersionClick:(UIButton *)sender {
    [self.manager getVersion];
}

- (IBAction)uploadLogClick:(UIButton *)sender {
    [self.manager uploadLog];
}

- (IBAction)setDebugVerboseClick:(UIButton *)sender {
    [self.manager setDebugVerbose:self.setDebugVerboseSwitch.on language:(ZegoLanguage)self.setDebugVerboseLanguageSeg.selectedSegmentIndex];
}

- (IBAction)loginRoomClick:(UIButton *)sender {
    [self.manager loginRoom:self.roomIDTextField.text userID:self.userIDTextField.text];
    [self saveValue:self.roomIDTextField.text forKey:ZGTestTopicKey_RoomID];
    [self saveValue:self.userIDTextField.text forKey:ZGTestTopicKey_UserID];
}

- (IBAction)logoutRoomClick:(UIButton *)sender {
    [self.manager logoutRoom:self.roomIDTextField.text];
}

- (IBAction)startPreviewClick:(UIButton *)sender {
    [self.manager startPreview:[ZegoCanvas canvasWithView:[self.delegate getPublishView] viewMode:(ZegoViewMode)self.setPreviewViewModeSeg.selectedSegmentIndex]];
}

- (IBAction)stopPreviewClick:(UIButton *)sender {
    [self.manager stopPreview];
}

- (IBAction)startPublishClick:(UIButton *)sender {
    [self.manager startPublishing:self.publishStreamIDTextField.text];
    [self saveValue:self.publishStreamIDTextField.text forKey:ZGTestTopicKey_PublishStreamID];
}

- (IBAction)stopPublishClick:(UIButton *)sender {
    [self.manager stopPublishing];
}

- (IBAction)updatePreviewViewClick:(UIButton *)sender {
    [self.manager updatePreviewView:[ZegoCanvas canvasWithView:[self.delegate getPublishView] viewMode:(ZegoViewMode)self.setPreviewViewModeSeg.selectedSegmentIndex]];
}

- (IBAction)setMirrorClick:(UIButton *)sender {
    [self.manager setVideoMirrorMode:(ZegoVideoMirrorMode)self.setVideoMirrorModeSeg.selectedSegmentIndex];
}

- (IBAction)setCapOrientationClick:(UIButton *)sender {
    [self.manager setCaptureOrientation:(UIInterfaceOrientation)self.setCaptureOrientationSeg.selectedSegmentIndex];
}

- (IBAction)setLatencyClick:(UIButton *)sender {
    [self.manager setLatencyMode:self.selectedLatencyMode];
}

- (IBAction)setAudioBitrateClick:(UIButton *)sender {
    [self.manager setAudioBitrate:[self.setAudioBitrateTextField.text intValue]];
    [self saveValue:self.setAudioBitrateTextField.text forKey:ZGTestTopicKey_AudioBitrate];
}

- (IBAction)mutePublishAudioClick:(UIButton *)sender {
    [self.manager mutePublishStreamAudio:self.mutePublishAudioSwitch.on];
}

- (IBAction)mutePublishVideoClick:(UIButton *)sender {
    [self.manager mutePublishStreamVideo:self.mutePublishVideoSwitch.on];
}

- (IBAction)enableHardwareEncoderClick:(UIButton *)sender {
    [self.manager enableHardwareEncoder:self.enableHardwareEncoderSwitch.on];
}

- (IBAction)setCaptureVolumeClick:(UIButton *)sender {
    [self.manager setCaptureVolume:[self.setCaptureVolumeTextField.text intValue]];
    [self saveValue:self.setCaptureVolumeTextField.text forKey:ZGTestTopicKey_CaptureVolume];
}

- (IBAction)startPlayClick:(UIButton *)sender {
    [self.manager startPlayingStream:self.playStreamIDTextField.text canvas:[ZegoCanvas canvasWithView:[self.delegate getPlayView] viewMode:(ZegoViewMode)self.setPlayViewModeSeg.selectedSegmentIndex]];
    [self saveValue:self.playStreamIDTextField.text forKey:ZGTestTopicKey_PlayStreamID];
}

- (IBAction)stopPlayClick:(UIButton *)sender {
    [self.manager stopPlayingStream:self.playStreamIDTextField.text];
}

- (IBAction)updatePlayViewClick:(UIButton *)sender {
    [self.manager updatePlayView:[ZegoCanvas canvasWithView:[self.delegate getPlayView] viewMode:(ZegoViewMode)self.setPlayViewModeSeg.selectedSegmentIndex] ofStream:self.playStreamIDTextField.text];
}

- (IBAction)mutePlayAudioClick:(UIButton *)sender {
    [self.manager mutePlayStreamAudio:self.mutePlayAudioSwitch.on stream:self.playStreamIDTextField.text];
}

- (IBAction)mutePlayVideoClick:(UIButton *)sender {
    [self.manager mutePlayStreamVideo:self.mutePlayVideoSwitch.on stream:self.playStreamIDTextField.text];
}

- (IBAction)enableHardwareDecoderClick:(UIButton *)sender {
    [self.manager enableHarewareDecoder:self.enableHardwareDecoderSwitch.on];
}

- (IBAction)setPlayVolumeClick:(UIButton *)sender {
    [self.manager setPlayVolume:[self.setPlayVolumeTextField.text intValue] stream:self.playStreamIDTextField.text];
    [self saveValue:self.setPlayVolumeTextField.text forKey:ZGTestTopicKey_PlayVolume];
}

- (IBAction)setAECModeClick:(UIButton *)sender {
    [self.manager setAECMode:(ZegoAECMode)self.setAECModeSeg.selectedSegmentIndex];
}

- (IBAction)enableAECClick:(UIButton *)sender {
    [self.manager enableAEC:self.enableAECSwitch.on];
}

- (IBAction)enableAGCClick:(UIButton *)sender {
    [self.manager enableAGC:self.enableAGCSwitch.on];
}

- (IBAction)enableANSClick:(UIButton *)sender {
    [self.manager enableANS:self.enableANSSwitch.on];
}

- (IBAction)enableBeautifyClick:(UIButton *)sender {
    [self.manager enableBeautify:(int)[self.enableBeautifyTextField.text intValue]];
    [self saveValue:self.enableBeautifyTextField.text forKey:ZGTestTopicKey_BeautifyFeature];
}

- (IBAction)enableMicrophoneClick:(UIButton *)sender {
    [self.manager enableMicrophone:self.enableMicSwitch.on];
}

- (IBAction)muteAudioOutoutClick:(UIButton *)sender {
    [self.manager muteAudioOutput:self.muteAudioOutputSwitch.on];
}

- (IBAction)enableCameraClick:(UIButton *)sender {
    [self.manager enableCamera:self.enableCamSwitch.on];
}

- (IBAction)useFrontCameraClick:(UIButton *)sender {
    [self.manager useFrontCamera:self.useFrontCamSwitch.on];
}

- (IBAction)enableAudioCaptureDeviceClick:(UIButton *)sender {
    [self.manager enableAudioCaptureDevice:self.enableAudioCaptureDeviceSwitch.on];
}




#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.latencyModeList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.latencyModeList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.selectedLatencyMode = ZegoLatencyModeNormal;
    } else if (row == 1) {
        self.selectedLatencyMode = ZegoLatencyModeLow;
    } else if (row == 2) {
        self.selectedLatencyMode = ZegoLatencyModeNormal2;
    } else if (row == 3) {
        self.selectedLatencyMode = ZegoLatencyModeLow2;
    } else if (row == 4) {
        self.selectedLatencyMode = ZegoLatencyModeLow3;
    } else {
        self.selectedLatencyMode = ZegoLatencyModeNormal3;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.appIDTextField) {
        [self.appSignTextField becomeFirstResponder];
    } else if (textField == self.roomIDTextField) {
        [self.userIDTextField becomeFirstResponder];
    }
    return YES;
}


@end

#endif
