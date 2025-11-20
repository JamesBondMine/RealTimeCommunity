//
//  ZHistoryChoiceUseredTopView.h
//  CIMKit
//
//  Created by cusPro on 2024/8/12.
//

#import <UIKit/UIKit.h>
#import "BBBaseCollectionCell.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHistoryChoiceUseredTopView : UIView

@property (nonatomic, strong) NSMutableArray *choicedTopUserList;

@end


@interface ZHistoryChoiceUseredItem : BBBaseCollectionCell

@property (nonatomic, strong) UIImageView *ivHeader;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) ZBaseUserModel *model;

@end

NS_ASSUME_NONNULL_END
