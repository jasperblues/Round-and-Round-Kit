# Description

Adds 3D rotating view transitions to UINavigationController. 

I always liked how switching users on OSX rotates the view in a cube, and thought it would also be a nice way to 
switch between contexts in iPhone applications. 

There's a cube transition is in the iOS SDK, however it's a private API. So here's an open source implementation that does
more or less the same thing. 

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
anything to handle back button behavior. The drawback is that we're poking around in places we might not be welcome
. . . If you don't want this behavior, set this option to NO in UINavigationController+PushPopRotated.h. 

#Example Video

'Scuse the poor quality video, but it seems that animated gif is the only format that will currently play inside a 
README.md. 

<img src="https://github.com/downloads/jasperblues/Round-and-Round-Kit/round-and-round.gif"/>

# Installation

## Option 1 - Source

* Copy UINavigationController+PushPopRotated.h and UINavigationController+PushPopRotated.m to your project's source 
folder. 
* Copy JRSwizzle.h and JRSwizzle.m to your project's source folder. 

## Option 2 - Framework

Not available yet. 

# Authors

* Jasper Blues - jasper.blues@expanz.com
* © 2012 Jasper Blues

# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

