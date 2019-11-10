//
//  ZGTestTopicManager.m
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Patrick Fu on 2019/10/24.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_Test

#import "ZGTestTopicManager.h"
#import "ZGAppGlobalConfigManager.h"
#import "ZGUserIDHelper.h"

@interface ZGTestTopicManager () <ZegoEventHandler>

@property (nonatomic, strong) ZegoExpressEngine *engine;

@property (nonatomic, weak) id<ZGTestDataSource> dataSource;

@end

@implementation ZGTestTopicManager

- (void)dealloc {
    ZGLogInfo(@" 🏳️ Destroy the ZegoExpressEngine");
    [ZegoExpressEngine destroyEngine];
}

- (void)setZGTestDataSource:(id<ZGTestDataSource>)dataSource {
    self.dataSource = dataSource;
}

- (void)createEngineWithAppID:(unsigned int)appID appSign:(NSString *)appSign isTestEnv:(BOOL)isTestEnv scenario:(ZegoScenario)scenario {
    ZGLogInfo(@" 🚀 Initialize the ZegoExpressEngine");
    [self.dataSource onActionLog:@" 🚀 Initialize the ZegoExpressEngine"];
    self.engine = [ZegoExpressEngine createEngineWithAppID:appID appSign:appSign isTestEnv:isTestEnv scenario:scenario eventHandler:self];
}

- (void)destroyEngine {
    ZGLogInfo(@" 🏳️ Destroy the ZegoExpressEngine");
    [self.dataSource onActionLog:@" 🏳️ Destroy the ZegoExpressEngine"];
    [ZegoExpressEngine destroyEngine];
}

- (NSString *)getVersion {
    NSString *version = [ZegoExpressEngine getVersion];
    ZGLogInfo(@" ℹ️ Engine Version: %@", version);
    [self.dataSource onActionLog:[NSString stringWithFormat:@" ℹ️ Engine Version: %@", version]];
    return version;
}

- (void)uploadLog {
    [self.engine uploadLog];
    ZGLogInfo(@" 📬 Upload Log");
    [self.dataSource onActionLog:@" 📬 Upload Log"];
}

- (void)setDebugVerbose:(BOOL)enable language:(ZegoLanguage)language {
    [self.engine setDebugVerbose:enable language:language];
    ZGLogInfo(@" 📬 set debug verbose:%d, language:%@", enable, language == ZegoLanguageEnglish ? @"English" : @"中文");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 📬 set debug verbose:%d, language:%@", enable, language == ZegoLanguageEnglish ? @"English" : @"中文"]];
}


#pragma mark Room
- (void)loginRoom:(NSString *)roomID userID:(NSString *)userID {
    [self.engine loginRoom:roomID user:[ZegoUser userWithUserID:userID] config:nil];
    ZGLogInfo(@" 🚪 Login room");
    [self.dataSource onActionLog:@" 🚪 Login room"];
}


- (void)logoutRoom:(NSString *)roomID {
    [self.engine logoutRoom:roomID];
    ZGLogInfo(@" 🚪 Exit the room");
    [self.dataSource onActionLog:@" 🚪 Exit the room"];
}


#pragma mark Publish
- (void)updatePreviewView:(ZegoCanvas *)canvas {
    [self.engine updatePreviewView:canvas];
    ZGLogInfo(@" 🔌 Update PreviewView and viewMode");
    [self.dataSource onActionLog:@" 🔌 Update PreviewView and viewMode"];
}


- (void)setVideoMirrorMode:(ZegoVideoMirrorMode)mirrorMode {
    [self.engine setVideoMirrorMode:mirrorMode];
}


- (void)setCaptureOrientation:(UIInterfaceOrientation)orientation {
    [self.engine setCaptureOrientation:orientation];
}


- (void)startPreview:(ZegoCanvas *)canvas {
    [self.engine startPreview:canvas];
    ZGLogInfo(@" 🔌 Start preview");
    [self.dataSource onActionLog:@" 🔌 Start preview"];
}


