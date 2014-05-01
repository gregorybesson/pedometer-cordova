//
//  PedometerCordova.m
//  pedometer-cordova
//
//  Created by Grégory Besson on 01 May 2014.
//
//

#import "PedometerCordova.h"
#import <Cordova/CDV.h>

@implementation PedometerCordova

- (void)init:(CDVInvokedUrlCommand*)command
{
    pluginResult = nil;
    
    callbackId = command.callbackId;
    
    self.solocationObj = [[SoLocationManager alloc] init];
    [self.solocationObj setDelegate:self];
    
    [self.commandDelegate runInBackground:^{
        
        thread = [NSThread currentThread];
    }];
}

- (void)start:(CDVInvokedUrlCommand*)command
{
    [self start];
    [self.commandDelegate runInBackground:^{
        //[self start];
    }];
}

- (void) start {
    [self.solocationObj start];
    NSLog(@"start");
}


- (void)stop:(CDVInvokedUrlCommand*)command
{
    [self stop];
    [self.commandDelegate runInBackground:^{
        //[self stop];
    }];
}

- (void) stop {
    [self.solocationObj stop];
    NSLog(@"stop");
}

#pragma mark - SOLocationManager Delegate -
- (BOOL)didReceiveResponse:(NSData *)data
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString: %@", responseString);
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseString];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    
    return YES;
}

- (void)showLoadingView
{
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"showLoadingView"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)requestFailedWithError:(NSError *)error
{
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"errof :%@", error]];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

@end