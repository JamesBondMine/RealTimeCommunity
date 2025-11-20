//
//  LingIMHttpResponse.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2022/12/19.
//

#import "LingIMHttpResponse.h"

@interface LingIMHttpResponse ()
{
    id _responseData;
}
@end

@implementation LingIMHttpResponse

- (BOOL)isHttpSuccess {
    return _code == LingIMHttpResponseCodeSuccess;
}

- (id)responseData {
    return _responseData;
}

- (void)setResponseData:(id)data {
    _responseData = data;
}

@end
