//
//  TZPhotoPreviewController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZPhotoPreviewController.h"
#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZImageCropManager.h"

@interface TZPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView * _collectionView;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_doneButton;

    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@end

@implementation TZPhotoPreviewController

+(TZPhotoPreviewController *)newinstance:(CGRect)cgrect {
    TZPhotoPreviewController * tzp = [[TZPhotoPreviewController alloc]init];
    tzp.cropRect = cgrect;
    return tzp;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self configDefaultBtnTitle];
    [self configDefaultImageName];
    [TZImageManager manager].shouldFixOrientation = YES;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)weakSelf.navigationController;
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_tzImagePickerVc.selectedModels];
        _assetsTemp = [NSMutableArray arrayWithArray:_tzImagePickerVc.selectedAssets];
        self.isSelectOriginalPhoto = _tzImagePickerVc.isSelectOriginalPhoto;
    }
    [self configCollectionView];
    [self configCropView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.view.clipsToBounds = YES;
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.tz_width + 20) * _currentIndex, 0) animated:NO];
    
    
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
    [TZImageManager manager].shouldFixOrientation = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configCustomNaviBar {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (![self.navigationController isKindOfClass:TZImagePickerController.class]) {
        _showSelectBtn = NO;
        [self showNaviBar];
    }else {
      
        [self configDefaultBtnTitleFrom:tzImagePickerVc];
        [self configDefaultBtnTitleFrom:tzImagePickerVc];
        [self showNaviBar];
    }


}

-(void)showNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back.png"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.tz_width - 54, 10, 42, 42)];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:_photoDefImageName] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:_photoSelImageName] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = _showSelectBtn;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];

}


- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.tz_height - 44, self.view.tz_width, 44)];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (![self.navigationController isKindOfClass:TZImagePickerController.class]) {
        
        _originalPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        [self showToolBar];
    }else {
        _originalPhotoButton.hidden = NO;
        _originalPhotoLabel.hidden = NO;
        [self configDefaultBtnTitleFrom:_tzImagePickerVc];
        [self configDefaultBtnTitleFrom:_tzImagePickerVc];
        [self showToolBar];
        [_toolBar addSubview:_originalPhotoButton];

    }
    
}


-(void)showToolBar {
    CGFloat fullImageWidth = [_fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
    _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _originalPhotoButton.frame = CGRectMake(0, 0, fullImageWidth + 56, 44);
    _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _originalPhotoButton.backgroundColor = [UIColor clearColor];
    [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_originalPhotoButton setTitle: _fullImageBtnTitleStr forState:UIControlStateNormal];
    [_originalPhotoButton setTitle: _fullImageBtnTitleStr forState:UIControlStateSelected];
    [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_photoPreviewOriginDefImageName] forState:UIControlStateNormal];
    [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_photoOriginSelImageName] forState:UIControlStateSelected];
    
    _originalPhotoLabel = [[UILabel alloc] init];
    _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
    _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
    _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
    _originalPhotoLabel.textColor = [UIColor whiteColor];
    _originalPhotoLabel.backgroundColor = [UIColor clearColor];
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.tz_width - 44 - 12, 0, 44, 44);
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle: _doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor: _oKButtonTitleColorNormal forState:UIControlStateNormal];

    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_doneButton];
    [self.view addSubview:_toolBar];
    
}

- (void)configDefaultImageName {
    self.takePictureImageName = @"takePicture.png";
    self.photoSelImageName = @"photo_sel_photoPickerVc.png";
    self.photoDefImageName = @"photo_def_photoPickerVc.png";
    self.photoNumberIconImageName = @"photo_number_icon.png";
    self.photoPreviewOriginDefImageName = @"preview_original_def.png";
    self.photoOriginDefImageName = @"photo_original_def.png";
    self.photoOriginSelImageName = @"photo_original_sel.png";
}

-(void)configDefaultImageNameFrome:(TZImagePickerController *)vc {
    self.takePictureImageName = vc.takePictureImageName;
    self.photoSelImageName = vc.photoSelImageName;
    self.photoDefImageName = vc.photoDefImageName;
    self.photoNumberIconImageName = vc.photoNumberIconImageName;
    self.photoPreviewOriginDefImageName = vc.photoPreviewOriginDefImageName;
    self.photoOriginDefImageName = vc.photoOriginDefImageName;
    self.photoOriginSelImageName = vc.photoOriginSelImageName;
    self.selectedModels = vc.selectedModels;
    self.selectedAssets = vc.selectedAssets;
}

