//
//  ZMyCollectionItemModel.m
//  CIMKit
//
//  Created by cusPro on 2023/4/19.
//

#import "ZMyCollectionItemModel.h"

@implementation ZMyCollectionBodyModel

@end


@implementation ZMyCollectionItemModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"body"]) {
        if (oldValue) {
            ZMyCollectionBodyModel *body = [ZMyCollectionBodyModel mj_objectWithKeyValues:oldValue];
            return body;
        }
    }
    return oldValue;
}

@end
