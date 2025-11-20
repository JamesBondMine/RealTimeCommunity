//
//  NSMassMessageSelectModel.h
//  CIMKit
//
//  Created by cusPro on 2024/1/12.
//

#import "ZBaseModel.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMassMessageSelectModel : ZBaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<ZBaseUserModel *> *list;
@property (nonatomic, assign) bool isOpen;
@property (nonatomic, assign) bool isAllSelect;
@end

NS_ASSUME_NONNULL_END
