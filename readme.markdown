# BDKActionJackson

A custom implementation (not a subclass) of UIActionSheet.

## Overview

For some reason or another (I can't remember now), I was unhappy with `UIActionSheet`. I was even *more* unhappy with `UIActivityViewController`, but that's a story for a different day.

I wanted something of my own that was more flexible than the standard `UIActionSheet`, so I wrote a custom view that handles much of the same. It's designed to be as simple as possible right now; feed it buttons, it adjusts its height accordingly. Your view controller can manage the buttons and their handlers. All `BDKActionJackson` cares about is the buttons' frames.

## Usage

For a more detailed example, check out [`BDKViewController`](https://github.com/kreeger/BDKActionJackson/blob/master/BDKActionJacksonSample/BDKViewController.m) in `BDKActionJacksonSample`, but here's the simple version.

``` objective-c
BDKActionJackson *sheet = [BDKActionJackson actionSheetInMasterFrame:self.view.window.frame];

sheet.title = @"How do you like your ribs?";
sheet.titleFont = [UIFont boldSystemFontOfSize:16];

// Make it slooooow
sheet.animationDuration = 2.5f;
sheet.animationDelay = 2.0f;

// Make it dark
sheet.dimmingOpacity = 0.8;
sheet.actionPaneOpacity = 0.9;

// Make it do something afterwards
sheet.dismissalBlock = ^(BOOL cancelTapped) {
    // Do what you like here; the view will remove itself from superview when it's done
    // (and before it calls this block)  
};

// Make it stay up after a button is hit
sheet.dismissesOnButtonTap = NO;

UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[button setTitle:@"Something" forState:UIControlStateNormal];
[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
[sheet addButton:button];

button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[button setTitle:@"Something Else" forState:UIControlStateNormal];
[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
[sheet addButton:button];

// Add it to the subview and present it; you'll want to do both at the same time
[self.view.window addSubview:sheet];
[sheet presentView:^{
    // Something upon completion
}]
```

You can even override the cancel button with whatever you want! Note that the cancel button (like all the buttons you feed to `BDKActionJackson`) is strongly-referenced inside of an array, so if you are creating the cancel button, create it as a separate object instance *first*, and then assigned your finished goods to the `cancelButton` property. That way you'll avoid any potential nasties. *Note that this may change in the future if I get around to writing an array with weak references instead.*

## To-do

I still need to work on proper auto-rotation methods. I need to set up a rotation listener for this, likely, which should help solve the issue.

## Contributing

You want to contribute to this project? Thanks! Send me your fixes in pull requests, and if they check out okay, I'll merge them.

## License

`BDKActionJackson` is released under the [MIT license](https://github.com/kreeger/BDKActionJackson/blob/master/license.markdown).
