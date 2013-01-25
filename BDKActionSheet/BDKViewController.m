//
//  BDKViewController.m
//  Created by Benjamin Kreeger on 1/25/13.
//

#import "BDKViewController.h"

#import "BDKActionSheet.h"

@interface BDKViewController ()

@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) BDKActionSheet *sheet;

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
    [self.view addSubview:self.label];
}

#pragma mark - Properties

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
    _label.frame = self.view.frame;
    return _label;
}

#pragma mark - Actions

- (void)shareButtonTapped:(UIBarButtonItem *)sender {
    if (!_sheet) {
        CGRect frame = self.view.window.frame;
        self.sheet = [BDKActionSheet actionSheetInMasterFrame:frame];
//        self.sheet.dismissalBlock = ^(BOOL wasCanceled) {
//        };
    }
    
    if (self.sheet.isVisible) {
        [self.sheet dismissView];
    } else {
        [self.view.window addSubview:self.sheet];
        [self.sheet presentView:nil];
    }
}

@end
