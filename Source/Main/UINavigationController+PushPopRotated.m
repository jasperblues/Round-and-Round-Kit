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

#import "UINavigationController+PushPopRotated.h"
#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "JRSwizzle.h"

#ifdef HAS_STUATS_BAR
#define PAGE_VERTICAL_WIDTH                      320.0f
#define PAGE_VERTICAL_HEIGHT                     460.0f
#define PAGE_HORIZONTAL_WIDTH                    480.0f
#define PAGE_HORIZONTAL_HEIGHT                   300.0f
#define CONTENT_Y_OFFSET                         20.0f
#else
#define PAGE_VERTICAL_WIDTH                      320.0f
#define PAGE_VERTICAL_HEIGHT                     480.0f
#define PAGE_HORIZONTAL_WIDTH                    480.0f
#define PAGE_HORIZONTAL_HEIGHT                   320.0f
#define CONTENT_Y_OFFSET                         0.0f
#endif

#define radians(degrees) degrees * M_PI / 180
#define CUBESIZE 320.0f

static char const* const backgroundKey = "backgroundKey";
static char const* const rotationLayerKey = "rotationLayerKey";
static char const* const animationStyleStackKey = "animationStyleStackKey";

/* ================================================================================================================== */
@implementation NSMutableArray (PushPop)

- (BOOL) popRotation {
    NSNumber* lastObject = [self lastObject];
    if (lastObject) {
        [self removeLastObject];
    }
    return [lastObject boolValue];
}

- (BOOL) peekRotation {
    return [[self lastObject] boolValue];
}

- (void) pushRotation:(BOOL)rotation {
    [self addObject:[NSNumber numberWithBool:rotation]];
}
@end
/* ================================================================================================================== */


@implementation UINavigationController (PushPopRotated)

/* ================================================= Class Methods ================================================== */
+ (void) load {
    if (SWIZZLE_BACK) {
        NSLog(@"JBCubeController: SWIZZLE_BACK is enabled. The back button will remember which style of animation was "
                "used to display the view.");
        [[self class] jr_swizzleMethod:@selector(pushViewController:animated:)
                withMethod:@selector(storeAnimationStyleAndPushViewController:animated:) error:nil];
        [[self class] jr_swizzleMethod:@selector(popViewControllerAnimated:)
                withMethod:@selector(retrieveAnimationStyleAndPopViewControllerAnimated:) error:nil];
    }
    [super load];
}

/* ================================================ Interface Methods =============================================== */
- (void) pushViewController:(UIViewController*)controller rotated:(BOOL)rotated {
    if (SWIZZLE_BACK) {
        [[self animationStyleStack] pushRotation:YES];
        [[self class] jr_swizzleMethod:@selector(storeAnimationStyleAndPushViewController:animated:)
                withMethod:@selector(pushViewController:animated:) error:nil];
    }

    if (rotated) {
        CALayer* rotateLayer = [self makeLayer];
        CATransform3D world = CATransform3DMakeTranslation(0, 0, 0);
        [rotateLayer addSublayer:[self makeSurfaceOn:world withView:self.view]];
        world = CATransform3DRotate(world, radians(90), 0, 1, 0);
        world = CATransform3DTranslate(world, CUBESIZE, 0, 0);

        [self pushViewController:controller animated:NO];
        [rotateLayer addSublayer:[self makeSurfaceOn:world withView:self.view]];

        UIView* background = [self makeBackgroundWithColor:[UIColor blackColor]];
        [self.view addSubview:background];

        [self.view.layer addSublayer:rotateLayer];
        [rotateLayer addAnimation:[self makeRotationAnimation:RightToLeft duration:0.75f] forKey:nil];
        objc_setAssociatedObject(self, rotationLayerKey, rotateLayer, OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_ASSIGN);
    }
    else {
        [self pushViewController:controller animated:NO];
    }
    if (SWIZZLE_BACK) {
        [[self class] jr_swizzleMethod:@selector(pushViewController:animated:)
                withMethod:@selector(storeAnimationStyleAndPushViewController:animated:) error:nil];
    }
}

- (void) popViewControllerRotated:(BOOL)rotated {
    return [self popViewControllerRotated:rotated refreshNavBar:NO];
}


