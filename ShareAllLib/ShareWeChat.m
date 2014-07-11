//
//  ShareWeChat.m
//  ShareAllLib
//
//  Created by Sun on 14-7-10.
//  Copyright (c) 2014年 Sun. All rights reserved.
//

#import "ShareWeChat.h"

#import "WXApi.h"
#import "WXApiObject.h"

static ShareWeChat *sharedInstance = nil;
@implementation ShareWeChat
@synthesize _delegate;
+ (ShareWeChat *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[ShareWeChat alloc] init];
    }
    return sharedInstance;
}
-(void)initAppKey:(NSString *)key Des:(NSString *)des{
    //微信
     [WXApi registerApp:key withDescription:des];
}

-(id)init{
    self = [super init];
    if(self){

    }
    return self;
}
-(BOOL)ShareImageWithWeChat:(UIImage *)img scene:(WxChanle)scene{
    if (![WXApi isWXAppInstalled]) {

        [self CallErrcode:107];
        return NO;
    }
    WXMediaMessage *msg = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
//
//
//    UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
//    [img drawAtPoint: CGPointMake(0, 0)];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    ext.imageData = UIImageJPEGRepresentation(img, 0);

//    UIGraphicsBeginImageContext(CGSizeMake(img.size.width*0.1, img.size.height*0.1));
//    [img drawAtPoint: CGPointMake(0, 0)];
//    UIImage *thumbimage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    msg.thumbData = UIImageJPEGRepresentation([UIImage imageWithCGImage:[img CGImage] scale:0.1 orientation:img.imageOrientation], 0);
    msg.mediaObject = ext;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = msg;
    if (WXChanleSession == scene) {
        req.scene = 0;
    }else if (WXChanleTimeline){
        req.scene = 1;
    }
    return [WXApi sendReq:req];


}
///**============================================================================================================================
// 微信委托方法
// ==============================================================================================================================
// */
///*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
// *
// * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
// * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
// * @param req 具体请求内容，是自动释放的
// */
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 1000;
        //        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        WXMediaMessage *msg = temp.message;

        //显示微信传过来的内容
//        WXAppExtendObject *obj = msg.mediaObject;
        //
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        //        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
//        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//        NSString *strMsg = @"这是从微信启动的消息";
        [self CallErrcode:90];
    }

}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case 0:
                [self CallErrcode:100];
                break;
            case -1:
                [self CallErrcode:99];
                break;
            case -2:
                [self CallErrcode:98];
                break;
            case -3:
                [self CallErrcode:97];
                break;
            case -4:
                [self CallErrcode:96];
                break;
            case -5:
                [self CallErrcode:95];
                break;
            default:
                [self CallErrcode:99];
                break;
        }

    }
}
-(void)CallErrcode:(int)errcode{
    if (_delegate && [_delegate respondsToSelector:@selector(ShareErrcode:)]) {
        [_delegate performSelector:@selector(ShareErrcode:) withObject:[NSString stringWithFormat:@"%i",errcode]];
    }
}
-(BOOL)handleOpenURL:(NSURL*)url delegate:(id)delegate{
    return [WXApi handleOpenURL:url delegate:delegate];
}
-(NSString *)selectFunction:(NSString*)funstring{
    if ([funstring isEqualToString:@"isWXAppInstalled"]) {
        return [WXApi isWXAppInstalled]?@"YES":@"NO";
    }
    if ([funstring isEqualToString:@"isWXAppSupportApi"]) {
        return [WXApi isWXAppSupportApi]?@"YES":@"NO";
    }
    if ([funstring isEqualToString:@"getWXAppInstallUrl"]) {
        return [WXApi getWXAppInstallUrl];
    }
    if ([funstring isEqualToString:@"getApiVersion"]) {
        return [WXApi getApiVersion];
    }
    if ([funstring isEqualToString:@"openWXApp"]) {
        return [WXApi openWXApp]?@"YES":@"NO";
    }
    return @"NO";
}
@end
