//
// C360BreedsView.h.h
// 
// Created on 2015-05-31 using NibFree
// 

#import "C360BaseView.h"
#import "C360Breed.h"

@class C360BreedsView;

@protocol C360BreedsViewDataSource <NSObject>

- (NSString *)breedsViewErrorMessage:(C360BreedsView *)breedsView;
- (NSInteger)breedsViewNumberOfBreeds:(C360BreedsView *)breedsView;
- (C360Breed *)breedsView:(C360BreedsView *)breedsView breedAtIndex:(NSInteger)index;
- (BOOL)breedsView:(C360BreedsView *)breedsView isBreedSelectedAtIndex:(NSInteger)index;

@end

@protocol C360BreedsViewDelegate <NSObject, C360BaseViewDelegate>

- (void)breedsViewDidRequestReload:(C360BreedsView *)breedsView;
- (void)breedsView:(C360BreedsView *)breedsView didSelectBreedAtIndex:(NSInteger)index;

@end

@interface C360BreedsView : C360BaseView

@property (nonatomic, weak) id<C360BreedsViewDataSource> dataSource;
@property (nonatomic, weak) id<C360BreedsViewDelegate> delegate;

- (void)reloadData;

@end

