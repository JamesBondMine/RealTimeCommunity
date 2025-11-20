//
//  ZNetRacingModel.m
//  CIMKit
//
//  Created by cusPro on 2023/5/16.
//

#import "ZNetRacingModel.h"

@implementation ZNetRacingItemModel
@end

@implementation ZNetRacingHttpModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
                @"dnsList":[ZNetRacingItemModel class],
                @"ipList":[ZNetRacingItemModel class]
            };
}

@end

@implementation ZNetRacingTcpModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
                @"dnsList":[ZNetRacingItemModel class],
                @"ipList":[ZNetRacingItemModel class]
            };
}

@end

@implementation ZNetRacingEndpointsModel
@end

@implementation ZNetRacingModel

- (NSArray *)httpArr {
    if (_httpArr == nil) {
        NSMutableArray *allHttpArr = [NSMutableArray array];
        [allHttpArr addObjectsFromArray:self.endpoints.http.ipList];
        [allHttpArr addObjectsFromArray:self.endpoints.http.dnsList];
        
        NSMutableDictionary<NSNumber *, NSMutableArray<ZNetRacingItemModel *> *> *allItemDict = [NSMutableDictionary dictionary];
        // 遍历原始数组，将模型按照sort值分组
        for (ZNetRacingItemModel *tempItem in allHttpArr) {
            NSNumber *sortValue = @(tempItem.sort);
            NSMutableArray<ZNetRacingItemModel *> *array = allItemDict[sortValue];
            if (!array) {
                array = [NSMutableArray array];
                allItemDict[sortValue] = array;
            }
            [array addObjectIfNotNil:tempItem];
        }
        
        NSArray<NSNumber *> *sortedKeys = [[allItemDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray<NSArray<ZNetRacingItemModel *> *> *sortedArrays = [NSMutableArray array];
        for (NSNumber *key in sortedKeys) {
            NSArray<ZNetRacingItemModel *> *array = allItemDict[key];
            [sortedArrays addObjectIfNotNil:array];
        }
        
        _httpArr = [sortedArrays copy];
    }
    return _httpArr;
}

- (NSArray *)tcpArr {
    if (_tcpArr == nil) {
        NSMutableArray *allTcpArr = [NSMutableArray array];
        [allTcpArr addObjectsFromArray:self.endpoints.tcp.ipList];
        [allTcpArr addObjectsFromArray:self.endpoints.tcp.dnsList];
        
        NSMutableDictionary<NSNumber *, NSMutableArray<ZNetRacingItemModel *> *> *allItemDict = [NSMutableDictionary dictionary];
        // 遍历原始数组，将模型按照sort值分组
        for (ZNetRacingItemModel *tempItem in allTcpArr) {
            NSNumber *sortValue = @(tempItem.sort);
            NSMutableArray<ZNetRacingItemModel *> *array = allItemDict[sortValue];
            if (!array) {
                array = [NSMutableArray array];
                allItemDict[sortValue] = array;
            }
            [array addObjectIfNotNil:tempItem];
        }
        
        NSArray<NSNumber *> *sortedKeys = [[allItemDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray<NSArray<ZNetRacingItemModel *> *> *sortedArrays = [NSMutableArray array];
        for (NSNumber *key in sortedKeys) {
            NSArray<ZNetRacingItemModel *> *array = allItemDict[key];
            [sortedArrays addObjectIfNotNil:array];
        }
        
        _tcpArr = [sortedArrays copy];
      
    }
    return _tcpArr;
}

- (NSArray *)httpNodeArr {
    if (_httpNodeArr == nil) {
        NSMutableArray *allHttpNodeArr = [NSMutableArray array];
        for (ZNetRacingItemModel *itemModel in self.endpoints.http.dnsList) {
            [allHttpNodeArr addObject:itemModel.ip];
        }
        for (ZNetRacingItemModel *itemModel in self.endpoints.http.ipList) {
            [allHttpNodeArr addObject:itemModel.ip];

        }
        _httpNodeArr = [allHttpNodeArr copy];
    }
    return _httpNodeArr;
}

@end



@implementation ZHttpDNSLocalModel
@end

