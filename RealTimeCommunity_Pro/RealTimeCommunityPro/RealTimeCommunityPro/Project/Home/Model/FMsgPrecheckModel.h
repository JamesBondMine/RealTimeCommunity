//
//  FMsgPrecheckModel.h
//  CIMKit
//
//  Created by cusPro on 2024/3/19.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZForwardDialogModel : ZBaseModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger dialogId;
@property (nonatomic, assign) NSInteger dialogType;
@property (nonatomic, copy) NSString *nickname;

@end



@interface ZForwardExceptionModel : ZBaseModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *codeMsg;
@property (nonatomic, copy) NSString *message;

@end


@interface FMsgPrecheckModel : ZBaseModel

@property (nonatomic, strong) ZForwardDialogModel *dialogInfo;
@property (nonatomic, strong) ZForwardExceptionModel *exceptionInfo;

@end

NS_ASSUME_NONNULL_END
