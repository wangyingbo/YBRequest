//
//  YBBaseRequest.h
//  YBRequestDemo
//
//  Created by wangyingbo on 2019/2/19.
//  Copyright © 2019年 wyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YBRequestParam.h"
#import "YBRequestManager.h"
#import <AFNetworking/AFNetworking.h>

#define kNoNetworkCode (1314)
#define kDataError @"数据格式错误."
#define kNotworkError @"网络连接失败,请检查您的网络连接."

#ifndef tf_weak_obj
#define tf_weak_obj(target,name)  __weak typeof(target) name = target;
#endif
#ifndef kdeclare_weakself
#define kdeclare_weakself tf_weak_obj(self,weakSelf)
#endif

#ifndef tf_strong_obj
#define tf_strong_obj(target,name)  __strong typeof(target) name = target;
#endif
#ifndef kdeclare_strongself
#define kdeclare_strongself tf_strong_obj(self,strongSelf)
#endif


//#ifdef DEBUG
//#   define RequestLog(fmt, ...) NSLog((@"\nfun:%s,line:%d\n" fmt @"\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define RequestLog(...)
//#endif


//根据代理方法决定是否打印
#   define RequestLog(fmt, ...) NSLog((@"\nfun:%s,line:%d\n" fmt @"\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);




//请求方法,default=RequestMethodPost
typedef NS_ENUM(NSInteger,RequestMethod) {
    RequestMethodGet = 0,
    RequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    RequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"
    //mimeType(video):application/octet-stream, mimeType(image):@"image/png",
    RequestMethodUploadPost = 3,
    RequestMethodDownload = 4,
};

//请求方式,default=RequestTypeForm
typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeForm = 0,
    RequestTypeJson = 1,
};

//响应序列化，默认是ResponseSerializerHttp
typedef NS_ENUM(NSUInteger,ResponseSerializer) {
    ResponseSerializerHttp = 0,
    ResponseSerializerJson = 1,
};

NS_ASSUME_NONNULL_BEGIN


//请求回调block
typedef void (^ _Nullable RequestStartBlock)(id request);
typedef void (^ _Nullable RequestProgressBlock)(id request,NSProgress *progress);
typedef void (^ _Nullable RequestFinishBlock)(id request);
typedef void (^ _Nullable RequestCanceledBlock)(id request);
typedef void (^ _Nullable RequestFailedBlock)(id request);
//上传block
typedef void (^ _Nullable RequestUploadDataBlock)(id<AFMultipartFormData>formData);
//下载block
typedef void (^ _Nullable RequestDownloadcompletionBlock)(NSURLResponse *response, NSURL *filePath, NSError *error);

#pragma mark - YBRequestParamDelegate

/* 请求配置的代理方法,本类已自己为代理,并实现所有方法做了默认配置.
 * 如果修改的话,可以在子类重写方法
 */
@protocol YBRequestParamDelegate <NSObject>

///配置请求方式
- (RequestType)configureRequestType;
- (NSSet <NSString *> *)configureAcceptableContentTypes;
- (ResponseSerializer)configureResponseSerializer;//响应序列化
- (RequestMethod)configureRequestMethod;//配置请求方法
- (NSString *)configureBaseUrl;//配置baseUrl
- (NSString *)configureUrl;//配置url

- (NSData *)configureDownloadResumeData;//配置下载的断点数据
- (NSURL *)configureDownloadDestinationPath:(NSURL *)targetPath response:(NSURLResponse *)response;//配置下载的目标目录


/// 配置总的请求头
- (NSDictionary *)configureHeader;
/// 配置每个接口的请求头
- (nullable NSDictionary *)configurePerRequestHeader;
//配置所有请求的默认请求参数,请求时会和传进来的参数合并,并且传的参数会覆盖默认参数的相同项
- (NSDictionary *)configureDefalutParams;
- (NSDictionary *)configurePerParams;//配置每一个接口的参数
- (AFSecurityPolicy *)configureSecurityPolicy;//配置隐私策略

- (BOOL)banRequestLog;//返回yes时，禁调request的log
- (BOOL)configureCollectionLogIfRelease;//release下是否收集log,默认NO
- (NSTimeInterval)configureTimeoutInterval;//配置请求超时时间,默认30s


@end


#pragma mark - YBBaseRequestDelegate

/* 请求过程代理方法,下面方法会在请求过程中各个阶段调用,返回值为BOOL类型可以打断请求
 * 下面方法本类已自己为代理,并实现所有方法做了默认处理,集体请看各个方法的注释.
 * 如需在过程方法中添加其他操作,直接子类重写即可
 */
