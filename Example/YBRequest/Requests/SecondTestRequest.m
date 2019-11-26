//
//  SecondTestRequest.m
//  TFRequestDemo
//
//  Created by fengbang on 2019/11/18.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "SecondTestRequest.h"

@interface SecondTestRequest ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@end

@implementation SecondTestRequest

+ (instancetype)startRequestWithName:(NSString *)name ID:(NSString *)ID success:(RequestFinishBlock)success failure:(RequestFailedBlock)failure {
    SecondTestRequest *request = [[[self class] alloc] init];
    request.name = name;
    request.ID = ID;
    [request requestWithFinish:success requestFailed:failure];
    return request;
}

- (NSString *)configureUrl{
    return @"s";
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

/// 是否禁止打印log
- (BOOL)banRequestLog {
    return NO;
}


@end
