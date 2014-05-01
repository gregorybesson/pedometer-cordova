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
    
    self.somotionObj = [[SOMotionDetector alloc] init];
    [SOMotionDetector sharedInstance].delegate = self;
    
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
    [self.somotionObj startDetection];
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
    [self.somotionObj stopDetection];
    NSLog(@"stop");
}

#pragma mark - MotionDetector Delegate
- (void)motionDetector:(SOMotionDetector *)motionDetector motionTypeChanged:(SOMotionType)motionType
{
    NSString *type = @"";
    switch (motionType) {
        case MotionTypeNotMoving:
            type = @"Not moving";
            break;
        case MotionTypeWalking:
            type = @"Walking";
            break;
        case MotionTypeRunning:
            type = @"Running";
            break;
        case MotionTypeAutomotive:
            type = @"Automotive";
            break;
    }
    
    NSString *responseString = type;
    NSLog(@"responseString: %@", type);
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseString];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)motionDetector:(SOMotionDetector *)motionDetector locationChanged:(CLLocation *)location
{

    NSString *responseString = [NSString stringWithFormat:@"%.2f km/h",motionDetector.currentSpeed * 3.6f];
    NSLog(@"responseString: %@", responseString);
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseString];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)motionDetector:(SOMotionDetector *)motionDetector accelerationChanged:(CMAcceleration)acceleration
{
    BOOL isShaking = motionDetector.isShaking;
    
    NSString *responseString = isShaking ? @"shaking":@"not shaking";
    NSLog(@"responseString: %@", responseString);
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseString];
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