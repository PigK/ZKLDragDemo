//
//  ZKLPicturesView.h
//  ZKLMoveDemo
//
//  Created by koudaishu on 2018/2/8.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKLPictureDelegate <NSObject>
//点击图片事件
- (void)pictureViewDidClickedPictureAtIndex:(NSInteger)index;
@end

@interface ZKLPicturesView : UIView

@property (nonatomic, assign) NSInteger maxCount;//最多显示图片数量 默认9张
@property (nonatomic, assign) NSInteger rowCount;//每行显示图片数量 默认3张

@property (nonatomic, assign) CGFloat margin;//上下左右边距 默认 = 15.0
@property (nonatomic, assign) CGFloat spacing;//图片之间的间距 默认 = 10.0

//@property (nonatomic, assign) BOOL canDrag;//是否可以拖拽图片

@property (nonatomic, weak) id <ZKLPictureDelegate> delegate;

- (NSUInteger)picturesCount;
- (NSUInteger)pictureButtonsCount;

- (void)addPictureWithImage:(UIImage *)image;
@end
