//
//  CameraShowViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/11.
//  Copyright © 2018年 华通晟云. All rights reserved.
//
#include <stdio.h>
#import "HCWSNetSDK.h"
#import "CameraShowViewController.h"

#pragma mark CameraShowViewController
@interface CameraShowViewController ()
    @property (nonatomic, strong) UIView *realPlayView;
@end

@implementation CameraShowViewController

NSString    *ip         =   @"58.210.203.38";
int         port        =   8000;
NSString    *username  =    @"admin";
NSString    *password  =    @"ht123456";
int         channel    =    1;

OC_NET_DVR_DEVICEINFO_V30 *deviceInfo;
OC_NET_DVR_PREVIEWINFO *previewInfo;
int userID = -1;
int realPlayID = -1;
bool shouldPlay = true;

static CGFloat navBarHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    [self.view addSubview:self.realPlayView];
    // Do any additional setup after loading the view.
    deviceInfo = [[OC_NET_DVR_DEVICEINFO_V30 alloc] init];
    previewInfo = [[OC_NET_DVR_PREVIEWINFO alloc] init];
    [HCWSNetSDK NET_DVR_Init];
    [HCWSNetSDK NET_DVR_SetExceptionCallBack];
    
    userID = [HCWSNetSDK NET_DVR_Login_V30:ip wDVRPort:port sUserName:username sPassword:password OC_LPNET_DVR_DEVICEINFO_V30:deviceInfo];
    [self preview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView *)realPlayView{
    if (!_realPlayView) {
        UIView *realPlayView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + navBarHeight, self.view.frame.size.width, self.view.frame.size.width*0.618)];
        self.realPlayView = realPlayView;
    }
    return _realPlayView;
}

-(void) preview
{
    if(shouldPlay) {
        if(userID == -1) {
            NSLog(@"无法连接摄像头");
        }else{
            if(deviceInfo.byChanNum > 0)
            {
                previewInfo.lChannel = channel;
                previewInfo.dwStreamType = 1;
                previewInfo.bBlocked = 1;
                previewInfo.hPlayWnd = self.realPlayView;
                realPlayID = [HCWSNetSDK NET_DVR_RealPlay_V40:userID lpPreviewInfo:previewInfo];
            }
            else if(deviceInfo.byIPChanNum > 0)
            {
                previewInfo.lChannel = channel;
                previewInfo.dwStreamType = 1;
                previewInfo.bBlocked = 1;
                previewInfo.hPlayWnd = self.realPlayView;
                realPlayID=[HCWSNetSDK NET_DVR_RealPlay_V40:userID lpPreviewInfo: previewInfo];
            }
        }
    }else
    {
        [HCWSNetSDK NET_DVR_StopRealPlay:realPlayID];
    }
    shouldPlay = !shouldPlay;
}

-(void) ptzCtroll
{
    if(realPlayID != -1)
    {
        [HCWSNetSDK NET_DVR_PTZControl:realPlayID dwPTZCommand: 23 dwStop: 0 dwSpeed: 3];
//        [HCWSNetSDK NET_DVR_PTZControl:realPlayID dwPTZCommand: 23 dwStop: 1 dwSpeed: 3];
    }
}

-(void) dealloc{
    [super dealloc];
    [HCWSNetSDK NET_DVR_StopRealPlay:realPlayID];
    [HCWSNetSDK NET_DVR_Logout:userID];
    [HCWSNetSDK NET_DVR_Cleanup];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
