//
//  C360DogWhisperer.h
//  Doggies
//
//  Created by Simon Booth on 18/08/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360Dog.h"
#import "C360DogCreationSubmission.h"
#import "C360DogDeletionSubmission.h"
#import "C360DogUpdateSubmission.h"

@interface C360DogWhisperer : NSObject

+ (instancetype)dogWhispererWithDog:(C360Dog *)dog;

@property (nonatomic, strong, readonly) C360Dog *dog;
- (id)initWithDog:(C360Dog *)dog;

@property (nonatomic, strong, readonly) NSString *status;
@property (nonatomic, assign, readonly) BOOL isPendingDeletion;

@property (nonatomic, strong, readonly) NSNumber *dogId;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSNumber *breedId;
@property (nonatomic, strong, readonly) NSString *breedName;
@property (nonatomic, strong, readonly) NSNumber *numberOfBottomsSniffed;
@property (nonatomic, strong, readonly) NSNumber *numberOfCatsChased;
@property (nonatomic, strong, readonly) NSNumber *numberOfFacesLicked;

@end
