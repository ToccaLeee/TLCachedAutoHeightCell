//
//  ContentGenerator.m
//
//  Created by ToccaLee on 23/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import "ContentGenerator.h"

@implementation ContentGenerator

+ (NSArray<Model *> *)testModelWithCount:(NSUInteger)count {
    Model *model;
    NSMutableArray<Model *> *models = [NSMutableArray<Model *> new];
    for (NSInteger index = 0; index < count; ++index) {
        model = [Model new];
        model.modelId = index;
        model.title = [self randomTitle];
        model.content = [self randomContent];
        model.fixedContent = @"I am fixed content";
        [models addObject:model];
    }
    return models.copy;
}

+ (NSString *)randomTitle {
    NSInteger random = arc4random() % 20;
    NSMutableString *content = [NSMutableString new];
    [content appendString:@"Test Title: "];
    for (NSInteger index = 0; index < random; ++index) {
        [content appendString:@" title"];
    }
    return content;
}

+  (NSString *)randomContent {
    NSInteger random = arc4random() % 200;
    NSMutableString *content = [NSMutableString new];
    [content appendString:@"Test Content: "];
    for (NSInteger index = 0; index < random; ++index) {
        [content appendString:@" Hi"];
    }
    return content;
}

@end
