//
//  TSProjectModel.h
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSProjectInspectModel : NSObject

@property (nonatomic, assign) int buildingIds;
@property (nonatomic, copy) NSString *buildingNames;
@property (nonatomic, assign) int companyId;
@property (nonatomic, assign) int createUserId;

@property (nonatomic, copy) NSString *downloadInstanceUrl;

@property (nonatomic, assign) NSDate *inspectCloseDate;
//@property (nonatomic, assign) long inspectCreateDate;
//@property (nonatomic, assign) long inspectEndDate;
@property (nonatomic, assign) int inspectInstanceId;
@property (nonatomic, copy) NSString *inspectInstanceName;
@property (nonatomic, assign) int inspectProjectId;
@property (nonatomic, assign) int inspectStandardId;
@property (nonatomic, copy) NSString *inspectStandardNames;
//@property (nonatomic, assign) long inspectStartDate;
@property (nonatomic, assign) int inspectTypeId;
@property (nonatomic, copy) NSString *inspectTypeName;
//@property (nonatomic, assign) long inspectUpdateDate;
//@property (nonatomic, assign) long inspectUpdateTime;
@property (nonatomic, assign) int isDelete;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, assign) int subCompanyId;
@property (nonatomic, assign) int userIds;
@property (nonatomic, copy) NSString *userNames;

@end
