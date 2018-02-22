//
//  ZKLPicturesView.m
//  ZKLMoveDemo
//
//  Created by koudaishu on 2018/2/8.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import "ZKLPicturesView.h"
#import "ZKLPictureButton.h"

@interface ZKLPicturesView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *pictureBtnArr;

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ZKLPicturesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maxCount = 9;
        self.rowCount = 3;
        
        self.margin   = 15.0;
        self.spacing  = 10.0;
        
        [self addAddPictureButton];
    }
    return self;
}

//添加图片
- (void)addPictureWithImage:(UIImage *)image {
    if (self.pictureBtnArr.count == self.maxCount && ![self.pictureBtnArr.lastObject isAddBtn]) return;
    
    ZKLPictureButton *btn = (ZKLPictureButton *)self.pictureBtnArr.lastObject;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.isAddBtn = NO;
    
    if ([self picturesCount] == self.maxCount) return;

    [self addAddPictureButton];
}

//添加 添加图片的按钮
- (void)addAddPictureButton {
    CGRect frame = [self pictureButtonFrameWithIndex:self.pictureBtnArr.count];
    ZKLPictureButton *addBtn = [[ZKLPictureButton alloc] initWithFrame:frame];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(addBtn) weakBtn = addBtn;
    
    addBtn.clickedPictureBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pictureViewDidClickedPictureAtIndex:)]) {
            [weakSelf.delegate pictureViewDidClickedPictureAtIndex:[weakSelf.pictureBtnArr indexOfObject:weakBtn]];
        }
    };
    
    addBtn.deleteBlock = ^{
        [weakSelf deletePictureWithIndex:[weakSelf.pictureBtnArr indexOfObject:weakBtn]];
    };
    
    //手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(longPressGR:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.15;
    [addBtn addGestureRecognizer:longPress];
    
    [self.pictureBtnArr addObject:addBtn];
    [self addSubview:addBtn];
}

//删除图片
- (void)deletePictureWithIndex:(NSInteger)index {
    ZKLPictureButton *btn = (ZKLPictureButton *)self.pictureBtnArr[index];
    [btn removeFromSuperview];
    [self.pictureBtnArr removeObjectAtIndex:index];
    [self layoutViewFromIndex:index animation:NO];
    if ([self picturesCount] == self.maxCount-1) {
        [self addAddPictureButton];
    }
}

- (NSUInteger)picturesCount {
    if ([self.pictureBtnArr.lastObject isAddBtn]) {
        return self.pictureBtnArr.count-1;
    }else {
        return self.pictureBtnArr.count;
    }
}

- (NSUInteger)pictureButtonsCount {
    return self.pictureBtnArr.count;
}

- (void)layoutViewFromIndex:(NSInteger)index animation:(BOOL)animation {
    if (animation) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf layoutViewFromIndex:index];
        }];
    }else {
        [self layoutViewFromIndex:index];
    }
}

- (void)layoutButtonsExceptAtIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        for (NSInteger i = 0; i<weakSelf.pictureBtnArr.count; i++) {
            if (i == index) continue;
            [weakSelf layoutViewAtIndex:i];
        }
    }];
}

- (void)layoutViewFromIndex:(NSInteger)index {
    for (NSInteger i = index; i<self.pictureBtnArr.count; i++) {
        [self layoutViewAtIndex:i];
    }
}

- (void)layoutViewAtIndex:(NSInteger)index {
    ZKLPictureButton *btn = (ZKLPictureButton *)self.pictureBtnArr[index];
    CGRect frame = [self pictureButtonFrameWithIndex:index];
    btn.frame = frame;
}

//图片frame
- (CGRect)pictureButtonFrameWithIndex:(NSInteger)index {
    CGFloat sizeW = (self.frame.size.width - self.margin*2 - self.spacing*(self.rowCount-1))/self.rowCount;
    CGFloat sizeH = sizeW;
    
    CGFloat buttonX = (index%self.rowCount)*(self.spacing+sizeW) + self.margin;
    CGFloat buttonY = (index/self.rowCount)*(self.spacing+sizeH) + self.margin;
    
    return CGRectMake(buttonX, buttonY, sizeW, sizeH);
}

//移动手势
- (void)longPressGR:(UILongPressGestureRecognizer *)sender {
    ZKLPictureButton *btn = (ZKLPictureButton *)sender.view;
    if ([btn isAddBtn]) return;
    self.centerPoint = btn.center;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self longPressGestureRecognizerBeganWithLongPress:sender dragBtn:btn];
            break;
        case UIGestureRecognizerStateChanged:
            [self longPressGestureRecognizerChangedWithLongPress:sender dragBtn:btn];
            break;
        case UIGestureRecognizerStateEnded:
            [self longPressGestureRecognizerEnded];
            break;
        default:
            break;
    }
}

- (void)longPressGestureRecognizerBeganWithLongPress:(UILongPressGestureRecognizer *)sender dragBtn:(ZKLPictureButton *)btn {
    self.originPoint = self.centerPoint;
    self.startPoint = [sender locationInView:self];
    self.selectedIndex = [self.pictureBtnArr indexOfObject:btn];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat margin = weakSelf.spacing/2;
        CGRect frame = btn.frame;
        btn.frame = CGRectMake(frame.origin.x-margin,
                               frame.origin.y-margin,
                               frame.size.width+weakSelf.spacing,
                               frame.size.height+weakSelf.spacing);
        btn.alpha = 0.7;
    }];
}

- (void)longPressGestureRecognizerChangedWithLongPress:(UILongPressGestureRecognizer *)sender dragBtn:(ZKLPictureButton *)btn {
    CGPoint point = [sender locationInView:self];
    CGPoint center = self.originPoint;
    center.x += point.x - self.startPoint.x;
    center.y += point.y - self.startPoint.y;
    btn.center = center;
    
    CGFloat sizeW = (self.frame.size.width - self.margin*2 - self.spacing*(self.rowCount-1))/self.rowCount;
    CGFloat sizeH = sizeW;
    NSUInteger indexX = (center.x - self.margin)/(sizeW + self.spacing);
    NSUInteger indexY = (center.y - self.margin)/(sizeH + self.spacing);
    NSUInteger index  = indexX + indexY*self.rowCount;
    
    if (index >= self.pictureBtnArr.count-1) {
        if ([self.pictureBtnArr.lastObject isAddBtn]) {
            index = self.pictureBtnArr.count - 2;
        }else {
            index = self.pictureBtnArr.count - 1;
        }
    }
    if (index != self.selectedIndex) {
        self.selectedIndex = index;
        [self.pictureBtnArr removeObject:btn];
        [self.pictureBtnArr insertObject:btn atIndex:index];
        [self layoutButtonsExceptAtIndex:index];
    }
}

- (void)longPressGestureRecognizerEnded {
    [self layoutViewAtIndex:self.selectedIndex];
    ZKLPictureButton *btn = self.pictureBtnArr[self.selectedIndex];
    btn.alpha = 1;
}

#pragma mark - getters & setters
- (NSMutableArray *)pictureBtnArr {
    if (!_pictureBtnArr) {
        _pictureBtnArr  = [[NSMutableArray alloc] init];
    }
    return _pictureBtnArr;
}
@end