- (void)configDefaultBtnTitle {
    self.doneBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Done"];
    self.cancelBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Cancel"];
    self.previewBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Preview"];
    self.fullImageBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Full image"];
    self.settingBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Setting"];
    self.processHintStr = [NSBundle tz_localizedStringForKey:@"Processing..."];
}

-(void)configDefaultBtnTitleFrom:(TZImagePickerController *)vc  {
    self.doneBtnTitleStr = vc.doneBtnTitleStr;
    self.cancelBtnTitleStr = vc.cancelBtnTitleStr;
    self.previewBtnTitleStr = vc.previewBtnTitleStr;
    self.fullImageBtnTitleStr = vc.fullImageBtnTitleStr;
    self.settingBtnTitleStr = vc.settingBtnTitleStr;
    self.processHintStr = vc.processHintStr;
    
}


- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.tz_width + 20, self.view.tz_height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.tz_width + 20, self.view.tz_height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.tz_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZPhotoPreviewCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
}

- (void)configCropView {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
   
 
    if (![self.navigationController isKindOfClass:TZImagePickerController.class]) {
        
         [self showCoreView];
    }
    
    else if (!_tzImagePickerVc.showSelectBtn && _tzImagePickerVc.allowCrop) {
        _cropRect = _tzImagePickerVc.cropRect;
        _needCircleCrop = _tzImagePickerVc.needCircleCrop;
        _cropViewSettingBlock = _tzImagePickerVc.cropViewSettingBlock;
        [self showCoreView];
    }
}

-(void)showCoreView {
    _cropBgView = [UIView new];
    _cropBgView.userInteractionEnabled = NO;
    _cropBgView.backgroundColor = [UIColor clearColor];
    _cropBgView.frame = self.view.bounds;
    [self.view addSubview:_cropBgView];
   
    
    _cropView = [UIView new];
    _cropView.userInteractionEnabled = NO;
    _cropView.backgroundColor = [UIColor clearColor];
    
    _collectionView.scrollEnabled = NO;
  
    
    
    _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
    _cropView.layer.borderWidth = 1.0;
    if (_needCircleCrop) {
        _cropView.layer.cornerRadius = _cropRect.size.width / 2;
        _cropView.clipsToBounds = YES;
    }
    [self.view addSubview:_cropView];
    if (_cropViewSettingBlock) {
        _cropViewSettingBlock(_cropView);
    }
}


