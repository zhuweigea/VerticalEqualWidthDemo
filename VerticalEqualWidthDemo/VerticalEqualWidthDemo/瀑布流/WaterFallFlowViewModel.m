//
//  WaterFallFlowViewModel.m
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import "WaterFallFlowViewModel.h"
#import <MJExtension/MJExtension.h>
#import "DataModel.h"

@implementation WaterFallFlowViewModel
- (instancetype)init{
    self = [super init];
    if(self){
        self.dataArray = [NSArray array];
        self.nameArray = [NSArray array];
    }
    return self;
}
- (void)getData{
    NSArray *plistOneArray = [DataModel mj_objectArrayWithFilename:@"商店商品1.plist"];
    NSArray *plistTwoArray = [DataModel mj_objectArrayWithFilename:@"商店商品2.plist"];
    NSArray *plistThreeArray = [DataModel mj_objectArrayWithFilename:@"商店商品3.plist"];
    self.dataArray = @[plistOneArray,plistTwoArray,plistThreeArray];
    self.nameArray = @[@"商店商品1.plist",@"商店商品2.plist",@"商店商品3.plist"];
}
@end
