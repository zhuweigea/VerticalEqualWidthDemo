//
//  ZWGDataModel.h
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@end

NS_ASSUME_NONNULL_END
