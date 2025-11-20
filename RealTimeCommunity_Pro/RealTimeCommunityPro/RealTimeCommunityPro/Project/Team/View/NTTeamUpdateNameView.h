//
//  NTTeamUpdateNameView.h
//  CIMKit
//
//  Created by cusPro on 2023/11/7.
//

#import <UIKit/UIKit.h>
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ZTeamUpdateNameViewDelegate <NSObject>

- (void)teamUpdateNameAction:(NSString *)newName;

@end

@interface NTTeamUpdateNameView : UIView

@property (nonatomic, strong) NTMTeamModel *model;
@property (nonatomic, weak) id <ZTeamUpdateNameViewDelegate> delegate;

- (void)updateViewShow;

@end

NS_ASSUME_NONNULL_END
