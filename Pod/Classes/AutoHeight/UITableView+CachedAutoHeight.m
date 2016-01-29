//
//  UITableView+CachedAutoHeight.m
//
//  Created by ToccaLee on 25/10/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import "UITableView+CachedAutoHeight.h"
#import "TLTableViewCellPositionBasedHeightCache.h"
#import "TLTableViewCellContentBasedHeightCache.h"
#import "UITableView+TLCellHeightPrecache.h"
#import "TLTableViewCellCacheConstants.h"
#import "UITableView+TLAutoHeight.h"
#import "UITableView+TLHeightCache.h"
#import "TLAutoHeightMacroDefine.h"

static char *const kPrecacheEnabledKey  = "TLPrecacheEnabledKey";

@interface UITableView ()

@property (nonatomic, assign) BOOL isPrecacheEnabled;

@end

@implementation UITableView (CachedAutoHeight)

TL_BOOL_ASSOCIATE(isPrecacheEnabled, setIsPrecacheEnabled, false, kPrecacheEnabledKey)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(reloadData),
            @selector(insertSections:withRowAnimation:),
            @selector(deleteSections:withRowAnimation:),
            @selector(reloadSections:withRowAnimation:),
            @selector(moveSection:toSection:),
            @selector(insertRowsAtIndexPaths:withRowAnimation:),
            @selector(deleteRowsAtIndexPaths:withRowAnimation:),
            @selector(reloadRowsAtIndexPaths:withRowAnimation:),
            @selector(moveRowAtIndexPath:toIndexPath:)
        };
        
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"TL_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)TL_reloadData {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [self.TL_positionBasedCellHeightCache.rowHeightCacheData removeAllObjects];
        [self TL_precacheIfNeeded];
    }
    [self TL_reloadData];
}

- (void)TL_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            [self.TL_positionBasedCellHeightCache.rowHeightCacheData insertObject:@[].mutableCopy atIndex:index];
        }];
        [self TL_precacheIfNeeded];
    }
    [self TL_insertSections:sections withRowAnimation:animation];
}

- (void)TL_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            [self.TL_positionBasedCellHeightCache.rowHeightCacheData removeObjectAtIndex:index];
        }];
    }
    [self TL_deleteSections:sections withRowAnimation:animation];
}

- (void)TL_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
            if (idx < self.TL_positionBasedCellHeightCache.rowHeightCacheData.count) {
                NSMutableArray *rows = self.TL_positionBasedCellHeightCache.rowHeightCacheData[idx];
                for (NSInteger row = 0; row < rows.count; ++row) {
                    rows[row] = @(kAutoHeightCellHeightCacheAbsentValue);
                }
            }
        }];
        [self TL_precacheIfNeeded];
    }
    [self TL_reloadSections:sections withRowAnimation:animation];
}

- (void)TL_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        NSInteger sectionCount = self.TL_positionBasedCellHeightCache.rowHeightCacheData.count;
        if (section < sectionCount && newSection < sectionCount) {
            [self.TL_positionBasedCellHeightCache.rowHeightCacheData exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }
    }
    [self TL_moveSection:section toSection:newSection];
}

