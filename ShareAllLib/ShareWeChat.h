//
//  ShareWeChat.h
//  ShareAllLib
//
//  Created by Sun on 14-7-10.
//  Copyright (c) 2014年 Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "ShareAllLib.h"
typedef NS_ENUM (NSInteger, WxChanle)  {
    WXChanleSession,                   /** 微信渠道    */
    WXChanleTimeline,    /** 微信朋友圈渠道    */
};

@interface ShareWeChat : NSObject <WXApiDelegate>{
    id<ShareAllLibDelegate> _delegate;
}
@property(nonatomic,assign) id<ShareAllLibDelegate> _delegate;
+ (ShareWeChat *)sharedInstance;
-(void)initAppKey:(NSString *)key Des:(NSString *)des;
-(BOOL)ShareImageWithWeChat:(UIImage *)img scene:(WxChanle)scene;
-(BOOL)handleOpenURL:(NSURL*)url delegate:(id)delegate;
-(NSString *)selectFunction:(NSString*)funstring;
@end
