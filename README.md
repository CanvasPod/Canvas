![](http://f.cl.ly/items/3435000d3G1E3t3m0J0X/canvas.png)


Canvas is a project to simplify iOS development for both designers and developers.
It had been difficult for designers to get hands on building the product with the lack of objective-c and Xcode experience, and a hard time for developer to use reasonable amount of time and lines of code just to achieve really simple effects.

With Canvas, creating stunning animations requires zero lines of code, trendy effects like the Parallax headers, Sticky sections, Blurred Backgrounds, will be as simple as few lines of code changes.

Demo App
========

![](http://f.cl.ly/items/350X372e2i1x2y2A1h0K/canvas-animation.gif)

The demo app in this project uses [CocoaPods][], please run `pod install` after you download this project, then open `Canvas.xcworkspace`. 

See this screencast in action:

![](http://f.cl.ly/items/1Q1V3s3y021m3I2L0r3i/running-demo-short.gif)

Unable to build demo?
-----

If you're getting some errors like **Accelerate.framework not include**, please update your CocoaPods version:

    $ [sudo] gem install cocoapods


We also have a live demo avaliable at [homepage][].



Getting Started
===============

If you're already on CocoaPods, installing our library is easy:

    $ edit Podfile
    platform :ios, '7.0'
    pod 'Canvas', '~> 0.1'

Make sure you also update the dependencies by running this command afterwards:

    pod install

Then you should now have the Xcode workspace (`.xcworkspace`) ready.

    $open App.xcworkspace
    
That's it and you are good to go! See our [blog posts][homepage] for hands on tutorial.


How to Use
==========

Using Interface Builder (no code required)
----

![](http://f.cl.ly/items/0q0H031a023Y243k3F1O/img-animation@2x.png)

Specify the class `CSAnimationView`, and configurate the runtime attributes `duration`, `delay`, and `type`.

Please also get started with our more [detailed explaination][tutorial] on what Canvas can do.

Using Code
----------

It's very similar to using Interface Builder, instead you just setup the custom view in code.

```objective-c
#import "Canvas.h"
```

```objective-c
CSAnimationView *animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

animationView.backgroundColor = [UIColor whiteColor];

animationView.duration = 0.5;
animationView.delay    = 0;
animationView.type     = CSAnimationTypeMorph;

[self.view addSubview:animationView];

// Add your subviews into animationView
// [animationView addSubview:<#(UIView *)#>]

// Kick start the animation immediately
[animationView startCanvasAnimation];
```

Updates
=======

v0.1.2 - 9 new animations, thanks for
[Jake-Piatkowski][] adding those
awesome effects!

v0.1.1 - Minor fixes

v0.1 - Initial release


Requirements
============

iOS 7, Xcode 5


Who's behind?
=============

- [James Tang][] ([@jamztang][])
- [Meng To][] ([@mengto][])



LICENSE
=======
Canvas is available under the MIT license. See the LICENSE file for more info.

[homepage]:http://canvaspod.io
[CocoaPods]:http://cocoapods.org
[James Tang]:http://github.com/jamztang
[Meng To]:http://mengto.com
[@jamztang]:http://twitter.com/@jamztang
[@mengto]:http://twitter.com/@mengto
[tutorial]:https://medium.com/p/20c82a904164
[#9]:https://github.com/CanvasPod/Canvas/issues/9
[Jake-Piatkowski]:https://github.com/Jake-Piatkowski
