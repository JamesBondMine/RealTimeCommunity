//
//  EmojiUpdatePackageDetailHeaderView.h
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EmojiUpdatePackageDetailHeaderViewDelegate <NSObject>

- (void)addStrickersPackageAction;

@end

@interface EmojiUpdatePackageDetailHeaderView : UICollectionReusableView

@property (nonatomic, strong) LingIMStickersPackageModel *model;
@property (nonatomic, weak) id <EmojiUpdatePackageDetailHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
