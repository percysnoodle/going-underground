//
//  C360DogWhisperer.m
//  Doggies
//
//  Created by Simon Booth on 18/08/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360DogWhisperer.h"

@implementation C360DogWhisperer

+ (instancetype)dogWhispererWithDog:(C360Dog *)dog
{
    return [[self alloc] initWithDog:dog];
}

- (id)initWithDog:(C360Dog *)dog
{
    self = [super init];
    if (self)
    {
        _dog = dog;
    }
    return self;
}

- (NSString *)status
{
    if (self.dog.pendingCreationSubmission)
    {
        if (self.dog.pendingCreationSubmission.isUnrecoverable.boolValue)
        {
            return @"Creation failed";
        }
        else
        {
            return @"Pending creation";
        }
    }
    else if (self.dog.pendingDeletionSubmission)
    {
        if (self.dog.pendingDeletionSubmission.isUnrecoverable.boolValue)
        {
            return @"Deletion failed";
        }
        else
        {
            return @"Pending deletion";
        }
    }
    else if (self.dog.pendingUpdateSubmission)
    {
        if (self.dog.pendingUpdateSubmission.isUnrecoverable.boolValue)
        {
            return @"Update failed";
        }
        else
        {
            return @"Pending update";
        }
    }
    else if (self.dog.dogId)
    {
        return @"Normal";
    }
    else
    {
        return @"Not created";
    }
}

- (BOOL)isPendingDeletion
{
    return self.dog.pendingDeletionSubmission && !self.dog.pendingDeletionSubmission.isUnrecoverable.boolValue;
}

#define ALWAYS_DOG(TYPE, NAME, DEFAULT) \
- (TYPE)NAME { \
    return self.dog.NAME ?: DEFAULT; \
}

#define UPDATE_THEN_DOG(TYPE, NAME, DEFAULT) \
- (TYPE)NAME { \
    return ((self.dog.pendingUpdateSubmission) ? self.dog.pendingUpdateSubmission.NAME : self.dog.NAME) ?: DEFAULT; \
}

ALWAYS_DOG(NSNumber *, dogId, nil)
UPDATE_THEN_DOG(NSString *, name, nil)
UPDATE_THEN_DOG(NSNumber *, breedId, nil)
UPDATE_THEN_DOG(NSString *, breedName, @"Mongrel")
UPDATE_THEN_DOG(NSNumber *, numberOfBottomsSniffed, nil)
UPDATE_THEN_DOG(NSNumber *, numberOfCatsChased, nil)
UPDATE_THEN_DOG(NSNumber *, numberOfFacesLicked, nil)

@end
