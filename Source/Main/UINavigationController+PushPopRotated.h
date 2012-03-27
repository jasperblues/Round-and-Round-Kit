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

#import <Foundation/Foundation.h>

#define SWIZZLE_BACK    YES

typedef enum {
    LeftToRight = 0,
    RightToLeft,
} RotationDirection;

@interface UINavigationController (PushPopRotated)

- (void) pushViewController:(UIViewController*)controller rotated:(BOOL)rotated;

- (void) popViewControllerRotated:(BOOL)rotated;


@end