//
//  TSProjectListModel.h
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSProjectListModel : NSObject

//@property (nonatomic, copy) NSDictionary *company;
//@property (nonatomic, copy) NSArray *projectList;
//@property (nonatomic, copy) NSDictionary *subCompanyList;

@property (nonatomic, assign) int buildingPropertiesId;
@property (nonatomic, assign) int fatherTreeId;
@property (nonatomic, assign) int isDelete;
@property (nonatomic, assign) int treeId;
@property (nonatomic, assign) int treeLevel;
@property (nonatomic, copy) NSString *treeName;
@property (nonatomic, copy) NSString *treeType;

@end
