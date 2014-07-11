//
//  ShareAllLib.h
//  ShareAllLib
//
//  Created by Sun on 14-7-10.
//  Copyright (c) 2014年 Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, Sharechanel)  {

    TencentWeChat                   = 0,    /** 微信渠道    */
    TencentWeChatPengyouquan        = 1,    /** 微信渠道    */
    TencentWeiBo                    = 2,    /** 腾讯微博渠道 */
    SinaWeiBo                       = 3,    /** 新浪微博分享 */
};

enum  ShareErrCode {
    ShareWx_OK                = 100,    /**< 成功    */
    ShareWx_ErrCodeCommon     = 101,   /**< 普通错误类型    */
    ShareWx_CodeUserCancel    = 102,   /**< 用户点击取消并返回    */
    ShareWx_ErrCodeSentFail   = 103,   /**< 发送失败    */
    ShareWx_ErrCodeAuthDeny   = 104,   /**< 授权失败    */
    ShareWx_ErrCodeUnsupport  = 105,   /**< 微信不支持    */
    ShareWx_FromAppStart      = 106,   /**< 从微信启动    */
    ShareWx_Warring           = 107,    /**< 微信没有安装   */
    Share_Warring             = 999,    /**< 渠道不对应   */
};


@protocol ShareAllLibDelegate <NSObject>
@optional
-(NSString*)getTencent_WX_APPID;
-(NSString*)getSina_KAppKey;
-(NSString*)getSina_KRedirectURI;
-(NSString*)getSina_WiressSDKDemoAppKey;
-(NSString*)getSina_WiressSDKDemoAppSecret;
-(NSString*)getSina_REDIRECTURI;
-(void)ShareErrcode:(NSString *)errcode;
@end


@interface ShareAllLib : NSObject{
    id<ShareAllLibDelegate> _delegate;
}
+ (ShareAllLib *)sharedInstance;
-(void)setDelegate:(id<ShareAllLibDelegate>)delegate;
-(NSString *)ShareList;
-(BOOL)ShareImage:(UIImage *)img chanel:(NSString *)chanel title:(NSString *)title description:(NSString *)description;
-(BOOL)handleOpenURL:(NSURL*)url delegate:(id)delegate;
-(NSString *)selectFunction:(NSString*)funArray;
-(NSString *)ShareList;
@end