/* ================================================== Private Methods =============================================== */
- (void) popViewControllerRotated:(BOOL)rotated refreshNavBar:(BOOL)refreshNavBar {
    if (SWIZZLE_BACK) {
        [[self class] jr_swizzleMethod:@selector(retrieveAnimationStyleAndPopViewControllerAnimated:)
                withMethod:@selector(popViewControllerAnimated:) error:nil];
        [[self animationStyleStack] popRotation];
    }

    if (rotated) {
        CALayer* rotateLayer = [self makeLayer];
        CATransform3D world = CATransform3DMakeTranslation(0, 0, 0);
        [rotateLayer addSublayer:[self makeSurfaceOn:world withView:self.view]];
        world = CATransform3DRotate(world, radians(90), 0, 1, 0);
        world = CATransform3DTranslate(world, CUBESIZE, 0, 0);
        world = CATransform3DRotate(world, radians(90), 0, 1, 0);
        world = CATransform3DTranslate(world, CUBESIZE, 0, 0);
        world = CATransform3DRotate(world, radians(90), 0, 1, 0);
        world = CATransform3DTranslate(world, CUBESIZE, 0, 0);

        [self popViewControllerAnimated:NO];
        if (refreshNavBar) {
            UINavigationItem* item = [[self navigationBar] popNavigationItemAnimated:NO];
            [rotateLayer addSublayer:[self makeSurfaceOn:world withView:self.view]];
            [[self navigationBar] pushNavigationItem:item animated:NO];
        }
        else {
            [rotateLayer addSublayer:[self makeSurfaceOn:world withView:self.view]];
        }

        UIView* background = [self makeBackgroundWithColor:[UIColor blackColor]];
        [self.view addSubview:background];

        [self.view.layer addSublayer:rotateLayer];
        [rotateLayer addAnimation:[self makeRotationAnimation:LeftToRight duration:0.75f] forKey:nil];
        objc_setAssociatedObject(self, rotationLayerKey, rotateLayer, OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_ASSIGN);
    }
    else {
        [self popViewControllerAnimated:NO];
    }

    if (SWIZZLE_BACK) {
        [[self class] jr_swizzleMethod:@selector(popViewControllerAnimated:)
                withMethod:@selector(retrieveAnimationStyleAndPopViewControllerAnimated:) error:nil];
    }
}

- (CALayer*) makeLayer {
    CALayer* rotateLayer = [CALayer layer];
    rotateLayer.frame = self.view.frame;

    rotateLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -750;
    [rotateLayer setSublayerTransform:sublayerTransform];
    return rotateLayer;
}

- (CALayer*) makeSurfaceOn:(CATransform3D)world withView:(UIView*)view {
    CGRect rect = CGRectMake(0, 0, PAGE_VERTICAL_WIDTH, PAGE_VERTICAL_HEIGHT);
    CALayer* imageLayer = [CALayer layer];
    imageLayer.anchorPoint = CGPointMake(1, 1);
    imageLayer.frame = rect;
    imageLayer.transform = world;
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageLayer.contents = (__bridge id) [viewImage CGImage];
    return imageLayer;
}

- (UIView*) makeBackgroundWithColor:(UIColor*)color {
    UIView* background = [[UIView alloc] initWithFrame:self.view.frame];
    [background setBackgroundColor:color];
    return background;
}

- (CAAnimation*) makeRotationAnimation:(RotationDirection)aDirection duration:(float)aDuration {
    [CATransaction flush];
    CABasicAnimation* rotation;
    CABasicAnimation* translationX;
    CABasicAnimation* translationZ;
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = aDuration;

    if (aDirection == RightToLeft) {
        translationX = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.x"];
        translationX.toValue = [NSNumber numberWithFloat:-(PAGE_VERTICAL_WIDTH / 2)];
        rotation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
        rotation.toValue = [NSNumber numberWithFloat:radians(-90)];
    }
    else {
        translationX = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.x"];
        translationX.toValue = [NSNumber numberWithFloat:(PAGE_VERTICAL_WIDTH / 2)];
        rotation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
        rotation.toValue = [NSNumber numberWithFloat:radians(90)];
    }

    translationZ = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.z"];
    translationZ.toValue = [NSNumber numberWithFloat:-(PAGE_VERTICAL_WIDTH / 2)];
    group.animations = [NSArray arrayWithObjects:rotation, translationX, translationZ, nil];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return group;
}

- (void) animationDidStop:(CAAnimation*)animation finished:(BOOL)finished {
    [objc_getAssociatedObject(self, rotationLayerKey) removeFromSuperlayer];
    [objc_getAssociatedObject(self, backgroundKey) removeFromSuperview];
}

- (void) storeAnimationStyleAndPushViewController:(UIViewController*)viewController animated:(BOOL)animated {
    [[self animationStyleStack] pushRotation:NO];
    [[self class] jr_swizzleMethod:@selector(storeAnimationStyleAndPushViewController:animated:)
            withMethod:@selector(pushViewController:animated:) error:nil];
    [self pushViewController:viewController animated:animated];
    [[self class] jr_swizzleMethod:@selector(pushViewController:animated:)
            withMethod:@selector(storeAnimationStyleAndPushViewController:animated:) error:nil];
}

- (void) retrieveAnimationStyleAndPopViewControllerAnimated:(BOOL)animated {
    if ([[self animationStyleStack] peekRotation]) {
        [self popViewControllerRotated:animated refreshNavBar:YES];
    }
    else {
        [[self class] jr_swizzleMethod:@selector(retrieveAnimationStyleAndPopViewControllerAnimated:)
                withMethod:@selector(popViewControllerAnimated:) error:nil];
        [self popViewControllerAnimated:animated];
        [[self class] jr_swizzleMethod:@selector(popViewControllerAnimated:)
                withMethod:@selector(retrieveAnimationStyleAndPopViewControllerAnimated:) error:nil];
        NSLog(@"Swizzled back");
    }
}

- (NSMutableArray*) animationStyleStack {
    NSMutableArray* animationStyleStack = objc_getAssociatedObject(self, animationStyleStackKey);
    if (animationStyleStack == nil) {
        animationStyleStack = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, animationStyleStackKey, animationStyleStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return animationStyleStack;
}


@end
