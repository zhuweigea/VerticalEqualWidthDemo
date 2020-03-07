//
//  WaterFallFlowViewModel.h
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterFallFlowViewModel : NSObject
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *nameArray;
- (void)getData;
@end

NS_ASSUME_NONNULL_END
