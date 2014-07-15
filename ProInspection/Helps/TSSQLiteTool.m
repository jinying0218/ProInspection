//
//  TSSQLiteTool.m
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSSQLiteTool.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "TSInspectStandardModel.h"
#import "TSBuildingModel.h"
#import "TSInspectItemModel.h"


typedef enum
{
    buildingType = 0,
    inspectItemType,
    inspectStandardType
}DataType;

@implementation TSSQLiteTool

static TSSQLiteTool *sharedInstance = nil;

+ (TSSQLiteTool *)sharedManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{

        sharedInstance = [[self alloc] initWithPath:[self databasePathWithFileName:@"ProInspection.db"]];
        
    });
    return sharedInstance;
}

#pragma mark - 创建数据库
- (void)createSQLiteData
{
    BOOL createTable = NO;

    if (![[TSSQLiteTool sharedManager] open]) {
        NSLog(@"打开数据库失败");
        return;
    }
    // 用户信息表
    if(![[TSSQLiteTool sharedManager] tableExists:@"tb_userinfo"])
    {
        createTable = [[TSSQLiteTool sharedManager] executeUpdate:@"CREATE TABLE  if not exists [tb_userinfo]([userId]INTEGER(20),[userName]char(100),[accessSecret]TEXT,[accessToken]TEXT,[cellphone]TEXT,[companyId]INTEGER(11),[companyName]CHAR(50),[displayName]CHAR(50),[email]VARCHAR(255),[groupList]CHAR(20),[isValid]INTEGER(20),[sex]INTEGER(10),[subCompanyId]INTEGER(20),[subCompanyName]CHAR(100))"];
        if (!createTable) {
            NSLog(@"tb_userinfo创建失败");
        }
        else
        {
            NSLog(@"tb_userinfo创建成功");
        }
        
    }
    //项目列表
    if(![[TSSQLiteTool sharedManager] tableExists:@"tb_projectlist"])
    {
        createTable = [[TSSQLiteTool sharedManager] executeUpdate:@"CREATE TABLE  if not exists [tb_projectlist](id int , userId int, treeId int,treeName varchar(128),treeType varchar(128),fatherTreeId int,downloadInstanceUrl varchar(256),inspectInstanceId INTEGER(100))"];
        if (!createTable) {
            NSLog(@"tb_userinfo创建失败");
        }
        else
        {
            NSLog(@"tb_userinfo创建成功");
        }
        
    }
    // 检查标准表
    if(![[TSSQLiteTool sharedManager] tableExists:@"tb_inspect_standard"])
    {
        createTable = [[TSSQLiteTool sharedManager] executeUpdate:@"CREATE TABLE  if not exists tb_inspect_standard (standardId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,inspectInstanceId integer, inspectStandardId integer,inspectStandardName text,isDelete integer)"];
        if (!createTable) {
            NSLog(@"standard创建失败");
        }
        else
        {
            NSLog(@"standard创建成功");
        }

    }
    // 楼栋
    if(![[TSSQLiteTool sharedManager] tableExists:@"tb_inspect_building"])
    {
        createTable = [[TSSQLiteTool sharedManager] executeUpdate:@"CREATE TABLE  if not exists tb_inspect_building ([treeId]INT(20),[biaoduanId]INT(20),[buildingId]INT(20),[buildingName]VARCHAR(255),[buildingType]VARCHAR(255),[fenqiId]INT(20),[inspectInstanceBuildingId]INT(20),[inspectInstanceId]INT(20),[isDelete]INT(11),[isInspect]INT(11),[zutuanId]INT(20))"];
        if (!createTable) {
            NSLog(@"standard创建失败");
        }
        else
        {
            NSLog(@"standard创建成功");
        }
    }
    // 检查项
    if(![[TSSQLiteTool sharedManager] tableExists:@"tb_inspect_item"])
    {
        createTable = [[TSSQLiteTool sharedManager] executeUpdate:@"CREATE TABLE  if not exists tb_inspect_item ([companyId]INT(20),[inspectBodyId]INT(20),[inspectItemDesc]VARCHAR(255),[inspectItemFatherId]INT(20),[inspectItemId]INT(20),[inspectItemLevel]INT(20),[inspectItemName]VARCHAR(255),[inspectItemType]VARCHAR(255),[inspectStandardId]INT(20),[inspectStandardItemId]INT(20),[isDelete]INT(11),[isLeaf]INT(11),[parentLevel1Id]INT(20),[parentLevel2Id]INT(20),[parentLevel3Id]INT(20),[subCompanyId]INT(20))"];
        if (!createTable)
        {
            NSLog(@"item创建失败");
        }
        else
        {
            NSLog(@"item创建成功");
        }
    }
    
    [[TSSQLiteTool sharedManager] close];
}

