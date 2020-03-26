//
//  LogTableViewCell.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/25.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "LogTableViewCell.h"

@interface LogTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *logDataTimeInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *logDescriptionLabel;


@end

@implementation LogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setApperance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setApperance {
    [self setAppearanceForLogDataTimeInformationLabel];
    [self setAppearanceForLogDescriptionLabel];
}

- (void)setAppearanceForLogDataTimeInformationLabel {
    [self.logDataTimeInformationLabel setFont:[UIFont systemFontOfSize:20]];
    self.logDataTimeInformationLabel.textColor = [UIColor colorWithRed:51.0f / 255.0f
                                                                 green:51.0f / 255.0f
                                                                  blue:51.0f / 255.0f
                                                                 alpha:1.0f];
}

- (void)setAppearanceForLogDescriptionLabel {
    [self.logDescriptionLabel setFont:[UIFont systemFontOfSize:20]];
    self.logDescriptionLabel.textColor = [UIColor colorWithRed:51.0f / 255.0f
                                                         green:51.0f / 255.0f
                                                          blue:51.0f / 255.0f
                                                         alpha:1.0f];
    self.logDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.logDescriptionLabel.numberOfLines = 0;
    [self.logDescriptionLabel sizeToFit];
    [self.logDescriptionLabel layoutIfNeeded];
}

- (void)setValues:(LogDataModel *)log{
    _logDataTimeInformationLabel.text = log.timestamp;
    _logDescriptionLabel.text = log.logDescription;
}

@end
