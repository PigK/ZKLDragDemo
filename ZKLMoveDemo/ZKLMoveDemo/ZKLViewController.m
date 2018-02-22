//
//  ZKlViewController.m
//  ZKLMoveDemo
//
//  Created by koudaishu on 2018/2/8.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import "ZKLViewController.h"
#import "ZKLPicturesView.h"

@interface ZKLViewController ()<ZKLPictureDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) ZKLPicturesView *pictureView;
@property (nonatomic, strong) UIImagePickerController *picker;
@end

@implementation ZKLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pictureView];
}

- (void)selectPhoto {
    __weak typeof(self) weakSelf = self;
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:@"选择照片"
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [vc addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showAlbum];
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showAlbum {
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.pictureView addPictureWithImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - pictureview delegate
- (void)pictureViewDidClickedPictureAtIndex:(NSInteger)index {
    if (index == [self.pictureView picturesCount]) {
        [self selectPhoto];
    }else {
        NSLog(@"%ld",index);
    }
}

#pragma mark - getters & setters
- (ZKLPicturesView *)pictureView {
    if (!_pictureView) {
        
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        
        _pictureView = [[ZKLPicturesView alloc] initWithFrame:frame];
        _pictureView.delegate = self;
    }
    return _pictureView;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.allowsEditing = YES;
        _picker.delegate = self;
    }
    return _picker;
}
@end