- (void)stopPreview {
    [self.engine stopPreview];
    ZGLogInfo(@" 🔌 Stop preview");
    [self.dataSource onActionLog:@" 🔌 Stop preview"];
}


- (void)setLatencyMode:(ZegoLatencyMode)latencyMode {
    [self.engine setLatencyMode:latencyMode];
}


- (void)setAudioBitrate:(int)bitrate {
    [self.engine setAudioBitrate:bitrate];
}


- (void)setVideoResolution:(CGSize)resolution fps:(int)fps bitrate:(int)bitrate {
    ZegoVideoConfig *config = [[ZegoVideoConfig alloc] init];
    config.captureResolution = resolution;
    config.encodeResolution = resolution;
    config.fps = fps;
    config.bitrate = bitrate;
    [self.engine setVideoConfig:config];
}


- (void)startPublishing:(NSString *)streamID {
    [self.engine startPublishing:streamID];
    ZGLogInfo(@" 📤 Start publishing stream");
    [self.dataSource onActionLog:@" 📤 Start publishing stream"];
}


- (void)stopPublishing {
    [self.engine stopPublishing];
    ZGLogInfo(@" 📤 Stop publishing stream");
    [self.dataSource onActionLog:@" 📤 Stop publishing stream"];
}


- (void)mutePublishStreamAudio:(BOOL)mute {
    [self.engine mutePublishStreamAudio:mute];
    ZGLogInfo(@" 🙊 Mute publish stream audio: %@", mute ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🙊 Mute publish stream audio: %@", mute ? @"YES" : @"NO"]];
}


- (void)mutePublishStreamVideo:(BOOL)mute {
    [self.engine mutePublishStreamVideo:mute];
    ZGLogInfo(@" 🙈 Mute publish stream video: %@", mute ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🙈 Mute publish stream video: %@", mute ? @"YES" : @"NO"]];
}


- (void)setCaptureVolume:(int)volume {
    [self.engine setCaptureVolume:volume];
    ZGLogInfo(@" ⛏ Set capture volume: %d", volume);
    [self.dataSource onActionLog:[NSString stringWithFormat:@" ⛏ Set capture volume: %d", volume]];
}


- (void)enableHardwareEncoder:(BOOL)enable {
    [self.engine enableHardwareEncoder:enable];
    ZGLogInfo(@" 🔧 Enable hardware encoder: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable hardware encoder: %@", enable ? @"YES" : @"NO"]];
}


#pragma mark Player
- (void)updatePlayView:(ZegoCanvas *)canvas ofStream:(NSString *)streamID {
//    [self.engine updatePlayView];
    ZGLogInfo(@" ⛏ set playView and viewMode");
    [self.dataSource onActionLog:@" ⛏ set playView and viewMode"];
}


- (void)startPlayingStream:(NSString *)streamID canvas:(ZegoCanvas *)canvas {
    [self.engine startPlayingStream:streamID canvas:canvas];
    ZGLogInfo(@" 📥 Start playing stream");
    [self.dataSource onActionLog:@" 📥 Start playing stream"];
}


- (void)stopPlayingStream:(NSString *)streamID {
    [self.engine stopPlayingStream:streamID];
    ZGLogInfo(@" 📥 Stop playing stream");
    [self.dataSource onActionLog:@" 📥 Stop playing stream"];
}


- (void)setPlayVolume:(int)volume stream:(NSString *)streamID {
    [self.engine setPlayVolume:volume stream:streamID];
    ZGLogInfo(@" ⛏ Set play volume: %d", volume);
    [self.dataSource onActionLog:[NSString stringWithFormat:@" ⛏ Set play volume: %d", volume]];
}


- (void)mutePlayStreamAudio:(BOOL)mute stream:(NSString *)streamID {
    ZGLogInfo(@" 🙊 Mute play stream audio: %@", mute ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🙊 Mute play stream audio: %@", mute ? @"YES" : @"NO"]];
}


- (void)mutePlayStreamVideo:(BOOL)mute stream:(NSString *)streamID {
    [self.engine mutePlayStreamVideo:mute stream:streamID];
    ZGLogInfo(@" 🙈 Mute play stream video: %@", mute ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🙈 Mute play stream video: %@", mute ? @"YES" : @"NO"]];
}


- (void)enableHarewareDecoder:(BOOL)enable {
    [self.engine enableHardwareDecoder:enable];
    ZGLogInfo(@" 🔧 Enable hardware decoder: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable hardware decoder: %@", enable ? @"YES" : @"NO"]];
}


#pragma mark PreProcess
- (void)enableAEC:(BOOL)enable {
    [self.engine enableAEC:enable];
    ZGLogInfo(@" 🔧 Enable AEC: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable AEC: %@", enable ? @"YES" : @"NO"]];
}


- (void)setAECMode:(ZegoAECMode)mode {
    [self.engine setAECMode:mode];
    ZGLogInfo(@" ⛏ Set AEC mode: %d", (int)mode);
    [self.dataSource onActionLog:[NSString stringWithFormat:@" ⛏ Set AEC mode: %d", (int)mode]];
}


- (void)enableAGC:(BOOL)enable {
    [self.engine enableAGC:enable];
    ZGLogInfo(@" 🔧 Enable AGC: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable AGC: %@", enable ? @"YES" : @"NO"]];
}


