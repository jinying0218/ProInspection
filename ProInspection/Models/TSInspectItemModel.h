//
//  TSInspectItemModel.h
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSInspectItemModel : NSObject

@property (nonatomic,assign) int companyId;
@property (nonatomic,assign) int inspectBodyId;
@property (nonatomic,copy) NSString *inspectItemDesc;
@property (nonatomic,assign) int inspectItemFatherId;
@property (nonatomic,assign) int inspectItemId;
@property (nonatomic,assign) int inspectItemLevel;
@property (nonatomic,copy) NSString *inspectItemName;
@property (nonatomic,copy) NSString *inspectItemType;
@property (nonatomic,assign) int inspectStandardId;
@property (nonatomic,assign) int inspectStandardItemId;
@property (nonatomic,assign) int isDelete;
@property (nonatomic,assign) int isLeaf;
@property (nonatomic,assign) int parentLevel1Id;
@property (nonatomic,assign) int parentLevel2Id;
@property (nonatomic,assign) int parentLevel3Id;
@property (nonatomic,assign) int subCompanyId;

@end
