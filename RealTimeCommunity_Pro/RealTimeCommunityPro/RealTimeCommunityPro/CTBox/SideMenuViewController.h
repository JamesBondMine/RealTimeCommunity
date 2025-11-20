//
//  SideMenuViewController.h
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SideMenuViewController;

@protocol SideMenuViewControllerDelegate <NSObject>

- (void)sideMenuViewControllerDidRequestClose:(SideMenuViewController *)controller;

@end

@interface SideMenuViewController : UIViewController

@property (nonatomic, weak) id<SideMenuViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

