//
//  BDKViewController.m
//  Created by Benjamin Kreeger on 1/25/13.
//

#import "BDKViewController.h"

#import "BDKActionJackson.h"

@interface BDKViewController ()

@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) BDKActionJackson *sheet;

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
    self.title = @"BDKActionJackson";
    [self.view addSubview:self.imageView];
}

#pragma mark - Properties

- (UIBarButtonItem *)shareButton {
    if (_shareButton) return _shareButton;
    _shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                 target:self
                                                                 action:@selector(shareButtonTapped:)];
    return _shareButton;
}

- (UIImageView *)imageView {
    if (_imageView) return _imageView;
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    _imageView.center = self.view.center;
    return _imageView;
}

- (BDKActionJackson *)sheet {
    if (_sheet) return _sheet;
    _sheet = [BDKActionJackson actionSheetInMasterFrame:self.view.window.frame];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Something" forState:UIControlStateNormal];
    [_sheet addButton:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Something Else" forState:UIControlStateNormal];
    [_sheet addButton:button];
    return _sheet;
}

#pragma mark - Actions

- (void)shareButtonTapped:(UIBarButtonItem *)sender {
    (void)self.sheet;
    
    if (self.sheet.isVisible) {
        [self.sheet dismissView];
    } else {
        [self.view.window addSubview:self.sheet];
        [self.sheet presentView:nil];
    }
}

@end
