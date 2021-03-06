//
//  BDKActionSheet.m
//  Created by Benjamin Kreeger on 1/25/13.
//

#import "BDKActionJackson.h"
#import "BDKGradientView.h"

#import <QuartzCore/QuartzCore.h>

@interface BDKActionJackson () <UIGestureRecognizerDelegate>

@property (nonatomic) UIView *overlay;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) UIDeviceOrientation currentOrientation;

@property (nonatomic) CGFloat height;
@property (strong, nonatomic) UIView *shine;
@property (nonatomic) BOOL visible;

/** Handles resizing the overlay view for the number of allocated buttons.
 */
- (void)updateHeightForButtons;

/** The internal dismissal method that gets called, with a BOOL regarding what was tapped.
 *  @param wasCanceled if YES, the cancel button or background tap triggered the method.
 */
- (void)dismissView:(BOOL)wasCanceled;

/** Fired when any button is tapped.
 *  @param sender the sender of the event.
 */
- (void)buttonTapped:(UIButton *)sender;

/** Fired when the background of the view is tapped.
 *  @param sender the sender of the event.
 */
- (void)backgroundTapped:(UIGestureRecognizer *)sender;

/** Called when the view is visible and any orientation methods are fired.
 *  @param notification the notification object passed to the message from Notification Center.
 */
- (void)deviceOrientationDidChange:(NSNotification *)notification;

@end

@implementation BDKActionJackson

@synthesize title = _title, titleFont = _titleFont, cancelButton = _cancelButton;

#pragma mark - Lifecycle

+ (id)actionSheetInMasterFrame:(CGRect)masterFrame {
    return [[self alloc] initWithFrame:masterFrame];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _animationDelay = 0.0f;
        _animationDuration = 0.3f;
        _dimmingOpacity = 0.45;
        _actionPaneOpacity = 0.85;
        _visible = NO;
        _dismissesOnButtonTap = YES;

        [self addSubview:self.overlay];
        [self.overlay addSubview:self.shine];
        [self.overlay addSubview:self.label];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.cancelButton = cancelButton;
        
        // Set some defaults
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect shineFrame = self.frame;
    shineFrame.size.height = floorf(CGRectGetHeight(self.overlay.frame) / 2);
    self.shine.frame = shineFrame;
    CGFloat height = [self.label.text sizeWithFont:self.label.font
                                          forWidth:CGRectGetWidth(self.overlay.frame)
                                     lineBreakMode:self.label.lineBreakMode].height;
    self.label.frame = CGRectMake(0, 10, CGRectGetWidth(self.overlay.frame), height);
    
    [self updateHeightForButtons];
}

#pragma mark - Properties

- (NSMutableArray *)buttons {
    if (_buttons) return _buttons;
    _buttons = [NSMutableArray array];
    return _buttons;
}

- (void)setCancelButton:(UIButton *)cancelButton {
    [cancelButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger index = [self.buttons indexOfObject:_cancelButton];
    
    if (index == NSNotFound) {
        _cancelButton = cancelButton;
        [self.buttons addObject:_cancelButton];
    } else { 
        [_cancelButton removeFromSuperview];
        _cancelButton = cancelButton;
        [self.buttons replaceObjectAtIndex:index withObject:_cancelButton];
    }
}

- (NSString *)title {
    if (_title) return _title;
    _title = @"Actions";
    return _title;
}

- (UIFont *)titleFont {
    if (_titleFont) return _titleFont;
    _titleFont = [UIFont systemFontOfSize:14];
    return _titleFont;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
    [self setNeedsLayout];
    _title = title;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.label.font = titleFont;
    [self setNeedsLayout];
    _titleFont = titleFont;
}

#pragma mark - Private properties

- (UIView *)overlay {
    if (_overlay) return _overlay;
    CGRect frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 100);
    _overlay = [[UIView alloc] initWithFrame:frame];
    _overlay.alpha = self.actionPaneOpacity;
    _overlay.backgroundColor = [UIColor blackColor];
    return _overlay;
}

- (UILabel *)label {
    if (_label) return _label;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.text = self.title;
    _label.font = self.titleFont;
    _label.shadowColor = [UIColor blackColor];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.shadowOffset = CGSizeMake(0, -1);
    _label.textAlignment = NSTextAlignmentCenter;
    return _label;
}

