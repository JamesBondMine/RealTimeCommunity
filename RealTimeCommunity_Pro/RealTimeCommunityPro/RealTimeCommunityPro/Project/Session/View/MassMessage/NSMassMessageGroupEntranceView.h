//
//  NSMassMessageGroupEntranceView.h
//  CIMKit
//
//  Created by cusPro on 2023/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GroupEntranceViewDelegate <NSObject>

- (void)GroupEntranceAction;

@end

@interface NSMassMessageGroupEntranceView : UIView

@property (nonatomic, weak) id <GroupEntranceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