- (void)TL_insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [self.TL_positionBasedCellHeightCache buildHeightCacheAtIndexPathsIfNeeded:indexPaths];
        for (NSIndexPath *indexPath in indexPaths) {
            NSMutableArray *rows = self.TL_positionBasedCellHeightCache.rowHeightCacheData[indexPath.section];
            [rows insertObject:@(kAutoHeightCellHeightCacheAbsentValue) atIndex:indexPath.row];
        }
        [self TL_precacheIfNeeded];
    }
    [self TL_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)TL_deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [self.TL_positionBasedCellHeightCache buildHeightCacheAtIndexPathsIfNeeded:indexPaths];
        NSMutableDictionary *rowsToDelete = @{}.mutableCopy;
        for (NSIndexPath *indexPath in indexPaths) {
            NSMutableIndexSet *mutableIndexSet = rowsToDelete[@(indexPath.section)];
            if (!mutableIndexSet) {
                rowsToDelete[@(indexPath.section)] = [NSMutableIndexSet indexSet];
            }
            [mutableIndexSet addIndex:indexPath.row];
        }
        [rowsToDelete enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
            NSMutableArray *rows = self.TL_positionBasedCellHeightCache.rowHeightCacheData[key.integerValue];
            [rows removeObjectsAtIndexes:indexSet];
        }];
    }
    [self TL_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)TL_reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [self.TL_positionBasedCellHeightCache buildHeightCacheAtIndexPathsIfNeeded:indexPaths];
        for (NSIndexPath *indexPath in indexPaths) {
            NSMutableArray *rows = self.TL_positionBasedCellHeightCache.rowHeightCacheData[indexPath.section];
            rows[indexPath.row] = @(kAutoHeightCellHeightCacheAbsentValue);
        }
        [self TL_precacheIfNeeded];
    }
    [self TL_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)TL_moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyPosition) {
        [self.TL_positionBasedCellHeightCache buildHeightCacheAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
        NSMutableArray *sourceRows = self.TL_positionBasedCellHeightCache.rowHeightCacheData[sourceIndexPath.section];
        NSMutableArray *destinationRows = self.TL_positionBasedCellHeightCache.rowHeightCacheData[destinationIndexPath.section];
        NSNumber *sourceValue = sourceRows[sourceIndexPath.row];
        NSNumber *destinationValue = destinationRows[destinationIndexPath.row];
        sourceRows[sourceIndexPath.row] = destinationValue;
        destinationRows[destinationIndexPath.row] = sourceValue;
    }
    [self TL_moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(NSString *)identifier
                                        indexPath:(NSIndexPath *)indexPath
                                    configuration:(void (^)(id cell))configuration {
    NSParameterAssert(identifier);
    NSParameterAssert(indexPath);
    NSAssert(self.TL_heightCachePolicy != TLCellHeightCachePolicyContent, @"Should set cache policy to TLAutoHeightCachePolicyPosition");
    
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyNone) {
        self.TL_heightCachePolicy = TLCellHeightCachePolicyPosition;
    }
    
    if (!self.isPrecacheEnabled) {
        self.isPrecacheEnabled = YES;
        [self TL_precacheIfNeeded];
    }
    
    if ([self.TL_positionBasedCellHeightCache hasCachedHeightAtIndexPath:indexPath]) {
        return [self.TL_positionBasedCellHeightCache cachedHeightAtIndexPath:indexPath];
    }
    
    CGFloat height = [self TL_autoHeightForCellWithIdentifer:identifier configuration:configuration];
    [self.TL_positionBasedCellHeightCache cacheHeightForIndexPath:indexPath height:height];
    return height;
}

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(NSString *)identifier
                                         modelKey:(id)modelKey
                                    configuration:(void (^)(id _Nonnull))configuration {
    return [self TL_autoHeightForCellWithReuseIdentifer:identifier modelKey:modelKey heightAffectedProperties:nil configuration:configuration];
}

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(NSString *)identifier
                                         modelKey:(id)modelKey
                         heightAffectedProperties:(NSArray<id> *)properties
                                    configuration:(void (^)(id cell))configuration {
    NSParameterAssert(identifier);
    NSParameterAssert(modelKey);
    NSAssert(self.TL_heightCachePolicy != TLCellHeightCachePolicyPosition, @"Should set cache policy to TLAutoHeightCachePolicyContent");
    
    if (self.TL_heightCachePolicy == TLCellHeightCachePolicyNone) {
        self.TL_heightCachePolicy = TLCellHeightCachePolicyContent;
    }
    
    if ([self.TL_contentBasedCellHeightCache hasCachedHeightForIdentifier:identifier modelKey:modelKey heightAffectedProperties:properties]) {
        return [self.TL_contentBasedCellHeightCache cachedHeightWithIdentifier:identifier modelKey:modelKey heightAffectedProperties:properties];
    }
    
    CGFloat height = [self TL_autoHeightForCellWithIdentifer:identifier configuration:configuration];
    [self.TL_contentBasedCellHeightCache cacheHeightForIdentifier:identifier modelKey:modelKey heightAffectedProperties:properties height:height];
    return height;
}

@end
