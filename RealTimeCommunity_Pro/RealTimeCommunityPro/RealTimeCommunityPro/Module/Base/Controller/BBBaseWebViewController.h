//
//  BBBaseWebViewController.h
//  CIMKit
//
//  Created by cusPro on 2022/9/20.
//

#import "BBBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBBaseWebViewController : BBBaseViewController

@property (nonatomic, copy) NSString* webViewTitle;
@property (nonatomic, copy) NSString* webViewUrl;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, copy) NSString *currentUrlStr;

@end

NS_ASSUME_NONNULL_END
