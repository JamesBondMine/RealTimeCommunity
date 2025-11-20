//
//  ZQrcodeTextContentViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/4/6.
//

#import "ZQrcodeTextContentViewController.h"
#import "UITextView+Addition.h"
@interface ZQrcodeTextContentViewController ()

@property (nonatomic, strong)UITextView *contentText;

@end

@implementation ZQrcodeTextContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    _contentText =  [[UITextView alloc] init];
    _contentText.text = _textContent;
    _contentText.font = FONTN(16);
    _contentText.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _contentText.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    _contentText.textAlignment = NSTextAlignmentLeft;
    _contentText.bounces = NO;
    _contentText.editable = NO;
    [self.view addSubview:_contentText];
    [_contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(DWScale(20));
        make.leading.equalTo(self.view).offset(DWScale(20));
        make.trailing.equalTo(self.view).offset(-DWScale(20));
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
    }];
}

#pragma mark - Super
- (void)navBtnBackClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
