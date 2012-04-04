Playground
==========

Playground is a utility that lets you inspect and modify layout properties while your app is running.
Enable Playground with a gesture, update your layout and keep track of the changes through email.
When running your app in the Simulator, there’s support for using the keyboard to modify
layout properties.

![Playground screenshot](https://github.com/scott-tran/PlaygroundDemo/raw/master/screenshot.png)

Example project: [Playground Demo](https://github.com/scott-tran/PlaygroundDemo)

Usage
-----
Add the QuartzCore and MessageUI frameworks to your project.
Copy all the files in the Playground source folder to your project. If you’re using ARC, remember to add the `-fno-objc-arc` flag to the added files.
To integrate Playground into your app:

    self.window = [[PGWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

You can enable/disable Playground with a two finger long press gesture, or define your own by setting the activateGestureRecognizer property.

Keyboard Mapping
----------------
<table cellpadding="10">
<tr><td border="0">Move view</td><td border="0">← → ↑ ↓</td><tr/>
<tr><td border="0">Decrease width</td><td border="0">a</td><tr/>
<tr><td border="0">Increase width</td><td border="0">d</td><tr/>
<tr><td border="0">Decrease height</td><td border="0">s</td><tr/>
<tr><td border="0">Increase height</td><td border="0">w</td><tr/>
<tr><td border="0">Move left in view hierarchy</td><td border="0">j</td><tr/>
<tr><td border="0">Move right in view hierarchy</td><td border="0">l</td><tr/>
<tr><td border="0">Move up in view hierarchy</td><td border="0">i</td><tr/>
<tr><td border="0">Move down in view hierarchy</td><td border="0">k</td><tr/>
<tr><td border="0">Display properties in console</td><td border="0">p</td><tr/>
<tr><td border="0">Mail properties</td><td border="0">m</td><tr/>
</table>

License
-------
Apache License, Version 2.0  
by Scott Tran  
Twitter: [@scott_tran](http://twitter.com/scott_tran)