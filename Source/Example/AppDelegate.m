////////////////////////////////////////////////////////////////////////////////
//
//  Jasper Blues
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "AppDelegate.h"

#import "FirstViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    FirstViewController* firstViewController =
            [[FirstViewController alloc] initWithNibName:@"FirstView" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
