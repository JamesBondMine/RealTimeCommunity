//
//  LingFloatMiniAppModel+WCTTableCoding.h
//  NoaChatSDKCore
//
//  Created by 郑开 on 2024/5/11.
//

#import "LingFloatMiniAppModel.h"
#import <WCDBObjc/WCDBObjc.h>



@interface LingFloatMiniAppModel (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(floladId);
WCDB_PROPERTY(url);
WCDB_PROPERTY(headerUrl);
WCDB_PROPERTY(title);

@end


