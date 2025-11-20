//
//  ZMineUserInfoCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/12.
//

#import "ZBaseCell.h"

@protocol ZMineUserInfoCellDelegate <NSObject>

@optional
//点击
- (void)headerImageClickAction:(UIImage *_Nullable)image url:(NSString *_Nullable)url;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZMineUserInfoCell : ZBaseCell

@property (nonatomic, assign)NSInteger cellIndex;
@property (nonatomic, strong)UIImage *clipImage;
@property (nonatomic, weak) id <ZMineUserInfoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
