//
//  NSMassMessageGroupSelectedTopView.h
//  CIMKit
//
//  Created by cusPro on 2023/9/4.
//

#import <UIKit/UIKit.h>
#import "BBBaseImageView.h"
#import "BBBaseCollectionCell.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMassMessageGroupSelectedTopView : UIView

@property (nonatomic, strong) NSMutableArray *selectedTopUserList;

@end

@interface ZMassMessageGroupSelectItem : BBBaseCollectionCell

@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UILabel *ivRoleName;//用户角色名称
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) ZBaseUserModel *model;

@end

NS_ASSUME_NONNULL_END
