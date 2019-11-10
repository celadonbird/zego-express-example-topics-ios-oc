//
//  ZGTestTopicManager.h
//  ZegoExpressPlayground-iOS-OC
//
//  Created by Patrick Fu on 2019/10/24.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_Test

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ZegoExpressEngine/ZegoExpressEngine.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZGTestDataSource <NSObject>

@required

- (void)onPublisherQualityUpdate:(ZegoPublishStreamQuality *)quality;

- (void)onPlayerQualityUpdate:(ZegoPlayStreamQuality *)quality;

- (void)onActionLog:(NSString *)logInfo;

@end


@interface ZGTestTopicManager : NSObject

- (void)setZGTestDataSource:(id<ZGTestDataSource>)dataSource;

#pragma mark - Engine
- (void)createEngineWithAppID:(unsigned int)appID appSign:(NSString *)appSign isTestEnv:(BOOL)isTestEnv scenario:(ZegoScenario)scenario;

- (void)destroyEngine;

- (NSString *)getVersion;

- (void)uploadLog;

- (void)setDebugVerbose:(BOOL)enable language:(ZegoLanguage)language;

#pragma mark - Room
- (void)loginRoom:(NSString *)roomID userID:(NSString *)userID;


- (void)logoutRoom:(NSString *)roomID;


#pragma mark - Publish
- (void)updatePreviewView:(ZegoCanvas *)canvas;


- (void)setVideoMirrorMode:(ZegoVideoMirrorMode)mirrorMode;


- (void)setCaptureOrientation:(UIInterfaceOrientation)orientation;


- (void)startPreview:(ZegoCanvas *)canvas;


- (void)stopPreview;


- (void)setLatencyMode:(ZegoLatencyMode)latencyMode;


- (void)setAudioBitrate:(int)bitrate;


- (void)setVideoResolution:(CGSize)resolution fps:(int)fps bitrate:(int)bitrate;


- (void)startPublishing:(NSString *)streamID;


- (void)stopPublishing;


- (void)mutePublishStreamAudio:(BOOL)mute;


- (void)mutePublishStreamVideo:(BOOL)mute;


- (void)setCaptureVolume:(int)volume;


- (void)enableHardwareEncoder:(BOOL)enable;


#pragma mark - Player
- (void)updatePlayView:(ZegoCanvas *)canvas ofStream:(NSString *)streamID;


- (void)startPlayingStream:(NSString *)streamID canvas:(ZegoCanvas *)canvas;


- (void)stopPlayingStream:(NSString *)streamID;


- (void)setPlayVolume:(int)volume stream:(NSString *)streamID;


- (void)mutePlayStreamAudio:(BOOL)mute stream:(NSString *)streamID;


- (void)mutePlayStreamVideo:(BOOL)mute stream:(NSString *)streamID;


- (void)enableHarewareDecoder:(BOOL)enable;


#pragma mark - PreProcess
- (void)enableAEC:(BOOL)enable;


- (void)setAECMode:(ZegoAECMode)mode;


- (void)enableAGC:(BOOL)enable;


- (void)enableANS:(BOOL)enable;


- (void)enableBeautify:(int)feature;


#pragma mark - Device
- (void)enableMicrophone:(BOOL)enable;


- (void)muteAudioOutput:(BOOL)enable;


- (void)enableCamera:(BOOL)enable;


- (void)useFrontCamera:(BOOL)enable;


- (void)enableAudioCaptureDevice:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END

#endif
