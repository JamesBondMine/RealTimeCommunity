//
//  HomeMassMessageSelectUserVC.h
//  CIMKit
//
//  Created by cusPro on 2023/4/19.
//

#import "BBBaseViewController.h"
#import "ZBaseUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ZMassMessageSelectUserDelegate <NSObject>
- (void)massMessageSelectedUserList:(NSArray<ZBaseUserModel *> *)selectedUserList;
@end

@interface HomeMassMessageSelectUserVC : BBBaseViewController
@property (nonatomic, weak) id <ZMassMessageSelectUserDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<ZBaseUserModel *> *selectedList;//选中的
@end

NS_ASSUME_NONNULL_END
