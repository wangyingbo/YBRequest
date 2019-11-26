//
//  BaseRequest.h
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/22.
//  Copyright © 2019年 wyb. All rights reserved.
//
//  业务类封装基类请求request

#import "YBRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class BaseRequest;
typedef void(^BaseRequestSuccessBlock)(__kindof BaseRequest *request);
typedef void(^BaseRequestFailureBlock)(__kindof BaseRequest *request);

@interface BaseRequest : YBRequest

@end

NS_ASSUME_NONNULL_END
