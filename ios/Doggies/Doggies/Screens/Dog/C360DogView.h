//
// C360DogView.h.h
// 
// Created on 2015-06-09 using NibFree
// 

#import "C360BaseView.h"
#import "C360DogWhisperer.h"

@class C360DogView;

@protocol C360DogViewDataSource <NSObject>

- (NSString *)dogViewErrorMessage:(C360DogView *)dogView;
- (C360DogWhisperer *)dogViewDogWhisperer:(C360DogView *)dogView;

@end

@protocol C360DogViewDelegate <NSObject, C360BaseViewDelegate>

- (void)dogViewDidRequestReload:(C360DogView *)dogView;

@end

@interface C360DogView : C360BaseView

@property (nonatomic, weak) id<C360DogViewDataSource> dataSource;
@property (nonatomic, weak) id<C360DogViewDelegate> delegate;

- (void)reloadData;

@end

