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

/** Fired when cancel button is tapped.
 *  @param sender the sender of the event.
 */
- (void)cancelButtonTapped:(UIButton *)sender;

/** Fired when the background of the view is tapped.
 *  @param sender the sender of the event.
 */
- (void)backgroundTapped:(UIGestureRecognizer *)sender;

@end

@implementation BDKActionJackson

@synthesize title = _title, titleFont = _titleFont;

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

        [self addSubview:self.overlay];
        [self.overlay addSubview:self.shine];
        [self.overlay addSubview:self.label];
        
        self.buttons = [NSMutableArray arrayWithArray:@[self.cancelButton]];
        
        // Set some defaults
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    NSLog(@"-layoutSubviews with %i buttons.", self.buttons.count);
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

- (UIButton *)cancelButton {
    if (_cancelButton) return _cancelButton;
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return _cancelButton;
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
    _shine = [[BDKGradientView alloc] initWithFrame:frame
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

#pragma mark - Methods

- (void)addButton:(UIButton *)button {
    NSInteger index = [self.buttons indexOfObject:self.cancelButton];
    [self.buttons insertObject:button atIndex:index];
    [self updateHeightForButtons];
}

- (void)presentView:(void (^)(void))completion {
    if (!self.superview) NSLog(@"BDKActionSheet was presented without being in the view hierachy.");
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
    // Process button layouts.
    [self layoutIfNeeded];
    
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

- (void)cancelButtonTapped:(UIButton *)sender {
    [self dismissView:YES];
}

- (void)backgroundTapped:(UIGestureRecognizer *)sender {
    [self dismissView:YES];
}

#pragma mark - UITapGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !([touch.view isDescendantOfView:self.overlay]);
}

@end
