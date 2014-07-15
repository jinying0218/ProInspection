//
//  TSAddQuestionViewController.m
//  ProInspection
//
//  Created by Aries on 14-7-15.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSAddQuestionViewController.h"
#import "TSBuildingModel.h"

@interface TSAddQuestionViewController ()

@end

@implementation TSAddQuestionViewController

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
    [self setNavigationBarWithTitle:self.buildingModel.buildingName leftImage:@"" rightImage:nil];
    
    
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
