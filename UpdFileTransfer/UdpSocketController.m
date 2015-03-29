//
//  SocketController.m
//  SmartHome
//
//  Created by gbcomApple on 14-6-26.
//  Copyright (c) 2014年 GBCOM. All rights reserved.
//

#import "UdpSocketController.h"

@implementation UdpSocketController{
    
}
@synthesize udpServer;
@synthesize udpClient;
@synthesize delegateArray;
static NSString *groupHost=@"224.1.1.100";
static int PORT=60000;

+(UdpSocketController *)shareInstance{
    static dispatch_once_t once;
    static UdpSocketController *instaceOfSocketConnection;
    dispatch_once(&once, ^ { instaceOfSocketConnection = [[UdpSocketController alloc] init];});
   
    return instaceOfSocketConnection;
}
-(void)changeServerDelegate:(id)calssz{
    [self.udpServer setDelegate:calssz];
}
 /**
 *  启动udp 服务器，监听60000端口
 */
-(void)startUdpServer{
    self.udpServer=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    delegateArray=[NSMutableDictionary new];
    NSError *error = nil;
    if (![self.udpServer bindToPort:PORT error:&error]) {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    // send boardcast
    if(![self.udpServer enableBroadcast:YES error:&error]){
        NSLog(@"Error enableBroadcast (bind): %@", error);
        return ;
    }
    if (![self.udpServer joinMulticastGroup:groupHost error:&error]) {
        NSLog(@"Error enableBroadcast (bind): %@", error);
        return ;
    }
    if (![self.udpServer beginReceiving:&error]) {
        [self.udpServer close];
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
    NSLog(@"udp servers success starting %hu", [udpServer localPort]);
}
-(void)closeUdpServer{
    [self.udpServer close];
}
/**
 *  获取udp客户端实例
 *
 *  @return <#return value description#>
 */
-(GCDAsyncUdpSocket *)getUdpClient:(id) classz{
     NSError *error = nil;
    if(self.udpClient==nil){
         self.udpClient=[[GCDAsyncUdpSocket alloc] initWithDelegate:classz delegateQueue:dispatch_get_main_queue()];
        
        if (![self.udpClient enableBroadcast:YES error:&error]) {
            NSLog(@"Error enableBroadcast (bind): %@", error);
            return nil;
        }
        if (![self.udpClient beginReceiving:&error]) {
            
            NSLog(@"Error starting (recv): %@", error);
            return nil;
        }
    }
     [self.udpClient setDelegate:classz];
    return self.udpClient;
}
/**
 * (1)接收组播消息，并分发到相应的处理类中；
 * (2)接收设备主动上报的mcu报文，如告警上报等，分发到相应的处理类
 *  @param sock          <#sock description#>
 *  @param data          <#data description#>
 *  @param address       <#address description#>
 *  @param filterContext <#filterContext description#>
 */
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSString *host;
    uint16_t port=0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    
    Message *resopnseMsg=[[Message new] parseMsgFromData:data];
    NSInteger responseCode=resopnseMsg.msgContent.msgHeader.messageType;
    if([host isEqualToString:[NetHelper localWiFiIPAddress]]){
        return;
    }else{
        [[delegateArray objectForKey:[[NSNumber alloc ] initWithInteger:responseCode]] udpSocket:sock didReceiveData:data fromAddress:address withFilterContext:filterContext];
    }
}
/**
 *  专用于发送组播
 *
 *  @param classz <#classz description#>
 *  @param data   <#data description#>
 *  @param tag    <#tag description#>
 *
 *  @return <#return value description#>
 */
-(GCDAsyncUdpSocket *)sendGroupMessage:(id) classz data:(NSData *)data Tag:(int)tag {
        NSLog(@" curent group client is :%@---%@----%@",udpServer,groupHost,[[NSNumber alloc] initWithInt:PORT]);
    [self.delegateArray setObject:classz forKey:[[NSNumber alloc] initWithInteger:tag]];
    [self.udpServer sendData:data toHost:groupHost port:PORT withTimeout:5 tag:tag];
    return  self.udpServer;
}
-(GCDAsyncUdpSocket * )sendMessage:(id) classz toHost:(NSString *)host data:(NSData *)data Tag:(int)tag{
    GCDAsyncUdpSocket *temp=[self getUdpClient:classz];
    [temp sendData:data toHost:host port:PORT withTimeout:20 tag:tag];
    NSLog(@"now send the nomarl message to host %@  at port %d",host,PORT);
    return  temp;

}
-(GCDAsyncUdpSocket *)sendMessage:(id) classz data:(NSData *)data toHost:(NSString *)host Port:(int)port Tag:(int)tag{
    GCDAsyncUdpSocket *temp=[self getUdpClient:classz];
     [temp sendData:data toHost:host port:port withTimeout:20 tag:tag];
     return  temp;
}
-(GCDAsyncUdpSocket *)sendMessage:(id) classz data:(NSData *)data toHost:(NSString *)host Port:(int)port Timeout:(int)time Tag:(int)tag{
    GCDAsyncUdpSocket *temp=[self getUdpClient:classz];
     [temp sendData:data toHost:host port:port withTimeout:time tag:tag];
     return  temp;
}
@end
