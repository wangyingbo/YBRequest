//
//  YBBaseRequest.m
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/19.
//  Copyright © 2019年 wyb. All rights reserved.
//

#import "YBRequest.h"
#import "YBRequestParam.h"
#import "YBRequestManager.h"
#import <objc/runtime.h>

@implementation YBRequest


#pragma mark -  ---------------- factory method ----------------

/// 取消当前类的所有请求
+ (void)cancelRequest {
    [[YBRequestManager shareInstance] removeRequestWithClass:[self class]];
}

#pragma mark - ---------------- YBRequestDefaultDelegate ----------------

/// 配置每一个接口请求的默认参数
- (NSDictionary *)configurePerDefaultParams {
    return @{};
}

/// 每一个接口的属性参数的键名转换
- (NSDictionary<NSString *,NSString *> *)propertyKeyMapper {
    return @{};
}

#pragma mark -  ---------------- YBRequestParamDelegate ----------------

/// 配置每个接口的属性参数和默认参数
- (NSDictionary *)configurePerParams {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    //****** 默认参数 ******
    if ([self respondsToSelector:@selector(configurePerDefaultParams)]) {
        NSDictionary *perDefaultParameters = [self configurePerDefaultParams];
        if (perDefaultParameters) {
            [mutDic addEntriesFromDictionary:perDefaultParameters];
        }
    }
    
    //****** Add properties of Self.  属性参数 ******
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count<1) { return mutDic.copy; }
    
    NSDictionary *mappers = nil;//属性参数名映射
    if ([self respondsToSelector:@selector(propertyKeyMapper)]) {
        mappers = [self propertyKeyMapper];
    }
    for (NSInteger i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (![self respondsToSelector:@selector(valueForKey:)]) {
            continue;
        }
        NSString *value = [self valueForKey:key];
        if (!value) { continue; }
        NSString *realKey = key;
        if (mappers) {//在映射里获取到真实的key
            if ([[mappers allKeys] containsObject:key]) {
                realKey = [mappers objectForKey:key];
            }
        }
        [mutDic setObject:value forKey:realKey];
    }
    free(properties);
    return mutDic.copy;
}

#pragma mark -  ---------------- YBBaseRequestDelegate ----------------
-(void)requestProgressDidFinishRequest:(YBBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
    
    NSError *error = nil;
    id json = nil;
    @try {
        json = [NSJSONSerialization JSONObjectWithData:self.responseObject options:NSJSONReadingMutableLeaves error:&error];
    } @catch (NSException *exception) {
        self.error = error;
        RequestLog(@"服务器返回数据解析错误:parse error! : %@",self.responseObject);
    } @finally {
        
    }
    if (error == nil) {
        self.responseJson = json;
    }
    
    [self doLogWithSuccess:YES];
}
    
-(void)requestProgressDidFailedRequest:(YBBaseRequest *)request task:(NSURLSessionDataTask *)task withError:(NSError *)error{
    
    [super requestProgressDidFailedRequest:request task:task withError:error];
    
    [self doLogWithSuccess:NO];
}
    
    
- (void)doLogWithSuccess:(BOOL)suc{
    //是否禁止request的log
    if (self.paramDelegate && [self.paramDelegate respondsToSelector:@selector(banRequestLog)]) {
        BOOL isBan = [self.paramDelegate banRequestLog];
        if (isBan) { return; }
    }
    
    //debug默认有log，release则根据设置决定是否打印log
    BOOL doLog = NO;
#ifdef DEBUG
    doLog = YES;
#else
    if (self.paramDelegate && [self.paramDelegate respondsToSelector:@selector(configureCollectionLogIfRelease)]) {
        doLog = [self.paramDelegate configureCollectionLogIfRelease];
    }
#endif
    if (doLog) {
        NSData *data = nil;
        id json = nil;
        NSMutableString *log = [NSMutableString string];
        [log appendFormat:@"\n===================== %@-begin =====================",[self class]];
        if (self.responseObject) {
            @try {
                json = [NSJSONSerialization JSONObjectWithData:self.responseObject options:NSJSONReadingMutableLeaves error:nil];
            }@catch (NSException *exception) {
                [log appendFormat:@"\n"];
                [log appendFormat:@"\n 【responseObject->json解析异常】"];
            } @finally {}
        }
        
        if (json) {
            @try {
                data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
            } @catch (NSException *exception) {
                [log appendFormat:@"\n"];
                [log appendFormat:@"\n 【json->data解析异常】"];
            } @finally {}
        }
        NSString * dataString;
        if (data) {
            dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【#placeholder#】"];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【current-time】:%@",[NSDate date]];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【request-time】:%fS",self.endTime - self.startTime];
        
        [log appendFormat:@"\n"];
        if ([self requestType] == RequestTypeForm)[log appendFormat:@"\n【RequestType】:RequestTypeForm"];
        if ([self requestType] == RequestTypeJson)[log appendFormat:@"\n【RequestType】:RequestTypeJson"];
        
        [log appendFormat:@"\n"];
        if ([self configureRequestMethod] == RequestMethodGet)
        [log appendFormat:@"\n【RequestMethod】:RequestMethodGet"];
        if ([self configureRequestMethod] == RequestMethodPost)
        [log appendFormat:@"\n【RequestMethod】:RequestMethodPost"];
        if ([self configureRequestMethod] == RequestMethodDownload)
        [log appendFormat:@"\n【RequestMethod】:RequestMethodDownload"];
        if ([self configureRequestMethod] == RequestMethodUploadPost)
        [log appendFormat:@"\n【RequestMethod】:RequestMethodUploadPost"];
        if ([self configureRequestMethod] == RequestMethodMultipartPost)
        [log appendFormat:@"\n【RequestMethod】:RequestMethodMultipartPost"];
        
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【url】:%@",self.totalUrl];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【custem-header】:%@",self.header];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【all-header】:%@",self.task.currentRequest.allHTTPHeaderFields];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【param】:%@",self.params.param];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【defalutParams】:%@",self.defalutParams];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【totalParams】:%@",self.totalParams];
        [log appendFormat:@"\n"];
        
        if(suc){
            [log appendFormat:@"\n【server origin data】:%@",[[NSString alloc]initWithData:self.responseObject encoding:NSUTF8StringEncoding]];
            [log appendFormat:@"\n"];
            [log appendFormat:@"\n【server origin json】:%@",self.responseJson];
            [log appendFormat:@"\n"];
            [log appendFormat:@"\n【server origin json to chinese】:%@",dataString];
        }else{
            [log appendFormat:@"\n【error】:%@",self.error];
        }
        
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n【#placeholder#】"];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n===================== %@-end =====================\n",[self class]];
        
        [[YBRequestManager shareInstance] addLog:[NSString stringWithString:log]];
        RequestLog(@"%@",log);
    }
}
    
    
@end




