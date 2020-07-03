//
//  BaseRequest.m
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/22.
//  Copyright © 2019年 wyb. All rights reserved.
//

#import "BaseRequest.h"

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

/// 配置每个请求接口的url，子类重写
- (NSString *)configureUrl {
    return @"";
}

/// 配置传参类型：是formData还是json
-(RequestType)configureRequestType{
    return RequestTypeForm;
}

/// 配置请求方式，post、get等
-(RequestMethod)configureRequestMethod{
    return RequestMethodPost;
}

/// 配置响应序列化方式
- (ResponseSerializer)configureResponseSerializer {
    return ResponseSerializerHttp;
}

/// 配置所有请求的共同请求头
-(NSDictionary *)configureHeader{
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"1" forKey:@"appBundleVersion"];
    [header setObject:@"1.0" forKey:@"appVersion"];
    [header setObject:@"en" forKey:@"lang"];
    [header setObject:@"ios" forKey:@"source"];
    [header setObject:@"12.1" forKey:@"systemVersion"];
    return header;
}

/// 配置每一个接口的不同请求头
- (NSDictionary *)configurePerRequestHeader {
    return @{};
}

/// 配置所有接口请求的默认参数，每个接口都会有此参数
-(NSDictionary *)configureDefalutParams{
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"xxxxxx" forKey:@"token"];
    return header;
}

/// 配置每一个接口的参数（合并属性参数和默认参数）；
/// 子类尽量不重写此方法，在此统一处理。
//- (NSDictionary *)configurePerParams {
//    return [super configurePerParams];
//}

/// 配置请求超时时间
- (NSTimeInterval)configureTimeoutInterval {
    return 30;
}

/// 配置是否禁止log，子类可重写
- (BOOL)banRequestLog {
    return NO;
}

/// release是否收集log
-(BOOL)configureCollectionLogIfRelease{
    return NO;
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

#pragma mark - ---------------- YBRequestDefaultDelegate ----------------

/// 配置每一个接口请求的默认参数，每一个子类request可重写此方法
- (NSDictionary *)configurePerDefaultParams {
    return @{};
}

/**
 每一个接口请求的属性参数的键名转换，每一个子类可重写此方法。
 如参数为id，则属性名为可写为ID，此方法里实现映射：
    @{ @"ID":@"id" }
 */
- (NSDictionary<NSString *,NSString *> *)propertyKeyMapper {
    return @{};
}


#pragma mark - ---------------- 监听(阻断)请求过程 ----------------

/// 可在此获取请求已经配好的参数所有参数，可在此修改或做其他操作
/// @param request request description
- (BOOL)requestProgressDidGetParams:(YBBaseRequest *)request{
    NSDictionary *dic = request.totalParams;
    if (dic) {
        //处理参数
        NSLog(@"\n");
    }
    return YES;
}

/// 将发送请求
/// @param request request description
/// @param task task description
- (BOOL)requestProgressWillSendRequest:(YBBaseRequest *)request task:(NSURLSessionTask *)task {
    return YES;
}

-(void)requestProgressDidFinishRequest:(YBBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
}


@end
