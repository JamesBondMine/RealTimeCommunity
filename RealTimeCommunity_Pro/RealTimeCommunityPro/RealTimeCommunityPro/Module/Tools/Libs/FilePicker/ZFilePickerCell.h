//
//  ZFilePickerCell.h
//  CIMKit
//
//  Created by cusPro on 2023/1/4.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFilePickerCell : ZBaseCell

@property (nonatomic, strong)PHAsset *videoAsset;

@property (nonatomic, copy)NSString *showName;
@property (nonatomic, copy)NSString *localFileType;
@property (nonatomic, assign)float localFileSize;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, assign)float currentFileSize;

@end

NS_ASSUME_NONNULL_END
