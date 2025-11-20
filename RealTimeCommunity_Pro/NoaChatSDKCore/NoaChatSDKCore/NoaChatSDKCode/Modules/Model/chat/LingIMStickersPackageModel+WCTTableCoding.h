//
//  LingIMStickersPackageModel+WCTTableCoding.h
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/10/30.
//

#import "LingIMStickersPackageModel.h"
#import <WCDBObjc/WCDBObjc.h>

@interface LingIMStickersPackageModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(coverFile)
WCDB_PROPERTY(stickersDes)
WCDB_PROPERTY(packageId)
WCDB_PROPERTY(isDownLoad)
WCDB_PROPERTY(isDeleted)
WCDB_PROPERTY(name)
WCDB_PROPERTY(status)
WCDB_PROPERTY(stickersCount)
//WCDB_PROPERTY(stickersList)
WCDB_PROPERTY(stickersListJsonStr)
WCDB_PROPERTY(thumbUrl)
WCDB_PROPERTY(updateTime)
WCDB_PROPERTY(updateUserName)
WCDB_PROPERTY(useCount)

@end
