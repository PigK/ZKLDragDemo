//
//  ZKLPictureButton.h
//  ZKLMoveDemo
//
//  Created by koudaishu on 2018/2/8.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PictureButtonDidCLicked)(void);
typedef void(^PictureButtonDidCLickedDeleteButton)(void);

@interface ZKLPictureButton : UIButton
@property (nonatomic, assign) BOOL isAddBtn;

@property (nonatomic, copy) PictureButtonDidCLicked clickedPictureBlock;
@property (nonatomic, copy) PictureButtonDidCLickedDeleteButton deleteBlock;
@end
