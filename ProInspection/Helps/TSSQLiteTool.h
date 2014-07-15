//
//  TSSQLiteTool.h
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "FMDB.h"
#import "TSProjectInspectModel.h"
#import "TSProjectListModel.h"

@interface TSSQLiteTool : FMDatabase

+ (TSSQLiteTool *)sharedManager;

- (void)createSQLiteData;
- (void)traversalFileWithTreeId:(int)treeId;

- (void)insertProjectListData:(TSProjectListModel *)projectListModel withProjectInspectModel:(TSProjectInspectModel *)projectInspectModel;
- (FMResultSet *)querySQLiteDataWithTable:(NSString *)tableName;
@end
