//
//  ZAppUpdateTools.m
//  CIMKit
//
//  Created by cusPro on 2023/4/4.
//

#import "ZAppUpdateTools.h"
#import "UpgradeVersionView.h"
#import "ZToolManager.h"

@implementation ZAppUpdateTools

+ (void)getAppUpdateInfoWithShowDefaultTips:(BOOL)isShow completion:(void (^)(BOOL))completion {
    if (ZHostTool.appSysSetModel.verifyAppVersion == NO) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    //platform    平台(0:iOS,1:Android,2:H5,3:Web,4:PC)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:ZLanguageTOOL.currentLanguage.languageAbbr forKey:@"language"];
    [params setObjectSafe:@0 forKey:@"platform"];
    [params setObjectSafe:[ZTOOL getCurretnVersion] forKey:@"version"];
    [IMSDKManager imSdkGetAppUpdateInfoWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            if([data isKindOfClass:[NSDictionary class]]){
                NSDictionary *dataDict = (NSDictionary *)data;
                //接口返回的版本号
                NSString *newVersionStr = (NSString *)[dataDict objectForKey:@"versionNumber"];
                //当前版本号
                NSString *currentVersionStr = [ZTOOL getCurretnVersion];
                long reminderType = [[dataDict objectForKey:@"reminderType"] longValue];
                
                // 读取是否已经忽略了
                BOOL isIgnore = [[MMKV defaultMMKV] getBoolForKey:[NSString stringWithFormat:@"ignore_%@", newVersionStr]];
                
                //比较是否相同，来决定是否弹窗
                if (![currentVersionStr isEqualToString:newVersionStr]) {
                    if (!isShow && isIgnore) {
                        // 不是从关于我们页面跳转、并且已经忽略，则不弹窗
                        if (completion) {
                            completion(NO);
                        }
                        return;
                    }
                    //是否强制更新
                    BOOL isCompelUpdate = [[dataDict objectForKey:@"forceUpdate"] boolValue];
                    //下载地址
                    NSString *storeUrl = @"https://apps.apple.com/cn/app/%E9%A3%8E%E9%93%83%E9%B8%9F/id6755617657";
                    //更新内容
                    NSString *updateDes = (NSString *)[dataDict objectForKey:@"updateDescription"];
                    //更新弹窗
                    if (isCompelUpdate || reminderType == 0) {
                        UpgradeVersionView *updateAlertView = [[UpgradeVersionView alloc] init];
                        updateAlertView.isCompelUpdate = isCompelUpdate;
                        updateAlertView.storeUrl = storeUrl;
                        updateAlertView.versionNumStr = newVersionStr;
                        updateAlertView.updateDes = [NSString isNil:updateDes] == NO ? updateDes : @"";
                        [updateAlertView updateVersionViewShow];
                        if (completion) {
                            completion(YES);
                        }
                    } else {
                        if (completion) {
                            completion(NO);
                        }
                    }
                } else {
                    if (isShow) {
                        [HUD showMessage:MultilingualTranslation(@"已是最新版本")];
                    }
                    if (completion) {
                        completion(NO);
                    }
                }
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        if (completion) {
            completion(NO);
        }
        return;
    }];
}

@end