#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetModel *model = _models[_currentIndex];

    if (![self.navigationController isKindOfClass:TZImagePickerController.class]) {
        
        
        
    }
    else {
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_tzImagePickerVc.selectedModels.count >= _tzImagePickerVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Select a maximum of %zd photos"], _tzImagePickerVc.maxImagesCount];
            [_tzImagePickerVc showAlertWithTitle:title];
            return;
        // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_tzImagePickerVc.selectedModels addObject:model];
            if (self.photos) {
                [_tzImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
                [self.photos addObject:_photosTemp[_currentIndex]];
            }
            if (model.type == TZAssetModelMediaTypeVideo) {
                [_tzImagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
        for (TZAssetModel *model_item in selectedModels) {
            if ([[[TZImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    TZAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_tzImagePickerVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                // [_tzImagePickerVc.selectedModels removeObject:model_item];
                if (self.photos) {
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_assetsTemp[_currentIndex]]) {
                            [_tzImagePickerVc.selectedAssets removeObjectAtIndex:i];
                            break;
                        }
                    }
                    // [_tzImagePickerVc.selectedAssets removeObject:_assetsTemp[_currentIndex]];
                    [self.photos removeObject:_photosTemp[_currentIndex]];
                }
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
    }
    }
}

- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)doneButtonClick {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (![self.navigationController isKindOfClass:TZImagePickerController.class]) {
      
        if (_allowCrop) { // 裁剪状态
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
            TZPhotoPreviewCell *cell = (TZPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            UIImage *cropedImage = [TZImageCropManager cropImageView:cell.previewView.imageView toRect:_cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
            if (_needCircleCrop) {
                cropedImage = [TZImageCropManager circularClipImage:cropedImage];
            }
            if (self.doneButtonClickBlockCropMode) {
                TZAssetModel *model = _models[_currentIndex];
                self.doneButtonClickBlockCropMode(cropedImage,model.asset);
            }
        } else if (self.doneButtonClickBlock) { // 非裁剪状态
            self.doneButtonClickBlock(_isSelectOriginalPhoto);
        }
    
    }else {
    
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1) {
        [_tzImagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Synchronizing photos from iCloud"]]; return;
    }
    
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (_tzImagePickerVc.selectedModels.count == 0 && _tzImagePickerVc.minImagesCount <= 0) {
        TZAssetModel *model = _models[_currentIndex];
        [_tzImagePickerVc.selectedModels addObject:model];
    }
    if (_tzImagePickerVc.allowCrop) { // 裁剪状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        TZPhotoPreviewCell *cell = (TZPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        ///这里不要改 不要改 重要的事情说三遍
        UIImage *cropedImage = [TZImageCropManager cropImageView:cell.previewView.imageView toRect:_cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (_tzImagePickerVc.needCircleCrop) {
            cropedImage = [TZImageCropManager circularClipImage:cropedImage];
        }
        if (self.doneButtonClickBlockCropMode) {
            TZAssetModel *model = _models[_currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage,model.asset);
        }
    } else if (self.doneButtonClickBlock) { // 非裁剪状态
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos,_tzImagePickerVc.selectedAssets,self.isSelectOriginalPhoto);
    }
    }
}

- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) {
        [self showPhotoBytes];
        if (!_selectButton.isSelected) {
            // 如果当前已选择照片张数 < 最大可选张数 && 最大可选张数大于1，就选中该张图
            TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
            if (_tzImagePickerVc.selectedModels.count < _tzImagePickerVc.maxImagesCount && _tzImagePickerVc.showSelectBtn) {
                [self select:_selectButton];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.tz_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.tz_width + 20);
    
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (![self.navigationController isKindOfClass:TZImagePickerController.class]) {
        cell.cropRect = _cropRect;
        cell.allowCrop = _allowCrop;
    }else {
    
        CGFloat imgHeight = _cropRect.size.height;
        if (imgHeight > cell.previewView.imageContainerView.frame.size.height) {
            CGFloat width = cell.previewView.imageContainerView.frame.size.height *(_cropRect.size.width/_cropRect.size.height);
            CGRect newRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - width) * 0.5, (cell.frame.size.height - cell.previewView.imageContainerView.frame.size.height) * 0.5,width , cell.previewView.imageContainerView.frame.size.height);
            _cropView.frame = newRect;
            
            cell.cropRect = newRect;
            cell.allowCrop = _tzImagePickerVc.allowCrop;
            _cropRect = newRect;
             [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:newRect containerView:self.view needCircleCrop:_needCircleCrop];
            
        }else {
            _cropView.frame = _cropRect;
            
            cell.cropRect = _tzImagePickerVc.cropRect;
            cell.allowCrop = _tzImagePickerVc.allowCrop;
             [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:_cropRect containerView:self.view needCircleCrop:_needCircleCrop];
        }
        
        
 
    }
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        __weak typeof(_naviBar) weakNaviBar = _naviBar;
        __weak typeof(_toolBar) weakToolBar = _toolBar;
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            weakSelf.isHideNaviBar = !weakSelf.isHideNaviBar;
            weakNaviBar.hidden = weakSelf.isHideNaviBar;
            weakToolBar.hidden = weakSelf.isHideNaviBar;
        };
    }
    [cell setImageProgressUpdateBlock:^(double progress) {
        weakSelf.progress = progress;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

#pragma mark - Private Method

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)refreshNaviBarAndBottomBarState {
  
    TZAssetModel *model = _models[_currentIndex];
    _selectButton.selected = model.isSelected;
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
  
    
    _doneButton.hidden = NO;
    _selectButton.hidden = YES;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[TZImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _selectButton.hidden = YES;
        _originalPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        _doneButton.hidden = YES;
    }
}

- (void)showPhotoBytes {
    [[TZImageManager manager] getPhotosBytesWithArray:@[_models[_currentIndex]] completion:^(NSString *totalBytes) {
        self->_originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

@end
