//
//  TLTableViewCellPositionBasedHeightCache.m
//
//  Created by ToccaLee on 25/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import "TLTableViewCellPositionBasedHeightCache.h"
#import "TLTableViewCellCacheConstants.h"

@interface TLTableViewCellPositionBasedHeightCache ()

@property (nonatomic, strong, readwrite) NSMutableArray<NSMutableArray<NSNumber *> *> *rowHeightCacheData;

@end

@implementation TLTableViewCellPositionBasedHeightCache

- (instancetype)init {
    if (self = [super init]) {
        _rowHeightCacheData = [NSMutableArray<NSMutableArray<NSNumber *> *>  new];
    }
    return self;
}

- (void)buildHeightCacheAtIndexPathsIfNeeded:(NSArray<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 0) {
        return;
    }
    for (NSIndexPath *indexPath in indexPaths) {
        NSAssert(indexPath.section >= 0, @"Expect a positive section");
        for (NSInteger section = 0; section <= indexPath.section; ++section) {
            if (section >= self.rowHeightCacheData.count) {
                [self.rowHeightCacheData insertObject:[NSMutableArray<NSNumber *> new]atIndex:section];
            }
        }
        NSMutableArray<NSNumber *> *rows = self.rowHeightCacheData[indexPath.section];
        for (NSInteger row = 0; row <= indexPath.row; ++row) {
            if (row >= rows.count) {
                [rows insertObject:@(kAutoHeightCellHeightCacheAbsentValue) atIndex:row];
            }
        }
        self.rowHeightCacheData[indexPath.section] = rows;
    }
}

- (BOOL)hasCachedHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildHeightCacheAtIndexPathsIfNeeded:@[indexPath]];
    CGFloat cachedHeight = self.rowHeightCacheData[indexPath.section][indexPath.row].floatValue;
    return cachedHeight != kAutoHeightCellHeightCacheAbsentValue;
}

- (void)cacheHeightForIndexPath:(NSIndexPath *)indexPath height:(CGFloat)height {
    [self buildHeightCacheAtIndexPathsIfNeeded:@[indexPath]];
    self.rowHeightCacheData[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)cachedHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildHeightCacheAtIndexPathsIfNeeded:@[indexPath]];
    return self.rowHeightCacheData[indexPath.section][indexPath.row].floatValue;
}

@end
