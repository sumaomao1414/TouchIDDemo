//
//  ViewController.m
//  TouchIDDemo
//
//  Created by maomao on 2016/11/2.
//  Copyright © 2016年 maomao. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /**
     
     Touch ID
     简介：
     http://baike.baidu.com/link?url=ua1AHBzhM_XY80BzoMfhQ5Sc1MgGKBZduIxwhAhKAviRmV0c7VGyH2bH5rxJPHJJQn6dqLvIqao_fmQRwnDFG2WbuZoBMxC9NqKx4oxUm9C
     */
    self.title = @"Just For Test";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(138, 200, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"点我哟" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startTouchId) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)startTouchId{
    
    LAContext *context = [LAContext new];
    NSError *error;
    context.localizedFallbackTitle = @"啦啦啦失败了吧";
    context.localizedCancelTitle = @"取消点我";
    
    // 用来判断设备是否支持Touch ID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // 验证身份
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"Use Touch ID to Change Color.", nil) reply:^(BOOL success, NSError *error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
                });
            }else{
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"Authentication Failed");
                        break;
                    }
                    case LAErrorTouchIDLockout:
                    {
                        NSLog(@"TOUCH ID is locked out");
                        break;
                    }
                    case LAErrorAppCancel:
                    {
                        NSLog(@"app cancle the authentication");
                        break;
                    }
                    case LAErrorInvalidContext:
                    {
                        NSLog(@"context is invalidated");
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
        //  });
    } else {
        /**
         LAErrorTouchIDNotAvailable 设备本身并不具备指纹传感装置。
         */
        NSLog(@"%@",error.localizedDescription);
        //不支持指纹识别，LOG出错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
               // 已经设定有密码机制，但设备配置当中还没有保存过任何指纹内容。
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                //设备上并不具备密码设置信息，也就是说Touch ID功能处于被禁用状态。
                NSLog(@"A passcode has not been set");
                break;
            }
            case LAErrorTouchIDNotAvailable:{
                NSLog(@"no TouchID");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
