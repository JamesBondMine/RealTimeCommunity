//
//  HomeSessionVC.h
//  CIMKit
//
//  Created by Apple on 2022/9/2.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeSessionVC : BBBaseViewController

- (void)sessionListAllRead:(NSString *)lastServerMsgId;

@end

NS_ASSUME_NONNULL_END
