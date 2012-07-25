//
//  NLAppDelegate.m
//  IRRemote
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2012 9Lab. All rights reserved.
//

#import "NLAppDelegate.h"
#import "FSKSerialGenerator.h"
#import "NLMainViewController.h"

@implementation NLAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize generator = _generator;

- (void)dealloc
{
    [_generator release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"0x01FF00FF", @"first", // NEC protocol previous channel
      @"0x01FF807F", @"second", // NEC protocol next channel
      nil]];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.viewController = [[[NLMainViewController alloc] init] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
	session.delegate = self;
	if(session.inputIsAvailable){
		[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	}else{
		[session setCategory:AVAudioSessionCategoryPlayback error:nil];
	}
	[session setActive:YES error:nil];
	[session setPreferredIOBufferDuration:0.023220 error:nil];
    
	_generator = [[FSKSerialGenerator alloc] init];
	[_generator play];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - AVAudioSessionDelegate

- (void)inputIsAvailableChanged:(BOOL)isInputAvailable
{
	NSLog(@"inputIsAvailableChanged %d",isInputAvailable);
	
	AVAudioSession *session = [AVAudioSession sharedInstance];
	
	[_generator stop];
	
	if(isInputAvailable){
		[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	}else{
		[session setCategory:AVAudioSessionCategoryPlayback error:nil];
	}
	[_generator play];
}

- (void)beginInterruption
{
	NSLog(@"beginInterruption");
}

- (void)endInterruption
{
	NSLog(@"endInterruption");
}

- (void)endInterruptionWithFlags:(NSUInteger)flags
{
	NSLog(@"endInterruptionWithFlags: %x",flags);
}

@end
