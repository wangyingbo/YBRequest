//
//  SecondTestRequest.m
//  TFRequestDemo
//
//  Created by fengbang on 2019/11/18.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "SecondTestRequest.h"

@interface SecondTestRequest ()

/**必传参数*/
@property (nonatomic, copy) NSString<Required> *name;
/**一般参数*/
@property (nonatomic, copy) NSString *ID;
/**可选参数*/
@property (nonatomic, copy) NSString<Optional> *age;
/**被忽略的参数*/
@property (nonatomic, copy) NSString<Ignored> *nickName;

@end

@implementation SecondTestRequest

+ (instancetype)startRequestWithName:(NSString *)name ID:(NSString *)ID success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure {
    SecondTestRequest *request = [[[self class] alloc] init];
    request.name = (NSString<Required> *)name;
    request.ID = ID;
    [request requestWithFinish:success requestFailed:failure];
    return request;
}

- (NSString *)configureUrl {
    return @"s";
}

/// 配置每一个接口的不同请求头
- (NSDictionary *)configurePerRequestHeader {
    return @{
        @"message":@"130****2915",
        @"email":@"wangyingbo0528@gmail.com",
    };
}

/// 属性参数名做映射转换
- (NSDictionary<NSString *,NSString *> *)propertyKeyMapper {
    return @{
        @"ID":@"id"
    };
}

/// 配置每个接口的默认参数
- (NSDictionary *)configurePerDefaultParams {
    return @{
        @"type":@"bankList",
        @"pageSize":@"20",
    };
}

/// 需要被忽略的参数名
- (NSArray<NSString *> *)ignorePropertyKeys {
    return @[@"type"];
}

/// 是否禁止打印log
- (BOOL)banRequestLog {
    return NO;
}


@end
