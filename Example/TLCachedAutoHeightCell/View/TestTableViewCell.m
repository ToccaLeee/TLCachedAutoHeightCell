//
//  TestTableViewCell.m
//
//  Created by ToccaLee on 23/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *fixContentLabel;

@end

@implementation TestTableViewCell

- (void)setModel:(Model *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.fixContentLabel.text = model.fixedContent;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
