//
//  ZKLPictureButton.m
//  ZKLMoveDemo
//
//  Created by koudaishu on 2018/2/8.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import "ZKLPictureButton.h"

@interface ZKLPictureButton ()
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation ZKLPictureButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.deleteBtn];
        
        self.isAddBtn = YES;
        self.contentVerticalAlignment   = UIControlContentVerticalAlignmentFill;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        
        [self setBackgroundImage:[UIImage imageNamed:@"icon_add"]
                        forState:UIControlStateNormal];
        
        [self addTarget:self
                 action:@selector(didClickedPictureBtn)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - click event
- (void)didClickedPictureBtn {
    if (self.clickedPictureBlock) {
        self.clickedPictureBlock();
    }
}

- (void)didCLickedDeleteBtn {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - getters & setters
- (void)setIsAddBtn:(BOOL)isAddBtn {
    _isAddBtn = isAddBtn;
    self.deleteBtn.hidden = _isAddBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(0, 0, 25, 25);
        
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_delete"]
                              forState:UIControlStateNormal];
        [_deleteBtn addTarget:self
                       action:@selector(didCLickedDeleteBtn)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
