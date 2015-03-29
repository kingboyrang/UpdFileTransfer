//
//  SocketController.h
//  SmartHome
//
//  Created by gbcomApple on 14-6-26.
//  Copyright (c) 2014年 GBCOM. All rights reserved.
//
#import <Foundation/Foundation.h>
 #import "GCDAsyncUdpSocket.h"
#import "Message.h"
#import "MessageCode.h"

@interface UdpSocketController : NSObject<GCDAsyncUdpSocketDelegate>
@property(nonatomic,strong)GCDAsyncUdpSocket *udpServer;
@property(nonatomic,strong)GCDAsyncUdpSocket *udpClient;
@property(nonatomic,strong)NSMutableDictionary *delegateArray;
-(void)changeServerDelegate:(id)calssz;
-(GCDAsyncUdpSocket * )sendGroupMessage:(id) classz data:(NSData *)data Tag:(int)tag;
+(UdpSocketController *) shareInstance;
-(void)startUdpServer;
-(void)closeUdpServer;
-(GCDAsyncUdpSocket * )sendMessage:(id) classz toHost:(NSString *)host data:(NSData *)data Tag:(int)tag;
-(GCDAsyncUdpSocket * )sendMessage:(id) classz data:(NSData *)data toHost:(NSString *)host  Port:(int)port Tag:(int)tag;
-(GCDAsyncUdpSocket * )sendMessage:(id) classz data:(NSData *)data toHost:(NSString *)host  Port:(int)port Timeout:(int) time Tag:(int )tag;
@end
