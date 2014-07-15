//
//  APIMarco.h
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#ifndef ProInspection_APIMarco_h
#define ProInspection_APIMarco_h

#define Domain @"http://192.168.1.234:8081"

//登陆接口
#define Login_URL Domain"/inspect/app/user/login.do"
//获取项目列表接口
#define GetProjectList_URL Domain"/inspect/app/instance/getProjectList.do"
//下载项目信息
#define GetProjectInfo_URL Domain"/inspect/app/instance/createInstance.do"


#endif
