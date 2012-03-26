# Description

Adds 3D rotating view transitions to UINavigationController. 

I always liked how switching users on OSX rotates the view in a cube, and thought it would also be a nice way to switch
between contexts in iPhone applications. 

The cube transition is in the SDK, however unfortunately it's a private API. This kit adds two methods to 
UINavigationController to provide the same behavior. 

# Usage

Clone the module and run the example. 

## Pushing a view controller

```objective-c 
[navigationController pushViewController:_secondViewController rotated:YES];
```

## Popping a view controller 

```objective-c
[navigationController popViewControllerRotated:YES];
```

## Back button behavior 

Use SWIZZLE_BACK = YES (default) to tell the UINavigationController to track which animation style was used when 
pushing a view controller, and apply the same when popping. The benefit of this is you don't have to do anything to 
handle back button behavior. 

#Example Video

<img src="https://github.com/downloads/jasperblues/Round-and-Round-Kit/round-and-round-kit1.gif"/>

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

