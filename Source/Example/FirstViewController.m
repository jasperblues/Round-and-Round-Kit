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
#import "SecondViewController.h"
#import "FirstViewController.h"
#import "UINavigationController+PushPopRotated.h"

@implementation FirstViewController

@synthesize secondViewController = _secondViewController;

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Rotate Me!"];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction) pushController:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* navigationController = [delegate navigationController];
    _secondViewController = [[SecondViewController alloc] initWithNibName:@"SecondView" bundle:[NSBundle mainBundle]];
    [navigationController pushViewController:_secondViewController rotated:YES];

}

@end
