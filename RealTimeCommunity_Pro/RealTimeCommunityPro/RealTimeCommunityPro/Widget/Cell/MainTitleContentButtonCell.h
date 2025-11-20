//
//  MainTitleContentButtonCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/14.
//

// 通用的 标题 内容 按钮 - Cell

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MainTitleContentButtonCellDelegate <NSObject>
- (void)cellButtonAction:(id)action;
@end

@interface MainTitleContentButtonCell : ZBaseCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIButton *btnAction;

@property (nonatomic, weak) id <MainTitleContentButtonCellDelegate> delegate;
@property (nonatomic, strong) id cellData;
@end

NS_ASSUME_NONNULL_END
