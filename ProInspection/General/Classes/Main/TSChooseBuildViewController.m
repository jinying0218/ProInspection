//
//  TSChooseBuildViewController.m
//  ProInspection
//
//  Created by Aries on 14-7-10.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSChooseBuildViewController.h"
#import "TSAddQuestionViewController.h"

#import "TSBuildingCollectionViewCell.h"

#import "TSBuildingModel.h"

#import "TSSQLiteTool.h"

@interface TSChooseBuildViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *buildingArray;

@property (nonatomic, strong) UICollectionView *buildingCollectionView;

@end

@implementation TSChooseBuildViewController

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
    
    [self setNavigationBarWithTitle:@"选择楼栋" leftImage:@"" rightImage:nil];
    [self initializeData];
    [self setUI];
}

- (void)initializeData
{
    self.buildingArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[TSSQLiteTool sharedManager] open];
    
    FMResultSet *resultSet = [[TSSQLiteTool sharedManager] querySQLiteDataWithTable:@"tb_inspect_building"];
    while ( [resultSet next] )
    {
        int sqliteTreeId = [ resultSet intForColumn: @"treeId" ];
        
        if (self.treeId == sqliteTreeId)
        {
            NSLog(@"有楼栋");
            TSBuildingModel *buildinModel = [[TSBuildingModel alloc] init];
            
            buildinModel.biaoduanId = [ resultSet intForColumn: @"biaoduanId" ];
            buildinModel.buildingId = [ resultSet intForColumn: @"buildingId" ];
            buildinModel.buildingName = [ resultSet stringForColumn: @"buildingName" ];
            buildinModel.buildingType = [ resultSet stringForColumn: @"buildingType" ];
            buildinModel.fenqiId = [ resultSet intForColumn: @"fenqiId" ];
            buildinModel.inspectInstanceBuildingId = [ resultSet intForColumn: @"inspectInstanceBuildingId" ];
            buildinModel.inspectInstanceId = [ resultSet intForColumn: @"inspectInstanceId" ];
            buildinModel.isDelete = [ resultSet intForColumn: @"isDelete" ];
            buildinModel.isInspect = [ resultSet intForColumn: @"isInspect" ];
            buildinModel.zutuanId = [ resultSet intForColumn: @"zutuanId" ];
            
            [self.buildingArray addObject:buildinModel];
        }
    }
}

#pragma mark - 搭建UI
- (void)setUI
{
    // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 2.设置每个格子的尺寸
    layout.itemSize = CGSizeMake(115, 115);
    // 3.设置每一行之间的间距
    layout.minimumLineSpacing = 25;
    // 4.设置间距
    layout.sectionInset = UIEdgeInsetsMake(25, 81, 25, 81);
    CGRect collectionViewF;
    collectionViewF = CGRectMake( 60, STATUS_BAR_HEGHT + 44, self.view.frame.size.width - 60, KscreenH - STATUS_BAR_HEGHT - 44);
    
    self.buildingCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewF collectionViewLayout:layout];
    [self.buildingCollectionView registerClass:[TSBuildingCollectionViewCell class] forCellWithReuseIdentifier:@"TSBuildingCollectionViewCell"];

    self.buildingCollectionView.backgroundColor = [UIColor colorWithHexString:@"#faf9f4"];
    self.buildingCollectionView.backgroundView = nil;
    self.buildingCollectionView.dataSource = self;
    self.buildingCollectionView.delegate = self;
    self.buildingCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.buildingCollectionView];
    
}

#pragma mark - UICollectionView协议和数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [_arr[_selectBtn.tag] count];
    return self.buildingArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ZJBuildCollectionViewCell *cell = [ZJBuildCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
//    cell.delegate = self;
//    NSArray *tempArr = _arr[_selectBtn.tag];
//    NSDictionary *dict = tempArr[indexPath.row];
//    cell.buildingName = dict[@"buildingName"];
//    cell.buildingId = [dict[@"buildingId"] intValue];
//    return cell;
    
//    static NSString * CellIdentifier = @"GradientCell";
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TSBuildingCollectionViewCell *cell = (TSBuildingCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TSBuildingCollectionViewCell" forIndexPath:indexPath];

    TSBuildingModel *buildingModel = [self.buildingArray objectAtIndex:indexPath.row];
    cell.buildingNameLabel.text = buildingModel.buildingName;
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(96, 100);
//}
//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

#pragma mark - ZJBuildCollectionViewCellDelegate协议方法
- (void)jumpToRoomControllerWithbuildName:(NSString *)buildingName buildId:(int)buildingId
{
//    //跳转到房间界面
//    ZJRoomViewController *roomController = [[ZJRoomViewController alloc] init];
//    roomController.inspectModel = _inspectModel;
//    roomController.buildName = buildingName;
//    roomController.buildingId = buildingId;
//    [self.navigationController pushViewController:roomController animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择楼栋:%d",indexPath.row);
    TSBuildingModel *buildingModel = [self.buildingArray objectAtIndex:indexPath.row];

    TSAddQuestionViewController *addQuestionVC = [[TSAddQuestionViewController alloc] init];
    addQuestionVC.buildingModel = buildingModel;
    [self.navigationController pushViewController:addQuestionVC animated:YES];
    
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
