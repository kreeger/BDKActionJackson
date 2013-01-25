//
//  BDKActionSheet.m
//  Created by Benjamin Kreeger on 1/25/13.
//

#import "BDKActionSheet.h"
#import "BDKGradientView.h"

#import <QuartzCore/QuartzCore.h>

@interface BDKActionSheet ()

@property (nonatomic) UIView *overlay;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) CGFloat height;
@property (strong, nonatomic) UIView *shine;
@property (nonatomic) BOOL visible;

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

@implementation BDKActionSheet

#pragma mark - Lifecycle

+ (id)actionSheetInMasterFrame:(CGRect)masterFrame {
    return [[self alloc] initWithFrame:masterFrame];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.overlay];
        [self.overlay addSubview:self.shine];
        [self.overlay addSubview:self.label];
        
        self.buttons = [NSMutableArray arrayWithArray:@[self.cancelButton]];
        
        // Set some defaults
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self addGestureRecognizer:self.tapRecognizer];

        _animationDelay = 0.0f;
        _animationDuration = 0.3f;
        _visible = NO;
    }
    return self;
}

- (void)layoutSubviews {
    CGRect shineFrame = self.frame;
    shineFrame.size.height = floorf(CGRectGetHeight(self.overlay.frame) / 2);
    self.shine.frame = shineFrame;
    self.label.frame = CGRectMake(0, 10, CGRectGetWidth(self.overlay.frame), 16);
}

#pragma mark - Properties

- (UIButton *)cancelButton {
    if (_cancelButton) return _cancelButton;
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton setTintColor:[UIColor redColor]];
    return _cancelButton;
}

- (UILabel *)label {
    if (_label) return _label;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.text = @"Actions";
    _label.font = [UIFont systemFontOfSize:14];
    _label.shadowColor = [UIColor blackColor];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.shadowOffset = CGSizeMake(0, -1);
    _label.textAlignment = NSTextAlignmentCenter;
    return _label;
}

#pragma mark - Private properties

- (UIView *)overlay {
    if (_overlay) return _overlay;
    CGRect frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 100);
    _overlay = [[UIView alloc] initWithFrame:frame];
    _overlay.alpha = 0.8;
    _overlay.backgroundColor = [UIColor blackColor];
    return _overlay;
}

- (UITapGestureRecognizer *)tapRecognizer {
    if (_tapRecognizer) return _tapRecognizer;
    // Default is one tap, one touch.
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    return _tapRecognizer;
}

- (UIView *)shine {
    if (_shine) return _shine;
    CGRect frame = self.overlay.frame;
    frame.size.height = floorf(CGRectGetHeight(frame) / 4);
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
}

- (void)presentView:(void (^)(void))completion {
    [UIView animateWithDuration:self.animationDuration delay:self.animationDelay
                        options:UIViewAnimationCurveEaseOut animations:^{
                            CGRect frame = self.overlay.frame;
                            frame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(frame);
                            self.overlay.frame = frame;
                            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
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

#pragma mark - Events

- (void)cancelButtonTapped:(UIButton *)sender {
    [self dismissView:YES];
}

- (void)backgroundTapped:(UIGestureRecognizer *)sender {
    [self dismissView:YES];
}

@end
