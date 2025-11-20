//
//  HomeChatMultiSelectedView.h
//  CIMKit
//
//  Created by cusPro on 2023/4/12.
//

#import <UIKit/UIKit.h>
#import "BBBaseImageView.h"
#import "BBBaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeChatMultiSelectedView : UIView

@property (nonatomic, strong) NSMutableArray *selectedTopList;

@end


@interface ZMultiSelectedHeaderItem : BBBaseCollectionCell

@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UILabel *ivRoleName;//用户角色名称
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
