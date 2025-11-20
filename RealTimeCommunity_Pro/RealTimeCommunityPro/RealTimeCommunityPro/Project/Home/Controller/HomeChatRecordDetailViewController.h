//
//  HomeChatRecordDetailViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/4/25.
//

#import "BBBaseViewController.h"
#import "ZMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeChatRecordDetailViewController : BBBaseViewController

@property (nonatomic, assign) NSInteger levelNum;
@property (nonatomic, strong) ZMessageModel *model;

@end

NS_ASSUME_NONNULL_END
