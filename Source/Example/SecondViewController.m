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

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "UINavigationController+PushPopRotated.h"


@implementation SecondViewController

- (id) initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Another view"];
    }
    return self;
}


- (IBAction) popController:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* navigationController = [delegate navigationController];
    [navigationController popViewControllerRotated:YES];
}


@end