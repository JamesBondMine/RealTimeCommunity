//
//  IVTTeamInviteEditTeamNameDataHandle.m
//  CIMKit
//
//  Created by phl on 2025/7/25.
//

#import "IVTTeamInviteEditTeamNameDataHandle.h"

@interface IVTTeamInviteEditTeamNameDataHandle()

/// 从上个页面传入的团队信息
@property (nonatomic, strong, readwrite) NTMTeamModel *currentTeamModel;

@end

@implementation IVTTeamInviteEditTeamNameDataHandle

- (void)dealloc {
    CIMLog(@"%@ dealloc", [self class]);
}

- (RACCommand *)editTeamDetailInfoCommand {
    if (!_editTeamDetailInfoCommand) {
        @weakify(self)
        _editTeamDetailInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString *newTeamName = input;
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObjectSafe:self.currentTeamModel.teamId forKey:@"teamId"];
                [dict setObjectSafe:newTeamName forKey:@"teamName"];
                [IMSDKManager imTeamEditWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                    [subscriber sendNext:@(YES)];
                    [subscriber sendCompleted];
                } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                    [HUD showMessageWithCode:code errorMsg:msg];
                    [subscriber sendNext:@(NO)];
                    [subscriber sendCompleted];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _editTeamDetailInfoCommand;
}

- (RACSubject *)backSubject {
    if (!_backSubject) {
        _backSubject = [RACSubject subject];
    }
    return _backSubject;
}

- (instancetype)initWithTeamModel:(NTMTeamModel *)teamModel {
    self = [super init];
    if (self) {
        self.currentTeamModel = teamModel;
    }
    return self;
}

@end