////将用户信息插入数据库
//- (void)insertUserInfoToSQLiteData
//{
//    
//}CREATE TABLE  if not exists [tb_projectlist](id int , userId int, treeId int,treeName varchar(128),treeType varchar(128),fatherTreeId int,downloadInstanceUrl varchar(256),inspectInstanceId INTEGER(100))

#pragma mark - 插入项目列表数据
- (void)insertProjectListData:(TSProjectListModel *)projectListModel withProjectInspectModel:(TSProjectInspectModel *)projectInspectModel
{
    if (![[TSSQLiteTool sharedManager] open]) {
        NSLog(@"打开数据库失败");
        return;
    }
    BOOL insert = NO;
    BOOL isRollBack = NO;
    
    [[TSSQLiteTool sharedManager] beginTransaction];

    @try
    {
        NSString *insertProjectInspectSql = [NSString stringWithFormat:@"INSERT INTO tb_projectlist ('userId','treeId','treeName','treeType','fatherTreeId','downloadInstanceUrl','inspectInstanceId') values ('%d','%d','%@','%@','%d','%@','%d')",projectInspectModel.userIds,projectListModel.treeId,projectListModel.treeName,projectListModel.treeType,projectListModel.fatherTreeId,projectInspectModel.downloadInstanceUrl,projectInspectModel.inspectInstanceId];
        insert = [[TSSQLiteTool sharedManager] executeUpdate:insertProjectInspectSql];
        
        if(!insert)
        {
            NSLog(@"inspectStandardSql插入失败");
        }

    }
    @catch (NSException *exception)
    {
        NSLog(@"数据库操作异常：%@",exception);
        isRollBack = YES;
        [[TSSQLiteTool sharedManager] rollback];
    }
    @finally
    {
        if (!isRollBack)
        {
            [[TSSQLiteTool sharedManager] commit];
        }
    }
    
    [[TSSQLiteTool sharedManager] close];
}


#pragma mark - 循环遍历文件夹
- (void)traversalFileWithTreeId:(int)treeId
{
    NSString *path = [self databasePathWithFileName:@"inspect"];
    NSLog(@"遍历文件夹---%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 读取txt文件
    NSArray *fileList = [[fileManager contentsOfDirectoryAtPath:path error:nil] pathsMatchingExtensions:[NSArray arrayWithObject:@"txt"]];
    NSLog(@"%@",fileList);
    //遍历txt文件
    for(int i = 0;i < fileList.count;i++)
    {
        NSLog(@"压缩包内文件：%@",fileList[i]);
        // 读取txt文本中的内容
        NSString *textFilePath = [path stringByAppendingPathComponent:fileList[i]];
        NSString *jsonString = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:jsonString];
        
        NSLog(@"--------------");
        
        NSArray *listArray = [NSArray arrayWithArray:dict[@"list"]];
        NSLog(@"--------------");
        
        if(((NSRange)[fileList[i] rangeOfString:@"inspectStandard"]).location != NSNotFound)
        {
            NSLog(@"插入检查标准数据：%d",i);
            [self insertDataWithArr:listArray type:inspectStandardType withTreeId:treeId];
            
        }
        else if (((NSRange)[fileList[i] rangeOfString:@"building"]).location != NSNotFound)
        {
            NSLog(@"插入楼栋数据：%d",i);
            [self insertDataWithArr:listArray type:buildingType withTreeId:treeId];
        }
        else if(((NSRange)[fileList[i] rangeOfString:@"inspectItem"]).location != NSNotFound)
        {
            NSLog(@"插入检查项数据：%d",i);
            [self insertDataWithArr:listArray type:inspectItemType withTreeId:treeId];
        }
    }
}

