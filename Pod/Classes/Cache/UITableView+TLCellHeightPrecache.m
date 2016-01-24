//
//  UITableView+TLCellHeightPrecache.m
//
//  Created by ToccaLee on 15/9/2015.
//  Copyright © 2015. All rights reserved.
//

#import "UITableView+TLCellHeightPrecache.h"
#import "UITableView+TLHeightCache.h"
#import "TLTableViewCellPositionBasedHeightCache.h"
#import "TLTableViewCellContentBasedHeightCache.h"
#import "TLAutoHeightMacroDefine.h"

static char *const kRunLoopObserverKey          = "TLRunLoopObserverKey";
static char *const kUncachedIndexPathesKey      = "TLUncachedIndexPathesKey";

typedef NSMutableArray<NSIndexPath *> IndexPatchCache;

@interface UITableView ()

@property (nonatomic, assign) CFRunLoopObserverRef   runLoopObserver;
@property (nonatomic, strong) IndexPatchCache        *uncachedIndexPathes;

@end

@implementation UITableView (TLCellHeightPrecache)

- (CFRunLoopObserverRef)runLoopObserver {
    return (__bridge CFRunLoopObserverRef)(objc_getAssociatedObject(self, kRunLoopObserverKey));
}

- (void)setRunLoopObserver:(CFRunLoopObserverRef)runLoopObserver {
    objc_setAssociatedObject(self, kRunLoopObserverKey, (__bridge id)(runLoopObserver), OBJC_ASSOCIATION_RETAIN);
}

TL_OBJECT_ASSOCIATE(uncachedIndexPathes, setUncachedIndexPathes, IndexPatchCache *, [IndexPatchCache new], kUncachedIndexPathesKey);

- (IndexPatchCache *)findUncachedIndexPaths {
    IndexPatchCache *allUncachedIndexPaths = [IndexPatchCache new];
    NSUInteger sectionCount = self.numberOfSections;
    for (NSUInteger section = 0; section < sectionCount; ++section) {
        NSIndexPath *tmpIndexPath;
        NSUInteger rowCount = [self numberOfRowsInSection:section];
        for (NSUInteger row = 0; row < rowCount; ++row) {
            tmpIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            if (![self.TL_positionBasedCellHeightCache hasCachedHeightAtIndexPath:tmpIndexPath]) {
                [allUncachedIndexPaths addObject:tmpIndexPath];
            }
        }
    }
    return allUncachedIndexPaths;
}

- (void)precacheCellHeightForIndexPathIfNeeded:(NSIndexPath *)indexPath {
    if ([self.TL_positionBasedCellHeightCache hasCachedHeightAtIndexPath:indexPath]) {
        return;
    }
    if (indexPath.section > self.numberOfSections ||
        indexPath.row > [self numberOfRowsInSection:indexPath.section]) {
        return;
    }
    CGFloat height = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    [self.TL_positionBasedCellHeightCache cacheHeightForIndexPath:indexPath height:height];
}

- (BOOL)hasStartedPrecache {
    return self.runLoopObserver != nil;
}

- (void)TL_precacheIfNeeded {
    if (self.TL_heightCachePolicy != TLCellHeightCachePolicyPosition) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return;
    }
    self.uncachedIndexPathes = [self findUncachedIndexPaths];
    if ([self hasStartedPrecache]) {
        return;
    }
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFStringRef runLoopMode = kCFRunLoopDefaultMode;
    __weak typeof(self) weakSelf = self;
    self.runLoopObserver = CFRunLoopObserverCreateWithHandler
    (kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        if (weakSelf.uncachedIndexPathes.count == 0) {
            CFRunLoopRemoveObserver(runLoop, observer, runLoopMode);
            weakSelf.runLoopObserver = nil;
            CFRelease(observer);
            return;
        }
        NSIndexPath *indexPath = weakSelf.uncachedIndexPathes.firstObject;
        [weakSelf.uncachedIndexPathes removeObject:indexPath];
        [self performSelector:@selector(precacheCellHeightForIndexPathIfNeeded:)
                     onThread:[NSThread mainThread]
                   withObject:indexPath
                waitUntilDone:NO
                        modes:@[NSDefaultRunLoopMode]];
    });
    CFRunLoopAddObserver(runLoop, self.runLoopObserver, runLoopMode);
}

@end