- (void)enableANS:(BOOL)enable {
    [self.engine enableANS:enable];
    ZGLogInfo(@" 🔧 Enable ANS: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable ANS: %@", enable ? @"YES" : @"NO"]];
}


- (void)enableBeautify:(int)feature {
    [self.engine enableBeautify:feature];
    ZGLogInfo(@" ⛏ Enable beautify: %d", (int)feature);
    [self.dataSource onActionLog:[NSString stringWithFormat:@" ⛏ Enable beautify: %d", (int)feature]];
}


#pragma mark Device
- (void)enableMicrophone:(BOOL)enable {
    [self.engine enableMicrophone:enable];
    ZGLogInfo(@" 🔧 Enable microphone: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable microphone: %@", enable ? @"YES" : @"NO"]];
}


- (void)muteAudioOutput:(BOOL)enable {
    [self.engine muteAudioOutput:enable];
    ZGLogInfo(@" 🔧 Mute audio output: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Mute audio output: %@", enable ? @"YES" : @"NO"]];
}


- (void)enableCamera:(BOOL)enable {
    [self.engine enableCamera:enable];
    ZGLogInfo(@" 🔧 Enable camera: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable camera: %@", enable ? @"YES" : @"NO"]];
}


- (void)useFrontCamera:(BOOL)enable {
    [self.engine useFrontCamera:enable];
    ZGLogInfo(@" 🔧 Use front camera: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Use front camera: %@", enable ? @"YES" : @"NO"]];
}


- (void)enableAudioCaptureDevice:(BOOL)enable {
    [self.engine enableAudioCaptureDevice:enable];
    ZGLogInfo(@" 🔧 Enable audio capture device: %@", enable ? @"YES" : @"NO");
    [self.dataSource onActionLog:[NSString stringWithFormat:@" 🔧 Enable audio capture device: %@", enable ? @"YES" : @"NO"]];
}


#pragma mark Callback

- (void)onDebugError:(int)errorCode funcName:(NSString *)funcName info:(NSString *)info {
    ZGLogInfo(@" 🚩 ❓ Debug Error Callback: errorCode: %d, FuncName: %@ Info: %@", errorCode, funcName, info);
}

- (void)onRoomStateUpdate:(ZegoRoomState)state errorCode:(int)errorCode room:(NSString *)roomID {
    ZGLogInfo(@" 🚩 🚪 Room State Update Callback: %lu, errorCode: %d, roomID: %@", (unsigned long)state, (int)errorCode, roomID);
}