- (UITapGestureRecognizer *)tapRecognizer {
    if (_tapRecognizer) return _tapRecognizer;
    // Default is one tap, one touch.
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    _tapRecognizer.delegate = self;
    return _tapRecognizer;
}

- (UIView *)shine {
    if (_shine) return _shine;
    CGRect frame = self.overlay.frame;
    frame.size.height = floorf(CGRectGetHeight(frame) / 3);
    _shine = [BDKGradientView gradientWithFrame:frame
                                     startColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]
                                       endColor:[[UIColor whiteColor] colorWithAlphaComponent:0]
                                      direction:BDKGradientViewDirectionTopToBottom];
    _shine.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    _shine.opaque = NO;
    return _shine;
}

- (BOOL)isVisible {
    return _visible;
}

- (void)setVisible:(BOOL)visible {
    _visible = visible;
    if (visible) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}

#pragma mark - Methods

- (void)addButton:(UIButton *)button {
    NSInteger index = [self.buttons indexOfObject:self.cancelButton];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (index == NSNotFound) {
        [self.buttons addObject:button];
    } else {
        [self.buttons insertObject:button atIndex:index];
    }
}

- (void)presentView:(void (^)(void))completion {
    if (!self.superview) NSLog(@"BDKActionSheet was presented without being in the view hierachy.");
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:self.animationDuration delay:self.animationDelay
                        options:UIViewAnimationCurveEaseOut animations:^{
                            CGRect frame = self.overlay.frame;
                            frame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(frame);
                            NSLog(@"Bumping to new Y origin %.0f.", frame.origin.y);
                            self.overlay.frame = frame;
                            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.dimmingOpacity];
                        } completion:^(BOOL finished) {
                            if (finished) {
                                _visible = YES;
                                if (completion) completion();
                            }
                        }];
}

- (void)dismissView {
    [self dismissView:NO];
}

- (void)dismissView:(BOOL)wasCanceled {
    [UIView animateWithDuration:self.animationDuration delay:self.animationDelay
                        options:UIViewAnimationCurveEaseOut animations:^{
                            CGRect frame = self.overlay.frame;
                            frame.origin.y = CGRectGetHeight(self.frame) + CGRectGetHeight(frame);
                            self.overlay.frame = frame;
                            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                        } completion:^(BOOL finished) {
                            if (finished) {
                                _visible = NO;
                                [self removeFromSuperview];
                                if (self.dismissalBlock) self.dismissalBlock(wasCanceled);
                            }
                        }];
}

#pragma mark - Private methods

- (void)updateHeightForButtons {
    __block CGFloat minY = CGRectGetMaxY(self.label.frame) + 20;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (!button.superview) [self.overlay addSubview:button];
        button.frame = CGRectMake(10, minY, CGRectGetWidth(self.overlay.frame) - 20, 48);
        minY = CGRectGetMaxY(button.frame) + 10;
    }];
    
    CGRect frame = self.overlay.frame;
    frame.size.height = minY + 20;
    self.overlay.frame = frame;
}

#pragma mark - Events

- (void)buttonTapped:(UIButton *)sender {
    if ([sender isEqual:self.cancelButton]) {
        [self dismissView:YES];
    } else if (self.dismissesOnButtonTap) {
        [self dismissView:NO];
    }
}

- (void)backgroundTapped:(UIGestureRecognizer *)sender {
    [self dismissView:YES];
}

#pragma mark - UITapGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.overlay]) {
        if ([touch.view isKindOfClass:[UIButton class]]) {
            return self.dismissesOnButtonTap;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark - UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationFaceDown ||
        orientation == UIDeviceOrientationUnknown || self.currentOrientation == orientation) {
        return;
    }
    if ((UIDeviceOrientationIsPortrait(self.currentOrientation) && UIDeviceOrientationIsPortrait(orientation)) || 
        (UIDeviceOrientationIsLandscape(self.currentOrientation) && UIDeviceOrientationIsLandscape(orientation))) {
        //still saving the current orientation
        self.currentOrientation = orientation;
        return;
    }
    
    // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object:nil];
    self.currentOrientation = orientation;
    [self performSelector:@selector(layoutIfNeeded) withObject:nil afterDelay:0];
}

@end
