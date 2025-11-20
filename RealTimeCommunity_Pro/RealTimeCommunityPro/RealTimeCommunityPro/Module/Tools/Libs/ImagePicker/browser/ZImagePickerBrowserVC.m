//
//  ZImagePickerBrowserVC.m
//  CIMKit
//
//  Created by cusPro on 2022/9/30.
//

#import "ZImagePickerBrowserVC.h"
#import "ZImagePickerBrowserCell.h"
#import "ZImagePickerManager.h"

@interface ZImagePickerBrowserVC ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ZImagePickerBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
#pragma mark - 界面布局
- (void)setupUI {
    self.navTitleStr = MultilingualTranslation(@"图片预览");
    
}
#pragma mark - 数据赋值
- (void)setListAssets:(NSMutableArray<PHAsset *> *)listAssets {
    _listAssets = listAssets;
    [_collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