- (void)onRoomUserUpdate:(ZegoUpdateType)updateType userList:(NSArray<ZegoUser *> *)userList room:(NSString *)roomID {
    ZGLogInfo(@" 🚩 🕺 Room User Update Callback: %lu, UsersCount: %lu, roomID: %@", (unsigned long)updateType, (unsigned long)userList.count, roomID);
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList room:(NSString *)roomID {
    ZGLogInfo(@" 🚩 🌊 Room Stream Update Callback: %lu, StreamsCount: %lu, roomID: %@", (unsigned long)updateType, (unsigned long)streamList.count, roomID);
}

- (void)onPublisherStateUpdate:(ZegoPublisherState)state errorCode:(int)errorCode stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📤 Publisher State Update Callback: %lu, errorCode: %d, streamID: %@", (unsigned long)state, (int)errorCode, streamID);
}

- (void)onPublisherQualityUpdate:(ZegoPublishStreamQuality *)quality stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📈 Publisher Quality Update Callback: FPS:%f, Bitrate:%f, Width: %f, Height: %f, streamID: %@", quality.videoSendFPS, quality.videoKBPS, quality.videoResolution.width, quality.videoResolution.height, streamID);
    
    if ([self.dataSource respondsToSelector:@selector(onPublisherQualityUpdate:)]) {
        [self.dataSource onPublisherQualityUpdate:quality];
    }
}

- (void)onPublisherRecvFirstFrameEvent:(ZegoPublisherFirstFrameEvent)event {
    ZGLogInfo(@" 🚩 ✨ Publisher Recv First Frame Event Callback: %lu", (unsigned long)event);
}

- (void)onPublisherVideoSizeChanged:(CGSize)size {
    ZGLogInfo(@" 🚩 📐 Publisher Video Size Changed Callback: Width: %f, Height: %f", size.width, size.height);
}

- (void)onPublisherRelayCDNStateUpdate:(NSArray<ZegoStreamRelayCDNInfo *> *)infoList stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📡 Publisher Relay CDN State Update Callback: Relaying CDN Count: %lu, streamID: %@", (unsigned long)infoList.count, streamID);
}

- (void)onPlayerStateUpdate:(ZegoPlayerState)state errorCode:(int)errorCode stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📥 Player State Update Callback: %lu, errorCode: %d, streamID: %@", (unsigned long)state, (int)errorCode, streamID);
}

- (void)onPlayerQualityUpdate:(ZegoPlayStreamQuality *)quality stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📉 Player Quality Update Callback: FPS:%f, Bitrate:%f, Width: %f, Height: %f, streamID: %@", quality.videoRecvFPS, quality.videoKBPS, quality.videoResolution.width, quality.videoResolution.height, streamID);
    
    if ([self.dataSource respondsToSelector:@selector(onPlayerQualityUpdate:)]) {
        [self.dataSource onPlayerQualityUpdate:quality];
    }
}

- (void)onPlayerMediaEvent:(ZegoPlayerMediaEvent)event stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 🎊 Player Media Event Callback: %lu, streamID: %@", (unsigned long)event, streamID);
}

- (void)onPlayerRecvFirstFrameEvent:(ZegoPlayerFirstFrameEvent)event stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 ⚡️ Player Recv First Frame Event Callback: %lu, streamID: %@", (unsigned long)event, streamID);
}

- (void)onPlayerVideoSizeChanged:(CGSize)size stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📏 Player Video Size Changed Callback: Width: %f, Height: %f, streamID: %@", size.width, size.height, streamID);
}

- (void)onDeviceError:(int)errorCode deviceName:(NSString *)deviceName {
    ZGLogInfo(@" 🚩 💻 Device Error Callback: errorCode: %d, DeviceName: %@", errorCode, deviceName);
}

- (void)onRemoteCameraStateUpdate:(ZegoRemoteDeviceState)state stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 📷 Remote Camera State Update Callback: state: %lu, DeviceName: %@", (unsigned long)state, streamID);
}

- (void)onRemoteMicStateUpdate:(ZegoRemoteDeviceState)state stream:(NSString *)streamID {
    ZGLogInfo(@" 🚩 🎙 Remote Mic State Update Callback: state: %lu, DeviceName: %@", (unsigned long)state, streamID);
}


@end

#endif
