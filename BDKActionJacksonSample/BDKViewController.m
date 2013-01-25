//
//  BDKViewController.m
//  Created by Benjamin Kreeger on 1/25/13.
//

#import "BDKViewController.h"

#import "BDKActionJackson.h"
#import "BDKGradientView.h"

#import <QuartzCore/QuartzCore.h>

@interface BDKViewController ()

@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) BDKActionJackson *sheet;

/** Fired when the share button gets tapped.
 *  @param sender the sender of the event.
 */
- (void)shareButtonTapped:(UIBarButtonItem *)sender;

- (void)buttonTapped:(UIButton *)sender;

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
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_sheet addButton:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Something Else" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_sheet addButton:button];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BDKGradientView *back = [BDKGradientView gradientWithFrame:cancelButton.frame
                                                    startColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0]
                                                      endColor:[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1.0]
                                                     direction:BDKGradientViewDirectionTopToBottom];
    back.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    back.layer.cornerRadius = 5.0f;
    back.clipsToBounds = YES;
    back.userInteractionEnabled = NO;
    [cancelButton addSubview:back];
    
    UILabel *label = [[UILabel alloc] initWithFrame:back.frame];
    label.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, -1);
    label.text = @"CANCEL!!";
    label.userInteractionEnabled = NO;
    [cancelButton addSubview:label];
    
    _sheet.cancelButton = cancelButton;
    
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

- (void)buttonTapped:(UIButton *)sender {
    NSString *message = [NSString stringWithFormat:@"Sender: %@", sender];
    [[[UIAlertView alloc] initWithTitle:@"Tap!" message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}

@end
