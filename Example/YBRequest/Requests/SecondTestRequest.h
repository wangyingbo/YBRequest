//
//  SecondTestRequest.h
//  TFRequestDemo
//
//  Created by fengbang on 2019/11/18.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondTestRequest : BaseRequest

+ (instancetype)startRequestWithName:(NSString *)name ID:(NSString *)ID success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
