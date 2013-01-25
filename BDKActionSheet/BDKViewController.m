//
//  BDKViewController.m
//  BDKActionSheet
//
//  Created by Benjamin Kreeger on 1/25/13.
//  Copyright (c) 2013 Ben Kreeger. All rights reserved.
//

#import "BDKViewController.h"

@interface BDKViewController ()

@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UILabel *label;

/** Fired when the share button gets tapped.
 *  @param sender the sender of the event.
 */
- (void)shareButtonTapped:(UIBarButtonItem *)sender;

@end

@implementation BDKViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = @[self.shareButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIBarButtonItem *)shareButton {
    if (_shareButton) return _shareButton;
    _shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                 target:self
                                                                 action:@selector(shareButtonTapped:)];
    return _shareButton;
}

- (UILabel *)label {
    if (_label) return _label;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.text = @"See that action button down there?\nTap it.";
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:36];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    [_label sizeToFit];
    CGRect frame = CGRectIntegral(_label.frame);
    frame.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(frame)) / 2;
    frame.origin.y = (CGRectGetHeight(self.view.frame) - CGRectGetHeight(frame)) / 2;
    _label.frame = frame;
    return _label;
}

#pragma mark - Actions

- (void)shareButtonTapped:(UIBarButtonItem *)sender {
    NSLog(@"Share button %@ tapped.", sender);
}

@end
