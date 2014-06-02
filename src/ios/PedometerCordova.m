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
    autoWalk = NO;
    
    if([command.arguments count] >= 1) {
        environnement = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
        incrementCounterWalk = 1;
        if([environnement isEqualToString:@"debug"]){
            autoWalk = YES;
        }
    }
    if([command.arguments count] >= 2) {
        incrementCounterWalk = [[NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:1]] doubleValue];
    }
    
    
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
    if(autoWalk){
        counterWalk = 0;
        [self autoWalk:YES];
        NSLog(@"fake start");
    }
    else{
        [self.somotionObj startDetection];
        NSLog(@"start");
    }
}


- (void)stop:(CDVInvokedUrlCommand*)command
{
    [self stop];
    [self.commandDelegate runInBackground:^{
        //[self stop];
    }];
}

- (void) stop {
    if(autoWalk){
        [self autoWalk:NO];
        NSLog(@"fake stop");
    }
    else{
        [self.somotionObj stopDetection];
        NSLog(@"stop");
    }
}

- (void) walk:(NSTimer *)t {
    int i = 5;
    counterWalk += incrementCounterWalk;
    NSLog(@"counterWalk %g", counterWalk);
    if(counterWalk > 50){
        counterWalk = 0;
    }
    if(counterWalk < 0.3){
        i = 1;
    }
    else if(counterWalk < 2.8){
        i = 2;
    }
    else if(counterWalk < 5.5){
        i = 3;
    }
    else if(counterWalk < 8){
        i = 4;
    }
    [self responseMotionType:i];
    [self responseKm:counterWalk/3.6f];
}

- (void) autoWalk:(BOOL)toggle {
    if (toggle){
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(walk:) userInfo:nil repeats:YES];
    }
    else{
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark - MotionDetector Delegate
- (void)motionDetector:(SOMotionDetector *)motionDetector motionTypeChanged:(SOMotionType)motionType
{
    [self responseMotionType:motionType];
}

- (void) responseMotionType:(int)i
{
    NSString *type = @"";
    switch (i) {
        case MotionTypeNotMoving:
            type = @"Not moving";
            break;
        case MotionTypeWalking:
            type = @"Walking";
            break;
        case MotionTypeRunning:
            type = @"Running";
            break;
        case MotionTypeSprinting:
            type = @"Sprinting";
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
    [self responseKm:motionDetector.currentSpeed];
}

- (void)responseKm:(double) d
{
    
    NSString *responseString = [NSString stringWithFormat:@"%.2f km/h",d * 3.6f];
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