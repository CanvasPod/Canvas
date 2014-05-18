# DAKeyboardControl

`DAKeyboardControl` allows you to easily add keyboard awareness and scrolling dismissal (a receding keyboard ala iMessages app) to any `UIView`,`UIScrollView` or `UITableView` with only 1 line of code. `DAKeyboardControl` automatically extends `UIView` and provides a block callback with the keyboard's current frame.

`DAKeyboardControl` now fully supports orientation changes, iPhone & iPad, and is even aware of keyboard undocking or splitting on the iPad.

No hacks, fully App Store safe.

![Screenshot](https://github.com/danielamitay/DAKeyboardControl/raw/master/screenshot.png)

[Video demonstration on YouTube](http://www.youtube.com/watch?v=J6GLro0cyDU)

## Installation

- Copy over the `DAKeyboardControl` folder to your project folder.
- `#import "DAKeyboardControl.h"`

## Usage

Example project included (DAKeyboardControlExample)

### Adding pan-to-dismiss (functionality introduced in iMessages)

```objective-c
[self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        // Move interface objects accordingly
		// Animation block is handled for you
    }];
	// Make sure to call [self.view removeKeyboardControl] before the view is released.
	// (It's the balancing call)
```

### Adding keyboard awareness (appearance and disappearance only)

```objective-c
[self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
        // Move interface objects accordingly
		// Animation block is handled for you
    }];
	// Make sure to call [self.view removeKeyboardControl] before the view is released.
	// (It's the balancing call)
```

### Supporting an above-keyboard input view

The `keyboardTriggerOffset` property allows you to choose at what point the user's finger "engages" the keyboard.

```objective-c
self.view.keyboardTriggerOffset = 44.0f;	// Input view frame height

[self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        // Move input view accordingly
		// Animation block is handled for you
    }];
	// Make sure to call [self.view removeKeyboardControl] before the view is released.
	// (It's the balancing call)
```

### Dismissing the keyboard (convenience method)

```objective-c
[self.view hideKeyboard];
```

### Remove the NSNotification observer at the end of a VC's life (convenience method)

```objective-c
[self.view removeKeyboardControl];
```

## Notes

### Tested in App Store!
All code is iOS 5.0+ safe and well documented, and is already in production apps on the App Store.

### Using with a `UITextView`
Make sure to call `addKeyboardPanningWithActionHandler:` on the `UITextView` itself if you wish for it to allow panning inside itself.

### Keyboard Delay On First Appearance
Standard iOS issue. Use Brandon William's [UIResponder category](https://github.com/mbrandonw/UIResponder-KeyboardCache) to cache the keyboard before first use.

### Automatic Reference Counting (ARC) support
`DAKeyboardControl` was made with ARC enabled by default.

## Contact

- [@danielamitay](http://twitter.com/danielamitay)
- hello@danielamitay.com
- http://www.danielamitay.com

If you use/enjoy `DAKeyboardControl`, let me know!

## License

### MIT License

Copyright (c) 2012 Daniel Amitay (http://danielamitay.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
