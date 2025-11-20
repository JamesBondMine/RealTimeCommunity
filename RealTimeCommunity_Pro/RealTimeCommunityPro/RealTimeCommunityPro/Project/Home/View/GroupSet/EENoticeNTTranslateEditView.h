//
//  EENoticeNTTranslateEditView.h
//  CIMKit
//
//  Created by cusPro on 2024/2/21.
//

#import <UIKit/UIKit.h>
#import "ZNoticeTranslateModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EENoticeNTTranslateEditViewDelegate <NSObject>

- (void)editContentFinish:(NSString *)contentStr;

@end

@interface EENoticeNTTranslateEditView : UIView

@property (nonatomic, assign) NSInteger maxContentNum;
@property (nonatomic, copy) NSString *editTitelStr;
@property (nonatomic, copy) NSString *editContentStr;
@property (nonatomic, weak) id<EENoticeNTTranslateEditViewDelegate>delegate;

- (void)editViewShow;

@end

NS_ASSUME_NONNULL_END
