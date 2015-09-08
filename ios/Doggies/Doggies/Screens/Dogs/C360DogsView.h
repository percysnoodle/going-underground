//
// C360DogsView.h.h
// 
// Created on 2015-05-31 using NibFree
// 

#import "C360BaseView.h"
#import "C360DogWhisperer.h"
#import "C360Breed.h"

@class C360DogsView;

@protocol C360DogsViewDataSource <NSObject>

- (NSString *)dogsViewErrorMessage:(C360DogsView *)dogsView;
- (NSInteger)dogsViewNumberOfDogs:(C360DogsView *)dogsView;
- (C360DogWhisperer *)dogsView:(C360DogsView *)dogsView dogWhispererAtIndex:(NSInteger)index;

@end

@protocol C360DogsViewDelegate <NSObject, C360BaseViewDelegate>

- (void)dogsViewDidRequestReload:(C360DogsView *)dogsView;
- (void)dogsView:(C360DogsView *)dogsView didSelectDogAtIndex:(NSInteger)index;
- (void)dogsView:(C360DogsView *)dogsView didDeleteDogAtIndex:(NSInteger)index;

@end

@interface C360DogsView : C360BaseView

@property (nonatomic, weak) id<C360DogsViewDataSource> dataSource;
@property (nonatomic, weak) id<C360DogsViewDelegate> delegate;

- (void)reloadData;

@end

