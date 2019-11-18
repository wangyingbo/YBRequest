//
//  YBViewController.m
//  YBRequest
//
//  Created by wangyingbo on 11/18/2019.
//  Copyright (c) 2019 wangyingbo. All rights reserved.
//

#import "YBViewController.h"
#import "FirstTestRequest.h"
#import "SecondTestRequest.h"

@interface YBViewController ()
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation YBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self configUI];
}

#pragma mark - configUI
- (void)configUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40, 45.f);
    button.titleLabel.font = [UIFont systemFontOfSize:20.];
    [button setTitle:@"请求" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
    [button addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button.frame) + 20, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(button.frame) - 50 )];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:17.f];
    textView.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
    [self.view addSubview:textView];
    self.textView = textView;
    
}

#pragma mark - action
-(void)postButtonClick{
    
    [SecondTestRequest startRequestWithName:@"wangyingbo" ID:@"001" success:^(SecondTestRequest *request) {
        self.textView.text = [NSString stringWithFormat:@"%@",request.responseObject];
    } failure:^(id request) {
        
    }];
    
    
    return;
    [FirstTestRequest requestWithDic:nil requestFinish:^(FirstTestRequest *request) {
        self.textView.text = [NSString stringWithFormat:@"%@",request.responseJson];
    } requestFailed:^(FirstTestRequest *request) {
        self.textView.text = [NSString stringWithFormat:@"%@",request.error];
    }];
    
    
    
    return;
    //上传图片、视频、其他
    [BaseRequest requestWithParam:nil inView:nil requestUpload:^(id<AFMultipartFormData> formData) {
        
        NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@""], 0.7);
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:[NSString stringWithFormat:@"image%d.jpg",0]
                                mimeType:@"image/jpg"];

    } requestProgress:^(id request, NSProgress *progress) {

    } requestFinish:^(id request) {

    } requestFailed:^(id request) {

    }];
}

@end