@class YBBaseRequest;
@protocol YBBaseRequestDelegate <NSObject>
@optional
//请求对象创建完成
-(BOOL)requestProgressInit:(YBBaseRequest *)request;
//请求开始获取参数和请求配置
-(BOOL)requestProgressWillGetParams:(YBBaseRequest *)request;
//请求已经获取参数和请求配置
-(BOOL)requestProgressDidGetParams:(YBBaseRequest *)request;
//请求将要开始发送请求,如需在请求前修改请求配置或者参数,重写此方法即可
-(BOOL)requestProgressWillSendRequest:(YBBaseRequest *)request task:(NSURLSessionTask *)task;
//请求-上传请求已经拼接完上传的数据,如需修改上传数据重写此方法即可
-(void)requestProgressUploadDidJointedFormdataRequest:(YBBaseRequest *)request
                                                 task:(NSURLSessionTask *)task
                                             formData:( _Nullable id)formData;
//请求已经发送请求,正在等待服务器返回结果
-(void)requestProgressDidSendRequest:(YBBaseRequest *)request
                                task:(NSURLSessionTask *)task;
//请求已经发送,回调请求/上传/下载进度
-(void)requestProgressProgressingRequest:(YBBaseRequest *)request
                                    task:(NSURLSessionTask *)task
                                progress:(NSProgress * _Nullable )progress;
//请求完成/下载完成/上传完成
-(void)requestProgressDidFinishRequest:(YBBaseRequest *)request
                                  task:(NSURLSessionTask *)task
                        responseObject:( _Nullable id)responseObject;
//请求取消
-(void)requestProgressDidCancelRequest;
//请求失败
-(void)requestProgressDidFailedRequest:(YBBaseRequest *)request
                                  task:(NSURLSessionTask *)task
                             withError:(NSError* _Nullable )error;
//请求完成,将要回调到请求完成block
-(BOOL)requestProgressWillFinishCallBack:(YBBaseRequest *)request
                                    task:(NSURLSessionTask *)task
                                progress:(NSProgress * _Nullable )progress
                          responseObject:( _Nullable id)responseObject
                               withError:(NSError* _Nullable )error;
//请求完成,已经回调到请求完成block
-(void)requestProgressDidFinishCallBack:(YBBaseRequest  * _Nullable )request
                                   task:(NSURLSessionTask * _Nullable)task
                               progress:(NSProgress * _Nullable)progress
                         responseObject:(_Nullable id)responseObject
                              withError:(NSError* _Nullable )error;
//请求完成,将要回调到请求失败block
-(BOOL)requestProgressWillFailedCallBack:(YBBaseRequest *)request
                                    task:(NSURLSessionTask *)task
                                progress:(NSProgress * _Nullable )progress
                          responseObject:( _Nullable id)responseObject
                               withError:(NSError* _Nullable )error;
//请求完成,已经回调到请求失败block
-(void)requestProgressDidFailedCallBack:(YBBaseRequest *)request
                                   task:(NSURLSessionTask *)task
                               progress:(NSProgress * _Nullable )progress
                         responseObject:(id _Nullable )responseObject
                              withError:(NSError* _Nullable )error;

@end


@class AFHTTPSessionManager;
@interface YBBaseRequest : NSObject<NSCoding,YBBaseRequestDelegate,YBRequestParamDelegate>

@property (nonatomic,   weak) id<YBRequestParamDelegate> paramDelegate;
@property (nonatomic,   weak) id<YBBaseRequestDelegate> requestDelegate;

@property (nonatomic, strong) NSURLSessionTask  *task;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSURLResponse *downloadResponse;
@property (nonatomic, strong) NSURL *downloadFilePath;

@property (nonatomic,   copy) RequestStartBlock startBlock;
@property (nonatomic,   copy) RequestUploadDataBlock uploadBlock;
@property (nonatomic,   copy) RequestDownloadcompletionBlock downloadcompletionBlock;
@property (nonatomic,   copy) RequestFinishBlock finishBlock;
@property (nonatomic,   copy) RequestCanceledBlock canceledBlock;
@property (nonatomic,   copy) RequestFailedBlock failedBlock;
@property (nonatomic,   copy) RequestProgressBlock progressBlock;


//以下参数可在代理方法requestProgressDidGetParams时(后)取到
/**请求的url,最终会和baseUrl,拼成totalUrl*/
@property (nonatomic,   copy) NSString *url;//
/**baseUrl,最终会和url,拼成totalUrl*/
@property (nonatomic,   copy) NSString *baseUrl;//
/**baseUrl和url拼接后的总的url*/
@property (nonatomic,   copy) NSString *totalUrl;//
/**下载的Request*/
@property (nonatomic, strong) NSURLRequest *downLoadRequest;//
/**请求类型*/
@property (nonatomic, assign) RequestType requestType;
/**响应序列化*/
@property (nonatomic, assign) ResponseSerializer responseSerializer;
/***/
@property (nonatomic, copy, nullable) NSSet<NSString *> *acceptableContentTypes;
/**请求方法*/
@property (nonatomic, assign) RequestMethod requestMethod;
/**隐私策略*/
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

