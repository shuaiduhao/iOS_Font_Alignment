//
//  VerticallyAlignedLabel.h
//  iOS_字体
//
//  Created by ds.sunagy on 2018/5/10.
//  Copyright © 2018年 ds.sunagy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel
{
     @private VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@end
