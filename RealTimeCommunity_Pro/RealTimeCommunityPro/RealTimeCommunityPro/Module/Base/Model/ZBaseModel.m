//
//  ZBaseModel.m
//  CIMKit
//
//  Created by cusPro on 2022/9/15.
//

#import "ZBaseModel.h"

@implementation ZBaseModel

MJCodingImplementation

#pragma mark - 非空处理
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    //|| [oldValue isKindOfClass:[NSNull class]] || oldValue == nil
    if (oldValue == [NSNull null]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            return @[];
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            return @{};
        }else{
            return @"";
        }
    }
    
    return oldValue;
    
}

@end
