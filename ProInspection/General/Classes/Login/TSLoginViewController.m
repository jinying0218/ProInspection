//
//  TSLoginViewController.m
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSLoginViewController.h"
#import "TSHomeViewController.h"

#import "MBProgressHUD.h"

#import "TSHttpTool.h"
#import "TSSQLiteTool.h"



@interface TSLoginViewController ()


@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *passwordText;

@end

@implementation TSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];

}

- (void)setupUI
{
    self.userNameText = [[UITextField alloc] initWithFrame:CGRectMake( 100, 100, 100, 40)];
    self.userNameText.text = @"cc";
    self.userNameText.backgroundColor = [UIColor yellowColor];

    [self.view addSubview:self.userNameText];
    
    self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake( 100, 200, 100, 40)];
    self.passwordText.text = @"cc";
    self.passwordText.backgroundColor = [UIColor yellowColor];

    [self.view addSubview:self.passwordText];
    
    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logButton.backgroundColor = [UIColor greenColor];
    [logButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    logButton.frame = CGRectMake( 100, 300, 100, 40);
    [self.view addSubview:logButton];
    
}

- (void)buttonOnClick:(UIButton *)button
{
    @weakify(self);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameText.text,@"userName",[self.passwordText.text MD5Hash],@"password", nil];
    
    [TSHttpTool postWithUrl:Login_URL params:params success:^(id result) {
        
        @strongify(self);

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[result objectForKey:@"rs"] intValue] == 1) {
            
            NSLog(@"LoginSuccess");
            [[TSUserModel getCurrentLoginUser] setValuesForKeysWithDictionary:[result objectForKey:@"user"]];
            [[TSUserModel getCurrentLoginUser] saveToDisk];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginSuccess"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[TSSQLiteTool sharedManager] createSQLiteData];
            
            TSHomeViewController *homeVC = [[TSHomeViewController alloc] init];
            [self.navigationController pushViewController:homeVC animated:YES];
        }
        else
        {
            NSLog(@"loginMsg:%@",[result objectForKey:@"errorMsg"]);
        }
        
    } failure:^(NSError *error) {
        
        @strongify(self);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
        [TSHttpTool getCurrentNetworkStatus:^(NSInteger status) {
            
            if (status == -1 || status == 0) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"当前网络不可用，请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败，用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
//                double delaySeconds = 2;
//                dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
//                
//                dispatch_after(poptime, dispatch_get_main_queue(), ^{
//                   
//                    
//                });
            }
        }];

        
       
        NSLog(@"loginError:%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
