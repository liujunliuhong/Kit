//
//  YHImageBrowserView.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserView.h"
#import "YHImageBrowserViewDataSource.h"
#import "YHImageBrowserCellProtocol.h"
#import "YHImageBrowserCollectionViewFlowLayout.h"

@interface YHImageBrowserView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) CGSize containerSize;
@property (nonatomic, strong) NSCache *dataCache;

@property (nonatomic, assign) NSUInteger cacheCountLimit;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) YHImageBrowserLayoutDirection layoutDirection;

@property (nonatomic, strong) NSMutableSet *reuseIdentifierSet;
@end

@implementation YHImageBrowserView

- (void)dealloc
{
    self.dataCache = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[YHImageBrowserCollectionViewFlowLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.cacheCountLimit = 8;
        self.reuseIdentifierSet = [NSMutableSet set];
        self.currentIndex = NSUIntegerMax;
        
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor orangeColor];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)updateLayoutWithDirection:(YHImageBrowserLayoutDirection)direction containerSize:(CGSize)containerSize{
    self.containerSize = containerSize;
    self.layoutDirection = direction;
    self.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
    
    NSArray<UICollectionViewCell<YHImageBrowserCellProtocol> *> *cells = [self visibleCells];
    [cells enumerateObjectsUsingBlock:^(UICollectionViewCell<YHImageBrowserCellProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(yh_browserLayoutDirectionChanged:containerSize:)]) {
            [obj yh_browserLayoutDirectionChanged:self.layoutDirection containerSize:self.containerSize];
        }
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (id<YHImageBrowserCellDataProtocol>)dataAtIndex:(NSUInteger)index {
    if (index < 0 || index >= [self.yh_dataSource yh_numberOfCellForImageBrowserView:self]) return nil;
    
    id<YHImageBrowserCellDataProtocol> data;
    if (self.dataCache && [self.dataCache objectForKey:@(index)]) {
        data = [self.dataCache objectForKey:@(index)];
    } else {
        data = [self.yh_dataSource yh_imageBrowserView:self dataForCellAtIndex:index];
        [self.dataCache setObject:data forKey:@(index)];
    }
    return data;
}


#pragma mark ------------------ UICollectionViewDataSource ------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.yh_dataSource yh_numberOfCellForImageBrowserView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id<YHImageBrowserCellDataProtocol> data = [self dataAtIndex:indexPath.item];
    
    Class cellClass = [data yh_cellClass];
    
    NSString *identifier = NSStringFromClass(cellClass);
    
    
    if (![self.reuseIdentifierSet containsObject:identifier]) {
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        [self.reuseIdentifierSet addObject:identifier];
    }
    
    UICollectionViewCell<YHImageBrowserCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSLog(@"😆%@", cell);
    
    
    [cell yh_browserSetInitialCellData:data layoutDirection:self.layoutDirection containerSize:self.containerSize];
    
    
    return cell;
}

#pragma mark ------------------ UIScrollViewDelegate ------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat indexF = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSUInteger index = (NSUInteger)(indexF + 0.5);
    NSLog(@"🈶page:%d", (int)index);
    if (index >= [self.yh_dataSource yh_numberOfCellForImageBrowserView:self] || index < 0) {
        return;
    }
    if (self.currentIndex != index) {
        self.currentIndex = index;
        
    }
}


#pragma mark ------------------ Getter ------------------
- (NSCache *)dataCache{
    if (!_dataCache) {
        _dataCache = [[NSCache alloc] init];
        _dataCache.countLimit = self.cacheCountLimit;
    }
    return _dataCache;
}

@end
