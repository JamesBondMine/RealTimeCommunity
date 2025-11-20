//
//  UILabel+Addition.h
//  ZIMChatService
//
//  Created by customDev on 2025/05/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Addition)

//修改指定范围内容字体和颜色
- (void)changeTextRange:(NSRange)range font:(UIFont * _Nullable)font color:(UIColor * _Nullable)color;

//改变行间距
- (void)changeLineSpace:(float)space;

//改变字间距
- (void)changeWordSpace:(float)space;

//改变行间距和字间距
- (void)changeLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end

NS_ASSUME_NONNULL_END
