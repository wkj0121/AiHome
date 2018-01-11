//
//  HCWSNetSDK.mm
//  dgcb
//
//  Created by 周子聪 on 2017/12/1.
//  Copyright © 2017年 tbs. All rights reserved.
//

#import "HCWSNetSDK.h"
#import "hcnetsdk.h"
@implementation OC_NET_DVR_DEVICEINFO_V30

@synthesize sSerialNumber;
@synthesize byAlarmInPortNum;
@synthesize byAlarmOutPortNum;
@synthesize byDiskNum;
@synthesize byDVRType;
@synthesize byChanNum;
@synthesize byStartChan;
@synthesize byAudioChanNum;
@synthesize byIPChanNum;
@synthesize byZeroChanNum;
@synthesize byMainProto;
@synthesize bySubProto;
@synthesize bySupport;
@synthesize bySupport1;
@synthesize bySupport2;
@synthesize wDevType;
@synthesize bySupport3;
@synthesize byMultiStreamProto;
@synthesize byStartDChan;
@synthesize byStartDTalkChan;
@synthesize byHighDChanNum;
@synthesize bySupport4;
@synthesize byLanguageType;
@synthesize byVoiceInChanNum;
@synthesize byStartVoiceInChanNo;
@synthesize bySupport5;
@synthesize bySupport6;
@synthesize byMirrorChanNum;
@synthesize wStartMirrorChanNo;
@synthesize bySupport7;
@synthesize byRes2;

- (id)init
{
    return self;
}

@end

@implementation OC_NET_DVR_PREVIEWINFO

@synthesize lChannel;
@synthesize dwStreamType;
@synthesize dwLinkMode;
@synthesize hPlayWnd;
@synthesize bBlocked;
@synthesize bPassbackRecord;
@synthesize byPreviewMode;
@synthesize byStreamID;
@synthesize byProtoType;
@synthesize byRes1;
@synthesize byVideoCodingType;
@synthesize dwDisplayBufNum;
@synthesize byRes;

- (id)init
{
    return self;
}

@end


@implementation HCWSNetSDK
+(void) NET_DVR_Init{
    BOOL bRet = NET_DVR_Init();
    if (!bRet)
    {
        NSLog(@"摄像头初始化失败");
    }
}
+(void) NET_DVR_SetExceptionCallBack{
    NET_DVR_SetExceptionCallBack_V30(0, NULL, g_fExceptionCallBack, NULL);
}
+(int32_t) NET_DVR_Login_V30:(NSString*)sDVRIP wDVRPort:(UInt16)wDVRPort sUserName:(NSString*) sUserName sPassword:(NSString*)sPassword OC_LPNET_DVR_DEVICEINFO_V30:(OC_NET_DVR_DEVICEINFO_V30*)OC_LPNET_DVR_DEVICEINFO_V30
{
    NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
    int iUserID = NET_DVR_Login_V30((char*)[sDVRIP UTF8String],
                                    wDVRPort,
                                    (char*)[sUserName UTF8String],
                                    (char*)[sPassword UTF8String],
                                    &logindeviceInfo);
    
    if(iUserID < 0){
        NSLog(@"摄像头连接失败 errorCode:%d", NET_DVR_GetLastError());
    }else
    {
        OC_LPNET_DVR_DEVICEINFO_V30.byChanNum = logindeviceInfo.byChanNum;
        OC_LPNET_DVR_DEVICEINFO_V30.byStartChan = logindeviceInfo.byStartChan;
        OC_LPNET_DVR_DEVICEINFO_V30.byIPChanNum = logindeviceInfo.byIPChanNum;
        OC_LPNET_DVR_DEVICEINFO_V30.byStartDChan = logindeviceInfo.byStartDChan;
        OC_LPNET_DVR_DEVICEINFO_V30.byHighDChanNum = logindeviceInfo.byHighDChanNum;
    }
    return iUserID;
}


+(BOOL)NET_DVR_Logout:(int)lUserID
{
    return NET_DVR_Logout(lUserID);
}

+(BOOL)NET_DVR_Cleanup{
    return NET_DVR_Cleanup();
}


+(int32_t)NET_DVR_RealPlay_V40:(int)lUserID lpPreviewInfo:(OC_NET_DVR_PREVIEWINFO *)lpPreviewInfo
{
    NET_DVR_PREVIEWINFO struPreviewInfo = {0};
    struPreviewInfo.lChannel = lpPreviewInfo.lChannel;
    struPreviewInfo.dwStreamType = lpPreviewInfo.dwStreamType;
    struPreviewInfo.bBlocked = lpPreviewInfo.bBlocked;
    struPreviewInfo.hPlayWnd = (__bridge void*)lpPreviewInfo.hPlayWnd;
    
    return NET_DVR_RealPlay_V40(lUserID, &struPreviewInfo, NULL, NULL);
}

+(BOOL)NET_DVR_StopRealPlay:(int)lRealHandle
{
    return NET_DVR_StopRealPlay(lRealHandle);
}
void g_fExceptionCallBack(DWORD dwType, LONG lUserID, LONG lHandle, void *pUser)
{
    NSLog(@"%@", [NSString stringWithFormat:@"摄像头网络请求错误(Type[0x%x], UserID[%d], Handle[%d])", dwType, lUserID, lHandle]);
}

+(BOOL)NET_DVR_PTZControl:(int) lRealHandle dwPTZCommand:(UInt16)dwPTZCommand dwStop:(UInt16)dwStop dwSpeed:(UInt16)dwSpeed
{
    return NET_DVR_PTZControlWithSpeed(lRealHandle,dwPTZCommand,dwStop,dwSpeed);
}
@end
