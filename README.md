# Update Feb, 2014

This is a pretty old project. I was fooling around with 3D, swizzling etc when I was learning Objective-C. You still might find something useful here. 

* For 3D animations, set the m34 (perspective) matrix on a layer. Then apply some transformations. 


# Description

Adds 3D rotating view transitions to UINavigationController. 

I always liked how switching users on OSX rotates the view in a cube, and thought it would also be a nice way to 
switch between contexts in iPhone applications. There's a cube transition is in the iOS SDK, however it's a private API. So here's an open source implementation that does
more or less the same thing. Key features are: 

* Just one category to add to your project. 
* Push with 3D rotations in one line. 
* Back button behavior is taken care of - the category will know when to pop with rotation vs default animation style. 
* No private API calls.                                         

# Usage

## Getting Started

Clone the module and run the example. 

## Pushing a view controller

```objective-c 
[navigationController pushViewController:_secondViewController rotated:YES];
```

## Popping a view controller 

```objective-c
[navigationController popViewControllerRotated:YES];
```
. . . or if using SWIZZLE_BACK (see below) just do a regular pop:

```objective-c
[navigationController popViewControllerAnimated:YES];
```

## Back button behavior 

Use SWIZZLE_BACK = YES (default) to tell the UINavigationController to track which animation style was used when 
pushing a view controller. It will then apply the same when popping. The benefit of this is you don't have to do
anything to handle back button behavior. The drawback is that it's:

* You just swizzled a UIKit class. Discouraged (but not banned) by Apple
* May require updates for future iOS SDK versions. 

. . . If you don't want this behavior, set this option to NO in UINavigationController+PushPopRotated.h. 

#Example Video

'Scuse the poor quality video, but it seems that animated gif is the only format that will currently play inside a 
README.md. 

<img src="https://github.com/downloads/jasperblues/Round-and-Round-Kit/round-and-round.gif"/>

# Limitations

Currently the view does not update during the 0.75secs that a transition is in progress. It's necessary to set up the
view beforehand. 

# Installation

## Option 1 - Source

* Copy UINavigationController+PushPopRotated.h and UINavigationController+PushPopRotated.m to your project's source 
folder. 
* Copy JRSwizzle.h and JRSwizzle.m to your project's source folder. 

## Option 2 - Framework

Not available yet. 

# Authors

* Jasper Blues - jasper@appsquick.ly
* © 2012 Jasper Blues

# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

