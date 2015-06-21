//
//  SocketHelper.m
//  labyrinthClient
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "SocketHelper.h"

@implementation SocketHelper

static SocketHelper *_sharedInstance = nil;

+ (SocketHelper *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
        
    });
    return _sharedInstance;
}


-(void)connect {
    int sDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (sDescriptor == -1) {
        NSLog(@"Error creating socket");
        _connected = NO;
    }
    else {
        _socketDescriptor = sDescriptor;
    }
    struct sockaddr_in server_addr ;
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_port = htons(7000) ;
    //192.168.0.20
    server_addr.sin_addr.s_addr = inet_addr("192.168.1.225");
    server_addr.sin_family = AF_INET;
    
    int returnValue = connect(sDescriptor, (const struct sockaddr *)&server_addr, sizeof(server_addr));
    if (returnValue == 0) {
        NSLog(@"Connected successfully");
        _connected = YES;
    }
    else {
        NSLog(@"Error occured while connecting: code %d %s", errno, strerror(errno));
        _connected = NO;
    }

}

-(BOOL)sendString:(NSString*)string {
    NSData* sendData = [string dataUsingEncoding:NSUTF8StringEncoding];
    const void* buffer = [sendData bytes];
    size_t bufferSize = string.length;

    int sendResponse = send(_socketDescriptor, buffer, bufferSize, 0);
    if (sendResponse == -1) {
        NSLog(@"Error occured while sending: code %d %s", errno, strerror(errno));
        return NO;
    } else {
        NSLog(@"Sent successfully: %d bytes", sendResponse);
        return YES;
    }
}


-(NSString*)receiveString {
    char buffer[1024];
    size_t bufferSize = 1024;

    int receivedBytes = recv(_socketDescriptor, buffer, bufferSize, 0);
    if (receivedBytes == -1) {
        NSLog(@"Error occured while receiving: code %d %s", errno, strerror(errno));
        return @"";
    } else {
        NSLog(@"Received successfully: %d bytes", receivedBytes);
        buffer[receivedBytes] = '\0';
        NSString* returnString = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
        return returnString;
    }
    
}



@end
