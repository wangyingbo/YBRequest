//
//  YBRequestParam.h
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/19.
//  Copyright © 2019年 wyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBRequestParam : NSObject

@property (nonatomic, strong)NSDictionary *param;

+(instancetype)paramWithDictionary:(NSDictionary *)ins;

@end



