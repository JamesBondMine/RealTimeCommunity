//
//  ZEmojiPackageDetailViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZEmojiPackageDetailViewController : BBBaseViewController

@property (nonatomic, assign) NSInteger supIndex;
@property (nonatomic, copy) NSString *stickersId;
@property (nonatomic, copy) NSString *stickersSetId;//表情包Id
@property (nonatomic, copy) void(^packageAddClick)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
