//
//  TLMenuViewController.m
//
//  Created by ToccaLee on 20/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import "TLMenuViewController.h"
#import "TLNoneCacheViewController.h"
#import "TLPositionCacheViewController.h"
#import "TLContentCacheViewController.h"
#import "ContentGenerator.h"

@interface TLMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<Model *> *models;

@end

@implementation TLMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.models = [ContentGenerator testModelWithCount:100];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"NoCacheAutoHeightDemo";
            break;
        case 1:
            cell.textLabel.text =@"PositionBasedCacheAutoHeightDemo";
            break;
        default:
            cell.textLabel.text = @"ContentBasedCacheAutoHeightDemo";
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc;
    if (indexPath.row == 0) {
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"TLNoneCacheViewController"];
    } else if (indexPath.row == 1) {
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"TLPositionCacheViewController"];
    }else if (indexPath.row == 2) {
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"TLContentCacheViewController"];
    }
    [vc setValue:self.models forKey:@"models"];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
