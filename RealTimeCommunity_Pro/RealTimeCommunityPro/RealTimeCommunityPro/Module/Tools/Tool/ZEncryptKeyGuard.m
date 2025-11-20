//
//  ZEncryptKeyGuard.m
//  RealTimeCommunityPro
//

#import "ZEncryptKeyGuard.h"

@interface ZEncryptKeyGuard ()
@property (nonatomic, copy, nullable) NSString *key;
@property (nonatomic, assign) BOOL consumed;
@end

@implementation ZEncryptKeyGuard

+ (instancetype)guardWithKey:(NSString *)key {
    ZEncryptKeyGuard *g = [ZEncryptKeyGuard new];
    g.key = key.length > 0 ? [key copy] : nil;
    g.consumed = NO;
    return g;
}

- (nullable NSString *)consume {
    @synchronized (self) {
        if (self.consumed || self.key.length == 0) {
            return nil;
        }
        self.consumed = YES;
        NSString *k = self.key;
        self.key = nil; // redact immediately
        return k;
    }
}

@end


