//
//  ZAuthInputTools.h
//  CIMKit
//
//  Created by cusPro on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAuthInputTools : NSObject

//校验手机号
+ (BOOL)loginCheckPhoneWithText:(NSString *)text;
+ (BOOL)registerCheckPhoneWithText:(NSString *)text;

//校验邮箱
+ (BOOL)loginCheckEmailWithText:(NSString *)text;
+ (BOOL)registerCheckEmailWithText:(NSString *)text;

//校验账号
+ (BOOL)loginCheckAccountWithText:(NSString *)text;
//校验账号 输入完成失去焦点时校验是否为6-16位
+ (BOOL)registerCheckInputAccountEndWithTextLength:(NSString *)text;
//校验账号 输入完成失去焦点时校验：账号前两位必须为英文，只支持英文或数字
+ (BOOL)registerCheckInputAccountEndWithTextFormat:(NSString *)text;


//校验验证码
+ (BOOL)checkVerCodeWithText:(NSString *)text;

//校验密码
+ (BOOL)checkPasswordWithText:(NSString *)text;

#pragma mark - 校验密码 输入中/粘贴
+ (BOOL)checkCreatPasswordInputWithText:(NSString *)text;
#pragma mark - 校验密码 输入完成失去焦点时校验是否为6-16位
+ (BOOL)checkCreatPasswordEndWithTextLength:(NSString *)text;
#pragma mark - 校验密码 输入完成失去焦点时校验是否包含字母和数字(英文字符) 、 校验密码 输入中/粘贴
+ (BOOL)checkCreatPasswordEndWithTextFormat:(NSString *)text;

//校验邀请码
+ (BOOL)checkInviteCodeWithText:(NSString *)text;

//校验昵称
+ (BOOL)checkNickNameWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
