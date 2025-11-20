//
//  ZSsoEntrancesView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSsoEntrancesView : UIView

@property (nonatomic, copy)void(^changeSSOClick)(void);

- (void)configSsoInfo:(ZSsoInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
