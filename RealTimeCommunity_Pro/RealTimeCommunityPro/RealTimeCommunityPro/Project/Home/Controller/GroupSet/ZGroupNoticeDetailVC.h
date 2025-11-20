//
//  ZGroupNoticeDetailVC.h
//  CIMKit
//
//  Created by cusPro on 2025/8/11.
//

#import <Foundation/Foundation.h>
#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupNoticeDetailVC : BBBaseViewController

@property (nonatomic,strong) LingIMGroup * groupInfoModel;

@property (nonatomic, strong) ZGroupNoteModel *groupNoticeModel;

@property (nonatomic, copy) void(^deleteNoticyCallback)(void);

@end

NS_ASSUME_NONNULL_END
