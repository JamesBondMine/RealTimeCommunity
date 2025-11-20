//
//  ZImageBrowser.h
//  CIMKit
//
//  Created by cusPro on 2024/9/14.
//

#import <Foundation/Foundation.h>
#import "KNPhotoBrowser.h"//图片视频浏览

typedef void(^ZDoneActionBlock)(NSInteger index, KNPhotoItems * _Nullable photoItems);
typedef void(^ZCancleActionBlock)(void);

@interface ZImageBrowser : NSObject

- (void)imageBrowserWithImageItems:(NSArray<KNPhotoItems *> *_Nonnull)itemsArr
                      currentIndex:(NSInteger)currentIndex
                       selectItems:(NSArray <ZPresentItem *>* _Nullable)selectItems
                        cancleItem:(ZPresentItem * _Nullable)cancleItem
                         doneClick:(ZDoneActionBlock _Nullable)doneClick
                       cancleClick:(ZCancleActionBlock _Nullable)cancleClick;

- (void)dismiss;

@end


