//
//  TLContentCacheViewController.m
//
//  Created by ToccaLee on 23/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import "TLContentCacheViewController.h"
#import "TLCachedAutoHeightCell.h"
#import "TestTableViewCell.h"
#import "ContentGenerator.h"

@interface TLContentCacheViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation TLContentCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TestTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TestTableViewCell class])];
    
    UIBarButtonItem *reloadBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem = reloadBarButtonItem;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TestTableViewCell class])];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView TL_autoHeightForCellWithReuseIdentifer:NSStringFromClass([TestTableViewCell class])
                                                    modelKey:@(self.models[indexPath.row].modelId)
                                    heightAffectedProperties:@[self.models[indexPath.row].title, self.models[indexPath.row].content]
                                               configuration:^(TestTableViewCell  *cell) {
                                                    cell.model = self.models[indexPath.row];
                                               }];
}

@end
