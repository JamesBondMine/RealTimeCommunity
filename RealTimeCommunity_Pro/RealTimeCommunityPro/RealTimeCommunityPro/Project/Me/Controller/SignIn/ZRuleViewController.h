//
//  ZRuleViewController.h
//  CIMKit
//
//  Created by Apple on 2023/8/9.
//

#import "BBBaseViewController.h"
#import "ZSignInRuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZRuleViewController : BBBaseViewController

@property (nonatomic, assign) CGFloat ruleContentAttHeight;
@property (nonatomic, copy) NSMutableAttributedString *ruleContentAtt;
@property(nonatomic,strong) ZSignInRuleModel* signRuleModel;

@end

NS_ASSUME_NONNULL_END
