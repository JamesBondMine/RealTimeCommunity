//
//  HomeContentViewController.h
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeContentViewController;

@protocol HomeContentViewControllerDelegate <NSObject>

- (void)homeContentViewControllerDidTapAvatar:(HomeContentViewController *)controller;

@end

@interface HomeContentViewController : UIViewController

@property (nonatomic, weak) id<HomeContentViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

