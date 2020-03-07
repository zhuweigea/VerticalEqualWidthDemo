//
//  ViewController.m
//  VerticalEqualWidthDemo
//
//  Created by 朱伟阁 on 2020/3/7.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import "ViewController.h"
#import "WaterfallFlowLayout.h"
#import "CollectionHeaderOrFooterView.h"
#import "CollectionViewCell.h"
#import "DataModel.h"
#import "WaterFallFlowViewModel.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterfallFlowLayoutDelegate>
@property (strong, nonatomic) WaterFallFlowViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[WaterFallFlowViewModel alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.viewModel getData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configCollectionView];
        });
    });
}

- (void)configCollectionView{
    //waterFallFlow
    WaterfallFlowLayout *flowlayout = [[WaterfallFlowLayout alloc] init];
    //可根据需求设置具体约束值
//    flowlayout.itemSpacing = 10;
//    flowlayout.lineSpacing = 10;
//    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    flowlayout.colCount = 4;
    flowlayout.delegate = self;
    
    UICollectionView *collect = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor orangeColor];
    
    [collect registerNib:[UINib nibWithNibName:@"ReuseView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [collect registerNib:[UINib nibWithNibName:@"ReuseView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];
    [collect registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collect];
}

#pragma mark collectionViewDatasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.viewModel.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld",[self.viewModel.dataArray[section] count]);
    return [self.viewModel.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellData:self.viewModel.dataArray[indexPath.section][indexPath.item]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionHeaderOrFooterView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        
        headerView.titalLab.text = [NSString stringWithFormat:@"header__%@",self.viewModel.nameArray[indexPath.section]];
        return headerView;
    }else{
        CollectionHeaderOrFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
        
        footerView.titalLab.text = [NSString stringWithFormat:@"footer__%@",self.viewModel.nameArray[indexPath.section]];
        return footerView;
    }
}

#pragma mark FJWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath
{
    DataModel * model = self.viewModel.dataArray[indexPath.section][indexPath.item];
    return model.h/model.w*width;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.view.frame), 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.view.frame), 40);
}

@end
