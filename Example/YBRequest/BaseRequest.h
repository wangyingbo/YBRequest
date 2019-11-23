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


/// 一些自定义的适配自己项目的代理方法，可在此添加
@protocol BaseRequestDefaultDelegate <NSObject>
@optional;

/// 配置每个接口的默认参数，可与属性参数同时同在
- (nullable NSDictionary *)configurePerDefaultParams;

/**
 属性参数键映射，如参数为id，则属性名为可写为ID
 此方法里实现映射：@{ @"ID":@"id" } 
 */
- (nullable NSDictionary<NSString *,NSString *> *)propertyKeyMapper;

@end




@interface BaseRequest : YBRequest<BaseRequestDefaultDelegate>

/**
 1、调用类方法为取消当前类的所有request请求；
 2、也可调用同名实例方法，取消当前request实例的请求;
 */
+ (void)cancelRequest;

@end

NS_ASSUME_NONNULL_END
