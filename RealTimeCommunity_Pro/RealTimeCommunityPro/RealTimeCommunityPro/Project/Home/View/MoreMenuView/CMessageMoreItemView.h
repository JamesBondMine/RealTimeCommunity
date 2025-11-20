//
//  CMessageMoreItemView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/29.
//

// 27 + 12 + 行 * 56
 
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CMessageMoreItemViewDelegate <NSObject>

- (void)menuItemViewSelectedAction:(MessageMenuItemActionType)actionType;

@end

@interface CMessageMoreItemView : UIView

@property (nonatomic, strong) NSArray *menuArr;
@property (nonatomic, weak) id <CMessageMoreItemViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
