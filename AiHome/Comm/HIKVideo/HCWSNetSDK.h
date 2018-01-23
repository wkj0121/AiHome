//
//  HCWSNetSDK.h
//  dgcb
//
//  Created by 周子聪 on 2017/12/1.
//  Copyright © 2017年 tbs. All rights reserved.
//

#ifndef HCWSNetSDK_h
#define HCWSNetSDK_h
#import <Foundation/Foundation.h>


@interface OC_NET_DVR_DEVICEINFO_V30 : NSObject{
    NSString *sSerialNumber;
    Byte byAlarmInPortNum;
    Byte byAlarmOutPortNum;
    Byte byDiskNum;
    Byte byDVRType;
    Byte byChanNum;
    Byte byStartChan;
    Byte byAudioChanNum;
    Byte byIPChanNum;
    Byte byZeroChanNum;
    Byte byMainProto;
    Byte bySubProto;
    Byte bySupport;
    Byte bySupport1;
    Byte bySupport2;
    int16_t wDevType;
    Byte bySupport3;
    Byte byMultiStreamProto;
    Byte byStartDChan;
    Byte byStartDTalkChan;
    Byte byHighDChanNum;
    Byte bySupport4;
    Byte byLanguageType;
    Byte byVoiceInChanNum;
    Byte byStartVoiceInChanNo;
    Byte bySupport5;
    Byte bySupport6;
    Byte byMirrorChanNum;
    int16_t wStartMirrorChanNo;
    Byte bySupport7;
    Byte byRes2;
}

@property (nonatomic, retain) NSString *sSerialNumber;
@property Byte byAlarmInPortNum;
@property Byte byAlarmOutPortNum;
@property Byte byDiskNum;
@property Byte byDVRType;
@property Byte byChanNum;
@property Byte byStartChan;
@property Byte byAudioChanNum;
@property Byte byIPChanNum;
@property Byte byZeroChanNum;
@property Byte byMainProto;
@property Byte bySubProto;
@property Byte bySupport;
@property Byte bySupport1;
@property Byte bySupport2;
@property int16_t wDevType;
@property Byte bySupport3;
@property Byte byMultiStreamProto;
@property Byte byStartDChan;
@property Byte byStartDTalkChan;
@property Byte byHighDChanNum;
@property Byte bySupport4;
@property Byte byLanguageType;
@property Byte byVoiceInChanNum;
@property Byte byStartVoiceInChanNo;
@property Byte bySupport5;
@property Byte bySupport6;
@property Byte byMirrorChanNum;
@property int16_t wStartMirrorChanNo;
@property Byte bySupport7;
@property Byte byRes2;
@end

@interface OC_NET_DVR_PREVIEWINFO : NSObject{
    int32_t lChannel;
    int32_t dwStreamType;
    int32_t dwLinkMode;
    id  hPlayWnd;
    int32_t bBlocked;
    int32_t bPassbackRecord;
    Byte byPreviewMode;
    NSString *byStreamID;
    Byte byProtoType;
    Byte byRes1;
    Byte byVideoCodingType;
    int32_t dwDisplayBufNum;
    NSString *byRes;
}

@property int32_t lChannel;
@property int32_t dwStreamType;
@property int32_t dwLinkMode;
@property id hPlayWnd;
@property int32_t bBlocked;
@property int32_t bPassbackRecord;
@property Byte byPreviewMode;
@property (nonatomic, retain) NSString *byStreamID;
@property Byte byProtoType;
@property Byte byRes1;
@property Byte byVideoCodingType;
@property int32_t dwDisplayBufNum;
@property (nonatomic, retain) NSString *byRes;
@end

@interface HCWSNetSDK : NSObject
+(void)NET_DVR_Init;
+(void)NET_DVR_SetExceptionCallBack;
+(int32_t) NET_DVR_Login_V30:(NSString*) sDVRIP wDVRPort:(UInt16)wDVRPort sUserName:(NSString*) sUserName sPassword:(NSString*)sPassword OC_LPNET_DVR_DEVICEINFO_V30:(OC_NET_DVR_DEVICEINFO_V30*)OC_LPNET_DVR_DEVICEINFO_V30;
+(BOOL)NET_DVR_Logout:(int)lUserID;
+(BOOL)NET_DVR_Cleanup;
+(int32_t)NET_DVR_RealPlay_V40:(int)lUserID lpPreviewInfo:(OC_NET_DVR_PREVIEWINFO *)lpPreviewInfo;
+(BOOL)NET_DVR_StopRealPlay:(int)lRealHandle;

//PTZ Control
+(BOOL)NET_DVR_PTZControl:(int) lRealHandle dwPTZCommand:(UInt16)dwPTZCommand dwStop:(UInt16)dwStop dwSpeed:(UInt16)dwSpeed;
//+(BOOL)NET_DVR_GetDVRWorkState_V30:(int) lUserID  lpWorkState:(LPNET_DVR_WORKSTATE_V30*)lpWorkState;

@end

#endif 
