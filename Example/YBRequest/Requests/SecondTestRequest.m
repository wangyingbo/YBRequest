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
    return @"";
}


@end
