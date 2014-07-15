//
//  TSHomeViewController.m
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//
//视图控制器
#import "TSHomeViewController.h"
#import "TSChooseBuildViewController.h"
//工具
#import "TSHttpTool.h"
#import "SSZipArchive.h"
#import "TSSQLiteTool.h"
//第三方
#import "AFHTTPRequestOperation.h"
//模型
#import "TSProjectListModel.h"
#import "TSProjectInspectModel.h"
//自定义视图
#import "TSProjectListCell.h"



@interface TSHomeViewController ()<UITableViewDataSource,UITableViewDelegate,TSProjectListCellDelegate>

@property (nonatomic, strong) NSMutableArray *projectListArray;
@property (nonatomic, strong) NSMutableArray *subCompanyListArray;
@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic, strong) UITableView *projectTableView;

@end

@implementation TSHomeViewController

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
    
    [self initializeData];
    [self GetProjectList];
    [self setUI];
    
}

#pragma mark - 初始化数据
- (void)initializeData
{
    self.projectListArray = [NSMutableArray arrayWithCapacity:0];
    self.subCompanyListArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - 搭建界面
- (void)setUI
{
    self.projectTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, STATUS_BAR_HEGHT, KscreenW, KscreenH - STATUS_BAR_HEGHT) style:UITableViewStyleGrouped];
    self.projectTableView.delegate = self;
    self.projectTableView.dataSource = self;
    self.projectTableView.rowHeight = 72;
    [self.view addSubview:self.projectTableView];
}

#pragma mark - 获取项目列表
- (void)GetProjectList
{
    @weakify(self);

    NSString *getProjectlistURL = [NSString stringWithFormat:@"%@?userId=%d",GetProjectList_URL,[TSUserModel getCurrentLoginUser].userId];

    [TSHttpTool getWithUrl:getProjectlistURL params:nil withCache:YES success:^(id result) {

        @strongify(self);

        if ([[result objectForKey:@"rs"] intValue] == 1) {
            
            NSLog(@"self.projectList:%@",[result objectForKey:@"projectList"]);

            for (NSDictionary *oneProject in [result objectForKey:@"projectList"]) {
                
                TSProjectListModel *projectModel = [[TSProjectListModel alloc] init];
                [projectModel setValuesForKeysWithDictionary:oneProject];
                [self.projectListArray addObject:projectModel];
            }
            for (NSDictionary *oneCompany in [result objectForKey:@"subCompanyList"]) {
                
                TSProjectListModel *companyModel = [[TSProjectListModel alloc] init];
                [companyModel setValuesForKeysWithDictionary:oneCompany];
                [self.subCompanyListArray addObject:companyModel];

            }
            
            [self.projectTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"GetProjectListError:%@",error);
    }];
}

#pragma mark - tableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *projectListCellIdentify = @"projectListCell";
    TSProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:projectListCellIdentify];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TSProjectListCell" owner:self options:nil] lastObject];
    }
    
    TSProjectListModel *projectModel = [self.projectListArray objectAtIndex:indexPath.row];
    
    cell.treeNameLabel.text = projectModel.treeName;
    cell.treeId = projectModel.treeId;
    cell.delegate = self;
    cell.indexpath = indexPath;
    cell.fileSizeLabel.hidden = YES;

    
    FMResultSet *resultSet = [[TSSQLiteTool sharedManager] querySQLiteDataWithTable:@"tb_projectlist"];
    while ( [resultSet next ] )
    {
        int treeId = [ resultSet intForColumn: @"treeId" ];
        if (cell.treeId == treeId) {
            [cell.downloadButton setTitle:@"已完成下载" forState:UIControlStateNormal];
            cell.downloadButton.enabled = NO;
            
            NSLog(@"asdlkfja");
        }
    }

    [[TSSQLiteTool sharedManager] close];
    return cell;
}
#pragma mark -选择某一项目
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - TSProjectListCell的代理方法

- (void)checkProjectWithTreeId:(int)treeId
{
    NSLog(@"代理相应查看方法");
    
    TSChooseBuildViewController *chooseBuildVC = [[TSChooseBuildViewController alloc] init];
    chooseBuildVC.treeId = treeId;
    [self.navigationController pushViewController:chooseBuildVC animated:YES];
}


- (void)resumeDownloadProjectWith:(int)treeId downloadStatus:(DownloadStatusType)status indexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    NSString *getProjectlistURL = [NSString stringWithFormat:@"%@?projectId=%d",GetProjectInfo_URL,treeId];
    
    [TSHttpTool getWithUrl:getProjectlistURL params:nil withCache:NO success:^(id result) {
        
        @strongify(self);
        
        if ([[result objectForKey:@"rs"] intValue] == 1)
        {
            
            NSLog(@"success:%@",result);
            TSProjectInspectModel *inspectModel = [[TSProjectInspectModel alloc] init];
            [inspectModel setValuesForKeysWithDictionary:[result objectForKey:@"inspectInstance"]];
            
            TSProjectListModel *projectListModel = [self.projectListArray objectAtIndex:indexPath.row];
            
            //将项目信息插入数据库
            [[TSSQLiteTool sharedManager] insertProjectListData:projectListModel withProjectInspectModel:inspectModel];
            
            //断点下载
            [self resumeDownloadWithURL:inspectModel.downloadInstanceUrl indexPath:indexPath];
        }
        else
        {
            NSLog(@"errorMsg:%@",[result objectForKey:@"errorMsg"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"GetProjectListError:%@",error);
    }];

}

#pragma mark - 断点下载
- (void)resumeDownloadWithURL:(NSString *)downloadURL indexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    NSURL *url = [NSURL URLWithString:downloadURL];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *downloadPath = [documents[0]stringByAppendingPathComponent:@"Instance.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:downloadPath append:NO]];
    
    [self.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
       
        @strongify(self);
        
        TSProjectListCell *cell = (TSProjectListCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
        
        int percent = (int)((float)totalBytesRead / totalBytesExpectedToRead)*100;
        cell.fileSizeLabel.text = [NSString stringWithFormat:@"%@%d",@"%",percent];
        // 下载进度百分比
//        NSLog(@"下载百分比:%f", ((float)totalBytesRead / totalBytesExpectedToRead)*100);
    }];
    
    [self.operation setCompletionBlock:^{
        
        @strongify(self);
        
        [SSZipArchive unzipFileAtPath:downloadPath toDestination:documents[0]];
        
        TSProjectListCell *cell = (TSProjectListCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
        int fileSize = (int)[NSFileManager fileSizeForDir:documents[0]];
        cell.fileSizeLabel.text = [NSString stringWithFormat:@"%d",fileSize];
        
        [cell.downloadButton setTitle:@"已完成下载" forState:UIControlStateNormal];
        cell.downloadButton.enabled = NO;

        [self.projectTableView reloadData];
        
        [[NSFileManager defaultManager]removeItemAtPath:downloadPath error:nil];
        [[TSSQLiteTool sharedManager] traversalFileWithTreeId:cell.treeId];
        
    }];
    
    
    // 8   启动操作
    [self.operation start];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
