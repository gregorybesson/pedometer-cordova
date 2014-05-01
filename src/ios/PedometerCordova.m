//
//  SpeechToTextPhonegap.m
//  text-speech-cordova
//
//  Created by nicolas labbé on 12/04/2014.
//
//

#import "SpeechToTextPhonegap.h"
#import <Cordova/CDV.h>

@implementation SpeechToTextPhonegap

- (void)init:(CDVInvokedUrlCommand*)command
{
    pluginResult = nil;
    
    callbackId = command.callbackId;
    
    self.speechToTextObj = [[SpeechToTextModule alloc] init];
    [self.speechToTextObj setDelegate:self];
    
    [self.commandDelegate runInBackground:^{
        
        thread = [NSThread currentThread];
    }];
}

- (void)record:(CDVInvokedUrlCommand*)command
{
    [self record];
    [self.commandDelegate runInBackground:^{
        //[self record];
    }];
}

- (void) record {
    [self.speechToTextObj beginRecording];
    NSLog(@"record");
}


- (void)stopRecording:(CDVInvokedUrlCommand*)command
{
    [self stopRecording];
    [self.commandDelegate runInBackground:^{
        //[self stopRecording];
    }];
}

- (void) stopRecording {
    [self.speechToTextObj stopRecording:YES];
    NSLog(@"stop");
}

#pragma mark - SpeechToTextModule Delegate -
- (BOOL)didReceiveVoiceResponse:(NSData *)data
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