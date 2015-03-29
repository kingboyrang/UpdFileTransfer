//
//  UdpConfig.h
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#ifndef UpdFileTransfer_UdpConfig_h
#define UpdFileTransfer_UdpConfig_h

#define kUDPPORT  9527  //端口
#define kUdpBroadcastIP  @"255.255.255.255"
#define kUdpSendBroadcast_Tag     0   //服务器发广播tag
#define kUdpReceivedBroadcast_Tag 1   //客户端接收到广播tag发送本身地址
#define kNotificationIPReceivedFinishd   @"kNotificationIPReceivedFinishd"  //收到客户端IP地址

/**
 待发送文件信息报文	1	待文件信息回应报文	11
 发送文件内容报文	2	接收文件内容结果报文	12
 **/

#define kFileSendWaitTag        1  //待发送文件信息报文
#define kFileReceiveWaitTag     11  //待文件信息回应报文

#define kSendFileContentTag     2 //发送文件内容报文
#define kReceiveFileContentTag  12 //接收文件内容结果报文

#endif
