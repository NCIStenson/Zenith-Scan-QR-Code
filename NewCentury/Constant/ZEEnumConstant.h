//
//  ZEEnumConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#ifndef ZEEnumConstant_h
#define ZEEnumConstant_h

/*  登记工分选项 */
typedef NS_ENUM (NSInteger,POINT_REG){
    POINT_REG_TASK,
    POINT_REG_TIME,
    POINT_REG_WORKING_HOURS,
    POINT_REG_TYPE,
    POINT_REG_DIFF_DEGREE,
    POINT_REG_TIME_DEGREE,
    POINT_REG_JOB_ROLES,
    POINT_REG_JOB_COUNT,
};

/*  任务列表json等级 */
typedef NS_ENUM (NSInteger,TASK_LIST_LEVEL){
    TASK_LIST_LEVEL_NOJSON, //数组中没有包含json数据
    TASK_LIST_LEVEL_JSON    //数组中包含json数据
};

#endif /* ZEEnumConstant_h */
