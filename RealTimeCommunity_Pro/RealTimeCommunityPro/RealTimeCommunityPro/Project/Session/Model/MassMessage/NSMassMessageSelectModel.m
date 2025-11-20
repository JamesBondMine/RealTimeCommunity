//
//  NSMassMessageSelectModel.m
//  CIMKit
//
//  Created by cusPro on 2024/1/12.
//

#import "NSMassMessageSelectModel.h"

@implementation NSMassMessageSelectModel

-(void)setIsAllSelect:(bool)isAllSelect{
    if(self.list.count == 0){
        _isAllSelect = NO;
    }else{
        _isAllSelect = isAllSelect;
    }
}

@end
