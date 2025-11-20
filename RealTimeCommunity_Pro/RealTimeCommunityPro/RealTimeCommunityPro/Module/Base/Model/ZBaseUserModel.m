//
//  ZBaseUserModel.m
//  CIMKit
//
//  Created by cusPro on 2024/1/11.
//

#import "ZBaseUserModel.h"

@implementation ZBaseUserModel

- (BOOL)isEqual:(ZBaseUserModel *)object{
    if ([object isKindOfClass:self.class]) {
        return [self.userId isEqual:object.userId];
    }else{
        return [super isEqual:object];
    }
}

@end