#pragma mark - 将数据插入到本地数据库中
- (void)insertDataWithArr:(NSArray *)arr type:(DataType)type withTreeId:(int)treeId
{
    if (![[TSSQLiteTool sharedManager] open]) {
        NSLog(@"打开数据库失败");
        return;
    }
    
    BOOL insert = NO;
    BOOL isRollBack = NO;
    
    [[TSSQLiteTool sharedManager] beginTransaction];

    @try
    {
        switch (type)
        {
            case inspectStandardType:       //插入检查标准数据
            {
                for (NSDictionary *oneInspectStandard in arr)
                {
                    TSInspectStandardModel *inspectStandardModel = [[TSInspectStandardModel alloc] init];
                    [inspectStandardModel setValuesForKeysWithDictionary:oneInspectStandard];
                    
                    NSString *inspectStandardSql = [NSString stringWithFormat:@"INSERT INTO tb_inspect_standard ('inspectInstanceId','inspectStandardId','inspectStandardName','isDelete') values ('%d','%d','%@','%d')",inspectStandardModel.inspectInstanceId,inspectStandardModel.inspectStandardId,inspectStandardModel.inspectStandardName,inspectStandardModel.isDelete];
                    insert = [[TSSQLiteTool sharedManager] executeUpdate:inspectStandardSql];
                    
                    if(!insert)
                    {
                        NSLog(@"inspectStandardSql插入失败");
                    }
                }
                
//                FMResultSet* resultSet = [[TSSQLiteTool sharedManager] executeQuery: @"select * from tb_inspect_standard" ];
//                
//                while ( [resultSet next ] )
//                {
//                    NSString* inspectStandardName = [ resultSet stringForColumn: @"inspectStandardName" ];
//                    NSLog( @"inspectStandardName: %@" , inspectStandardName);
//                }
                
            }
                break;
            case buildingType:           //插入楼栋数据
            {
                for (NSDictionary *oneBuilding in arr)
                {
                    TSBuildingModel *buildingModel = [[TSBuildingModel alloc] init];
                    [buildingModel setValuesForKeysWithDictionary:oneBuilding];
                    
                    NSString *buildSql = [NSString stringWithFormat:@"INSERT INTO tb_inspect_building ('treeId','biaoduanId','buildingId','buildingName','buildingType','fenqiId','inspectInstanceBuildingId','inspectInstanceId','isDelete','isInspect','zutuanId') VALUES ('%d','%d','%d','%@','%@','%d','%d','%d','%d','%d','%d')",treeId,buildingModel.biaoduanId,buildingModel.buildingId,buildingModel.buildingName,buildingModel.buildingType,buildingModel.fenqiId,buildingModel.inspectInstanceBuildingId,buildingModel.inspectInstanceId,buildingModel.isDelete,buildingModel.isInspect,buildingModel.zutuanId];
                    
                    insert = [[TSSQLiteTool sharedManager] executeUpdate:buildSql];
                    
                    if(!insert)
                    {
                        NSLog(@"inspectStandardSql插入失败");
                    }
                }
                
            }
                break;
            case inspectItemType:           //插入检查项数据
            {
                for (NSDictionary *oneInspectItem in arr)
                {
                    TSInspectItemModel *inspectItemModel = [[TSInspectItemModel alloc] init];
                    [inspectItemModel setValuesForKeysWithDictionary:oneInspectItem];
                    
                    NSString *insepctSql  = [NSString stringWithFormat:@"INSERT INTO tb_inspect_item ('companyId','inspectBodyId','inspectItemDesc','inspectItemFatherId','inspectItemId','inspectItemLevel','inspectItemName','inspectItemType','inspectStandardId','inspectStandardItemId','isDelete','isLeaf','parentLevel1Id','parentLevel2Id','parentLevel3Id','subCompanyId') VALUES ('%d','%d','%@','%d','%d','%d','%@','%@','%d','%d','%d','%d','%d','%d','%d','%d')", inspectItemModel.companyId, inspectItemModel.inspectBodyId,inspectItemModel.inspectItemDesc, inspectItemModel.inspectItemFatherId, inspectItemModel.inspectItemId, inspectItemModel.inspectItemLevel,inspectItemModel.inspectItemName, inspectItemModel.inspectItemType, inspectItemModel.inspectStandardId, inspectItemModel.inspectStandardItemId,inspectItemModel.isDelete, inspectItemModel.isLeaf, inspectItemModel.parentLevel1Id, inspectItemModel.parentLevel2Id, inspectItemModel.parentLevel3Id,inspectItemModel.subCompanyId];
                    insert = [[TSSQLiteTool sharedManager] executeUpdate:insepctSql];
                    
                    if(!insert)
                    {
                        NSLog(@"insepctSql插入 失败");
                    }
                }
            }
                break;
            default:
                break;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"数据库操作异常：%@",exception);
        isRollBack = YES;
        [[TSSQLiteTool sharedManager] rollback];
    }
    @finally
    {
        if (!isRollBack)
        {
            [[TSSQLiteTool sharedManager] commit];
        }
    }
    
    [[TSSQLiteTool sharedManager] close];
}

#pragma mark - 查询数据库里某个表
- (FMResultSet *)querySQLiteDataWithTable:(NSString *)tableName
{
    [[TSSQLiteTool sharedManager] open];
    
    FMResultSet* resultSet = [[TSSQLiteTool sharedManager] executeQuery:[NSString stringWithFormat: @"select * from %@",tableName]];
    
//    while ( [resultSet next ] )
//    {
//        int treeId = [ resultSet intForColumn: @"treeId" ];
//        NSLog( @"treeId: %d" , treeId);
//    }
    
//    [[TSSQLiteTool sharedManager] close];
    
    return resultSet;
    
}

//返回路径
+ (NSString *)databasePathWithFileName:(NSString *)fileName
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath=[path stringByAppendingPathComponent:fileName];
    NSLog(@"path:%@",path);
    return dbPath;
}
- (NSString *)databasePathWithFileName:(NSString *)fileName
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath=[path stringByAppendingPathComponent:fileName];
    NSLog(@"path:%@",path);
    return dbPath;
}


@end
