//
//  TSBaseViewController.m
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSBaseViewController.h"

@interface TSBaseViewController ()

@end

@implementation TSBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)setNavigationBarWithTitle:(NSString *)title leftImage:(NSString *)leftImage rightImage:(NSString *)rightImage
{
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEGHT, KscreenW, 44)];
    navigationBar.backgroundColor = [UIColor colorWithHexString:@"#12a855"];
    UIButton *returnBtn  = [self navigationBtnWithnormal:@"返回" hightlight:@"" index:0];
    [returnBtn addTarget:self action:@selector(returnButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:returnBtn];

    UILabel *titleLabel = [[UILabel alloc] init];
    if(!IOS7)
    {
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    titleLabel.text = title;
    // CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:@"STHeiti-Medium" size:30]];
    titleLabel.frame = CGRectMake((self.view.frame.size.width - 105) * 0.5, 0, 105, 44);
    titleLabel.contentMode = UIViewContentModeCenter;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [navigationBar addSubview:titleLabel];
    [self.view addSubview:navigationBar];
}

#pragma mark - 创建导航栏上的按钮
- (UIButton *)navigationBtnWithnormal:(NSString *)normal hightlight:(NSString *)highlight index:(int)index
{
    // 导航栏右侧添加图片
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentMode = UIViewContentModeCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    btn.frame = CGRectMake( 15, 5, 33, 33);
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
    return btn;
}

- (void)returnButtonOnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
