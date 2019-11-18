//
//  BaseRequest.m
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/22.
//  Copyright © 2019年 wyb. All rights reserved.
//

#import "BaseRequest.h"
#import <objc/runtime.h>

@implementation BaseRequest

#pragma mark - override
-(void)dealloc{
    NSLog(@"<request:%@ - %p> dealloc",[self class],self);
}

#pragma mark ----------------------  配置请求参数   ----------------------

/// 配置基类url
-(NSString *)configureBaseUrl{
    return @"https://www.baidu.com";
    //return @"http://180.76.121.105:8296";
}

/// 配置是否禁止log，子类可重写
- (BOOL)banRequestLog {
    return NO;
}

-(NSDictionary *)configureHeader{
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"1" forKey:@"appBundleVersion"];
    [header setObject:@"1.0" forKey:@"appVersion"];
    [header setObject:@"US" forKey:@"countryCode"];
    [header setObject:@"en" forKey:@"lang"];
    [header setObject:@"375x812" forKey:@"screenSize"];
    [header setObject:@"ios" forKey:@"source"];
    [header setObject:@"12.1" forKey:@"systemVersion"];
    return header;
}

/// 配置每个接口的属性参数
- (NSDictionary *)configurePerParams {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    // Add properties of Self
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count<1) { return nil; }
    for (NSInteger i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self respondsToSelector:@selector(valueForKey:)]) {
            NSString *value = [self valueForKey:key];
            if (value) {
                [mutDic setObject:value forKey:key];
            }
        }
    }
    free(properties);
    return mutDic.copy;
}

/// 配置一些默认参数
-(NSDictionary *)configureDefalutParams{
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"xxxxxx" forKey:@"token"];
    return header;
}

/// 配置传参类型：是formData还是json
-(RequestType)configureRequestType{
    return RequestTypeForm;
}

/// 配置请求方式，post、get等
-(RequestMethod)configureRequestMethod{
    return RequestMethodPost;
}

//配置证书
//-(AFSecurityPolicy *)configureSecurityPolicy{
//    //导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"你的证书文件" ofType:@"cer"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    //AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    /**
//     *  validatesDomainName 是否需要验证域名，默认为YES；
//     *  假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//     *  置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//     *  如置为NO，建议自己添加对应域名的校验逻辑。
//     *
//     */
//    securityPolicy.validatesDomainName = NO;
//    securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
//    return securityPolicy;
//}


#pragma mark ----------------------  监听(阻断)请求过程   ----------------------

- (BOOL)requestProgressDidGetParams:(YBBaseRequest *)request{
    
    return YES;
}

-(void)requestProgressDidFinishRequest:(YBBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
}


@end
