//
//  BDKActionSheet.h
//  Created by Benjamin Kreeger on 1/25/13.
//

#import <UIKit/UIKit.h>

/** A custom implementation of a UIActionSheet.
 */
@interface BDKActionJackson : UIView

@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *cancelButton;

@property (copy, nonatomic) void (^dismissalBlock)(BOOL cancelTapped);

@property (readonly) BOOL isVisible;

//
// UI / animation customization properties.
//

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIFont *titleFont;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) CGFloat dimmingOpacity;
@property (nonatomic) CGFloat actionPaneOpacity;
@property (nonatomic) BOOL dismissesOnButtonTap;

#pragma mark - Lifecycle

/** Returns a default instance of the action sheet.
 *  @param masterFrame the frame of the containing view for the action sheet.
 *  @return a default instance of the action sheet.
 */
+ (id)actionSheetInMasterFrame:(CGRect)masterFrame;

#pragma mark - Methods

/** Adds a button to the buttons array, before the cancel button (which is always present).
 *  @param button an instance of a UIButton.
 */
- (void)addButton:(UIButton *)button;

/** Presents the view, with an optional completion block to be fired once finished.
 *  @param completion an optional block to be called when the animation completes.
 */
- (void)presentView:(void (^)(void))completion;

/** Dismisses the view.
 */
- (void)dismissView;

@end
