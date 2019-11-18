//
//  YBRequestParam.m
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/19.
//  Copyright © 2019年 wyb. All rights reserved.
//

#import "YBRequestParam.h"

@implementation YBRequestParam

+(instancetype)paramWithDictionary:(NSDictionary *)ins{
    YBRequestParam *param = [[YBRequestParam alloc]init];
    param.param = ins;
    return param;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _param = [aDecoder decodeObjectForKey:@"_param"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if (_param)[aCoder encodeObject:_param forKey:@"_param"];
}

@end