/**请求头-所有默认的请求头*/
@property (nonatomic, strong) NSMutableDictionary *header;
/**每个接口的请求头*/
@property (nonatomic, strong) NSMutableDictionary *perHeader;
/**请求参数*/
@property (nonatomic, strong) YBRequestParam *params;
/**请求默认参数*/
@property (nonatomic, strong) NSMutableDictionary *defalutParams;
/**总的参数，params.param和defalutParams的和*/
@property (nonatomic, strong) NSMutableDictionary *totalParams;
/**请求超时的时间*/
@property (nonatomic, assign) NSTimeInterval timeoutInterval;


/**用户默认处理弹框和loading的view*/
@property (nonatomic,   weak) UIView *inView;

/**可在代理方法requestProgressDidFailedRequest时(后)取到*/
@property (nonatomic, strong) NSError *error;

/**参数错误的error*/
@property (nonatomic, strong) NSError *paramError;

/**responseObject，可在代理方法requestProgressDidFinishRequest时(后)取到*/
@property (nonatomic, strong) id responseObject;
/**responseJson，可在代理方法requestProgressDidFinishRequest时(后)取到*/
@property (nonatomic, strong) id responseJson;

/**请求开始的时间*/
@property (nonatomic, assign) CFAbsoluteTime startTime;
/**请求开始和结束的时间*/
@property (nonatomic, assign) CFAbsoluteTime endTime;
/**是否在release环境收集log*/
@property (nonatomic, assign) BOOL collectionLogIfRelease;


#pragma mark - factory method
+(instancetype)requestWithDic:(NSDictionary * _Nullable )dic
                requestFinish:(RequestFinishBlock)finish
                requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithDic:(NSDictionary * _Nullable )dic
                       inView:(UIView * _Nullable )inView
                requestFinish:(RequestFinishBlock)finish
                requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(YBRequestParam *)param
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(YBRequestParam * _Nullable )param
                         inView:(UIView * _Nullable )inView
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(YBRequestParam * _Nullable )param
                         inView:(UIView * _Nullable )inView
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(YBRequestParam * _Nullable )param
                         inView:(UIView * _Nullable )inView
                   requestStart:(RequestStartBlock)start
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish requestCanceled:(RequestCanceledBlock)canceled requestFailed:(RequestFailedBlock)failed;


+(instancetype)requestWithDownloadRequest:(NSURLRequest *)downRequest inView:(UIView * _Nullable )inView requestStart:(RequestStartBlock)start requestProgress:(RequestProgressBlock)progress completion:(RequestDownloadcompletionBlock)completion;

-(instancetype)initWithParam:(YBRequestParam * _Nullable )param
                      inView:(UIView * _Nullable )inView
                requestStart:(RequestStartBlock)start
               requestUpload:(RequestUploadDataBlock)upload
             requestProgress:(RequestProgressBlock)progress completion:(RequestDownloadcompletionBlock)completion requestFinish:(RequestFinishBlock)finish requestCanceled:(RequestCanceledBlock)canceled requestFailed:(RequestFailedBlock)failed;

-(void)beginRequest;

-(void)cancelRequest;

#pragma mark - instance method

-(instancetype)requestWithFinish:(RequestFinishBlock)finish
                   requestFailed:(RequestFailedBlock)failed;

-(instancetype)requestWithInView:(UIView * _Nullable )inView
                   requestFinish:(RequestFinishBlock)finish
                   requestFailed:(RequestFailedBlock)failed;

-(instancetype)requestWithStart:(RequestStartBlock)start
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                requestCanceled:(RequestCanceledBlock)canceled
                  requestFailed:(RequestFailedBlock)failed;

-(instancetype)requestWithStart:(RequestStartBlock)start requestProgress:(RequestProgressBlock)progress completion:(RequestDownloadcompletionBlock)completion;

-(instancetype)requestWithParam:(NSDictionary * _Nullable)dict
                         inView:(UIView * _Nullable )inView
                   requestStart:(RequestStartBlock)start requestUpload:(RequestUploadDataBlock)upload requestProgress:(RequestProgressBlock)progress completion:(RequestDownloadcompletionBlock)completion requestFinish:(RequestFinishBlock)finish requestCanceled:(RequestCanceledBlock)canceled requestFailed:(RequestFailedBlock)failed;

@end

NS_ASSUME_NONNULL_END
