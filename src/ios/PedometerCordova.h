//
//  PedometerCordova.h
//  pedometer-cordova
//
//  Created by Grégory Besson on 01/05/2014.
//
//

#import <Cordova/CDVPlugin.h>
#import "SOLocationManager.h"
#import "SOMotionDetector.h"

@interface PedometerCordova : CDVPlugin<SOMotionDetectorDelegate> {
    
    // PHONEGAP
    NSString *callbackId;
    CDVPluginResult* pluginResult;
    // ENVIRONNEMENT SETTING
    NSString *environnement;
    BOOL autoWalk;
    NSTimer *timer;
    double counterWalk;
    double incrementCounterWalk;
    // UTIL
    NSThread *thread;
}

@property(nonatomic, strong)SOMotionDetector *somotionObj;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) start:(CDVInvokedUrlCommand*)command;
- (void) start;
- (void) stop:(CDVInvokedUrlCommand*)command;
- (void) stop;
- (void) autoWalk:(BOOL)toggle;

@end