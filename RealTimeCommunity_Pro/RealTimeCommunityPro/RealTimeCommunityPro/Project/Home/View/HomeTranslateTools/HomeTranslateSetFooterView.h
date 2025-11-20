//
//  HomeTranslateSetFooterView.h
//  CIMKit
//
//  Created by cusPro on 2023/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTranslateSetFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign)BOOL isBinded;
@property (nonatomic, copy)NSString *residueChartStr;
@property (nonatomic, copy)NSString *userdChartStr;
@property (nonatomic, copy) void(^footerViewClick)(void);

@end

NS_ASSUME_NONNULL_END
