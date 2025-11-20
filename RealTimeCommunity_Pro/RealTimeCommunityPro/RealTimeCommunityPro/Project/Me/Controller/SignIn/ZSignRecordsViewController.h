//
//  ZSignRecordsViewController.h
//  CIMKit
//
//  Created by Apple on 2023/8/9.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSignRecordsViewController : BBBaseViewController
@property(nonatomic,strong) NSArray * signInRecords;
@property(nonatomic,copy) NSString * totalLoyalty;
@end

NS_ASSUME_NONNULL_END
