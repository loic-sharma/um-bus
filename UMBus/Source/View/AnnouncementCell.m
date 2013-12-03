//
//  AnnouncementCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementCell.h"
#import "AnnouncementCellModel.h"
#import "Announcement.h"

@interface AnnouncementCell ()

@property (nonatomic, strong) IBOutlet UILabel *announcementLabel;

@end

@implementation AnnouncementCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        RAC(self, announcementLabel.text) = RACObserve(self, model.announcement.text);
        
        [RACObserve(self, model.announcement.text) subscribeNext:^(NSString *text) {
            if (text) {
                self.announcementLabel.text = text;
                
                [self updateLabelHeight];
            }
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateLabelHeight {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.model.announcement.text
                                                                         attributes:@{NSFontAttributeName: self.announcementLabel.font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.announcementLabel.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    CGRect newFrame = self.announcementLabel.frame;
    newFrame.size.height = rect.size.height;
    self.announcementLabel.frame = newFrame;
}

@end
