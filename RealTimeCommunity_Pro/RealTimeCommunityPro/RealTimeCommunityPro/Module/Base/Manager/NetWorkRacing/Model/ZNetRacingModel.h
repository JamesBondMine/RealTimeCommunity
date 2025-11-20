//
//  ZNetRacingModel.h
//  CIMKit
//
//  Created by cusPro on 2023/5/16.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZNetRacingItemModel : ZBaseModel

@property (nonatomic, copy)NSString *ip;
@property (nonatomic, assign)NSInteger sort;

@end

//Http
@interface ZNetRacingHttpModel : ZBaseModel

@property (nonatomic, strong)NSArray<ZNetRacingItemModel *> *dnsList;
@property (nonatomic, strong)NSArray<ZNetRacingItemModel *> *ipList;

@end

//Tcp
@interface ZNetRacingTcpModel : ZBaseModel

@property (nonatomic, strong)NSArray<ZNetRacingItemModel *> *dnsList;
@property (nonatomic, strong)NSArray<ZNetRacingItemModel *> *ipList;

@end

//Endpoints
@interface ZNetRacingEndpointsModel : ZBaseModel

@property (nonatomic, strong)ZNetRacingHttpModel *http;
@property (nonatomic, strong)ZNetRacingTcpModel *tcp;

@end

//oss返回的数据model
@interface ZNetRacingModel : ZBaseModel

@property (nonatomic, copy)NSString *version;   //版本
@property (nonatomic, copy)NSString *appKey;    //企业号id
@property (nonatomic, copy)NSString *clientCer;
@property (nonatomic, copy)NSString *clientP12;
@property (nonatomic, copy)NSString *clientKey;
@property (nonatomic, strong)ZNetRacingEndpointsModel *endpoints;
@property (nonatomic, assign)BOOL is_merge_version;
@property (nonatomic, assign)NSInteger ping_interval_second;
@property (nonatomic, strong)NSArray *oldHttpNodeArr;
@property (nonatomic, strong)NSArray *httpNodeArr;

//组装后的数据
@property (nonatomic, strong)NSArray *httpArr;
@property (nonatomic, strong)NSArray *tcpArr;

//获取数据存储到本地的时间戳
@property (nonatomic, strong)NSData *cerData;
@property (nonatomic, strong)NSData *p12Data;

@end



//httpDNS解析本地缓存数据model
@interface ZHttpDNSLocalModel : ZBaseModel

@property (nonatomic, strong)NSString *httpDoamin;
@property (nonatomic, strong)NSString *ossBucket;
@property (nonatomic, assign)ZDNSLocalModelType localModelType;

@end

NS_ASSUME_NONNULL_END
