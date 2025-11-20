//
//  ZNoticeTranslateCell.h
//  CIMKit
//
//  Created by cusPro on 2024/2/19.
//

#import "ZBaseCell.h"
#import "ZNoticeTranslateModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZNoticeTranslateCellDelegate <NSObject>

- (void)noticeTranslateSuccess:(ZNoticeTranslateModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)noticeTranslateFail:(ZNoticeTranslateModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)noticeTranslateEdit:(ZNoticeTranslateModel *)model indexPath:(NSIndexPath *)indexPath;

@end

@interface ZNoticeTranslateCell : ZBaseCell

@property (nonatomic, strong) ZNoticeTranslateModel *model;
@property (nonatomic, weak) id<ZNoticeTranslateCellDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
