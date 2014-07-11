//
//  ShareAllLib.m
//  ShareAllLib
//
//  Created by Sun on 14-7-10.
//  Copyright (c) 2014年 Sun. All rights reserved.
//

#import "ShareAllLib.h"
#import "ShareWeChat.h"
static ShareAllLib *sharedInstance = nil;
@implementation ShareAllLib
+ (ShareAllLib *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[ShareAllLib alloc] init];
    }
    return sharedInstance;
}
-(id)init
{
    self = [super init];
    if(self){
    }
    return self;
}


-(void)setDelegate:(id<ShareAllLibDelegate>)delegate{
    _delegate=delegate;
    //微信
    if ([_delegate respondsToSelector:@selector(getTencent_WX_APPID)]) {
        NSString *wx_appKey = [_delegate performSelector:@selector(getTencent_WX_APPID)];
        ShareWeChat *wechat = [ShareWeChat sharedInstance];
        [wechat initAppKey:wx_appKey Des:@""];
        [wechat set_delegate:_delegate];
    }
}
-(NSString *)ShareList{
    NSString *json = @"[{\"id\": \"0\",\"name\": \"微信消息\",\"available\": true,\"verify\": true},{\"id\": \"1\",\"name\": \"微信朋友圈\",\"available\": true,\"verify\": true},{\"id\": \"2\",\"name\": \"腾讯微博\",\"available\": false,\"verify\": false},{\"id\": \"3\",\"name\": \"新浪微博\",\"available\": false,\"verify\": false}]";
    return json;
}
//授权
-(void)Verify:(int) shareid
{
    if (shareid == 2) {
        NSLog(@"新浪微博  貌似不需要先授权");
    }else if(shareid == 3){
        NSLog(@"腾讯微博  需要先授权再发送");

    }else if(shareid == 0){

    }else if(shareid == 1){

    }
}

-(BOOL)ShareImage:(UIImage *)img chanel:(NSString *)chanel title:(NSString *)title description:(NSString *)description{


   if ([chanel isEqualToString:@"微信朋友圈"] || [chanel isEqualToString:@"1"]) {
       return [[ShareWeChat sharedInstance] ShareImageWithWeChat:img scene:WXChanleTimeline];
   }else if ([chanel isEqualToString:@"微信消息"] || [chanel isEqualToString:@"0"]) {
       return [[ShareWeChat sharedInstance] ShareImageWithWeChat:img scene:WXChanleSession];
   }else{
       if (_delegate && [_delegate respondsToSelector:@selector(ShareErrcode:)]) {
           [_delegate performSelector:@selector(ShareErrcode:) withObject:[NSString stringWithFormat:@"%i",999]];
       }

   }

    return NO;
}

-(BOOL)handleOpenURL:(NSURL*)url delegate:(id)delegate{

    if ([_delegate respondsToSelector:@selector(getTencent_WX_APPID)]) {
        return [[ShareWeChat sharedInstance] handleOpenURL:url delegate:[ShareWeChat sharedInstance]];
    }
    return NO;
}
-(NSString *)selectFunction:(NSString*)funArray{
    NSMutableArray *array=[[NSMutableArray alloc]  init];
    if ([_delegate respondsToSelector:@selector(getTencent_WX_APPID)]) {
        NSArray *arr=[funArray componentsSeparatedByString:@","];
        for (NSString *str in arr) {
            [array addObject:[[ShareWeChat sharedInstance] selectFunction:str]];
        }
    }
    NSString *str=@"";
    for (int i = 0 ; i<[array count]; i++) {
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",[array objectAtIndex:i]]];
        if (i<[array count]-1) {
            str = [str stringByAppendingString:@","];
        }
    }
    [array removeAllObjects];
    [array release];
    array = nil;
    return str;
}
@end
