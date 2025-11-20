//
//  ZBubbleSendView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/28.
//

#define k_width self.bounds.size.width
#define k_height self.bounds.size.height
#define k_radius 6  // 商务风格：更小的圆角，显得更专业方正
#define k_border_width 0.5  // 边框宽度

#import "ZBubbleSendView.h"

@implementation ZBubbleSendView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加轻微阴影，增加层次感
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
    
    // 创建圆角矩形路径
    UIBezierPath *bubblePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(k_border_width/2, k_border_width/2, k_width - k_border_width, k_height - k_border_width)
                                                           cornerRadius:k_radius];
    
    // 填充气泡背景色
    if (_bgFillColor) {
        [_bgFillColor setFill];
    } else {
        [COLOR_81D8CF setFill];
    }
    [bubblePath fill];
    
    // 绘制边框，增加商务感
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL); // 清除阴影，避免影响边框
    [[UIColor colorWithWhite:0 alpha:0.06] setStroke]; // 淡灰色边框
    bubblePath.lineWidth = k_border_width;
    [bubblePath stroke];
}

@end
