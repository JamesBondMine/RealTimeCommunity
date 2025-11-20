//
//  ZGroupSetBasicInfoCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/7.
//

#import "ZBaseCell.h"
#import "BBBaseImageView.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupSetBasicInfoCell : ZBaseCell
@property (nonatomic, strong) UIButton * viewBg;
@property (nonatomic, strong) UILabel *lblTypeName;
@property (nonatomic, strong) BBBaseImageView *ivGroup;
@property (nonatomic, strong) BBBaseImageView *ivQrCode;
@property (nonatomic, strong) UILabel *lblGroupName;

- (void)cellConfigWithTitle:(NSString *)cellTitle model:(LingIMGroup *)model;
@end

NS_ASSUME_NONNULL_END
