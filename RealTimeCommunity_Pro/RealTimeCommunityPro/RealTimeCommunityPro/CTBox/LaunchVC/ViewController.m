//
//  ViewController.m
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import "ViewController.h"
#import "SideMenuViewController.h"
#import "HomeContentViewController.h"

@interface ViewController () <SideMenuViewControllerDelegate, HomeContentViewControllerDelegate>

@property (nonatomic, strong) HomeContentViewController *homeContentViewController;
@property (nonatomic, strong) SideMenuViewController *sideMenuViewController;
@property (nonatomic, assign) BOOL isMenuOpen;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.95 blue:0.88 alpha:1.0];
    self.isMenuOpen = NO;
    
    [self setupHomeContentViewController];
    [self setupSideMenuViewController];
}

- (void)setupHomeContentViewController {
    self.homeContentViewController = [[HomeContentViewController alloc] init];
    self.homeContentViewController.delegate = self;
    
    [self addChildViewController:self.homeContentViewController];
    self.homeContentViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.homeContentViewController.view];
    [self.homeContentViewController didMoveToParentViewController:self];
}

- (void)setupSideMenuViewController {
    self.sideMenuViewController = [[SideMenuViewController alloc] init];
    self.sideMenuViewController.delegate = self;
    
    [self addChildViewController:self.sideMenuViewController];
    
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    self.sideMenuViewController.view.frame = CGRectMake(-screenWidth, 0, screenWidth, screenHeight);
    
    [self.view addSubview:self.sideMenuViewController.view];
    [self.sideMenuViewController didMoveToParentViewController:self];
}

- (void)openMenu {
    self.isMenuOpen = YES;
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.sideMenuViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    } completion:nil];
}

- (void)closeMenu {
    self.isMenuOpen = NO;
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sideMenuViewController.view.frame = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    } completion:nil];
}

#pragma mark - HomeContentViewControllerDelegate

- (void)homeContentViewControllerDidTapAvatar:(HomeContentViewController *)controller {
    [self openMenu];
}

#pragma mark - SideMenuViewControllerDelegate

- (void)sideMenuViewControllerDidRequestClose:(SideMenuViewController *)controller {
    [self closeMenu];
}


@end
