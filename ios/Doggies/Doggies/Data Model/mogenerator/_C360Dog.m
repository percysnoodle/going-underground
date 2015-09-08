// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360Dog.m instead.

#import "_C360Dog.h"

const struct C360DogAttributes C360DogAttributes = {
	.breedId = @"breedId",
	.breedName = @"breedName",
	.dogId = @"dogId",
	.isFullObject = @"isFullObject",
	.name = @"name",
	.numberOfBottomsSniffed = @"numberOfBottomsSniffed",
	.numberOfCatsChased = @"numberOfCatsChased",
	.numberOfFacesLicked = @"numberOfFacesLicked",
};

const struct C360DogRelationships C360DogRelationships = {
	.breed = @"breed",
	.pendingCreationSubmission = @"pendingCreationSubmission",
	.pendingDeletionSubmission = @"pendingDeletionSubmission",
	.pendingUpdateSubmission = @"pendingUpdateSubmission",
};

const struct C360DogFetchedProperties C360DogFetchedProperties = {
};

@implementation C360DogID
@end

@implementation _C360Dog

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Dog" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Dog";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Dog" inManagedObjectContext:moc_];
}

- (C360DogID*)objectID {
	return (C360DogID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"breedIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"breedId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"dogIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dogId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFullObjectValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFullObject"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberOfBottomsSniffedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberOfBottomsSniffed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberOfCatsChasedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberOfCatsChased"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberOfFacesLickedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberOfFacesLicked"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic breedId;



- (int64_t)breedIdValue {
	NSNumber *result = [self breedId];
	return [result longLongValue];
}

- (void)setBreedIdValue:(int64_t)value_ {
	[self setBreedId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveBreedIdValue {
	NSNumber *result = [self primitiveBreedId];
	return [result longLongValue];
}

- (void)setPrimitiveBreedIdValue:(int64_t)value_ {
	[self setPrimitiveBreedId:[NSNumber numberWithLongLong:value_]];
}





@dynamic breedName;






@dynamic dogId;



- (int64_t)dogIdValue {
	NSNumber *result = [self dogId];
	return [result longLongValue];
}

- (void)setDogIdValue:(int64_t)value_ {
	[self setDogId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveDogIdValue {
	NSNumber *result = [self primitiveDogId];
	return [result longLongValue];
}

- (void)setPrimitiveDogIdValue:(int64_t)value_ {
	[self setPrimitiveDogId:[NSNumber numberWithLongLong:value_]];
}





@dynamic isFullObject;



- (BOOL)isFullObjectValue {
	NSNumber *result = [self isFullObject];
	return [result boolValue];
}

- (void)setIsFullObjectValue:(BOOL)value_ {
	[self setIsFullObject:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFullObjectValue {
	NSNumber *result = [self primitiveIsFullObject];
	return [result boolValue];
}

- (void)setPrimitiveIsFullObjectValue:(BOOL)value_ {
	[self setPrimitiveIsFullObject:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic numberOfBottomsSniffed;



- (int64_t)numberOfBottomsSniffedValue {
	NSNumber *result = [self numberOfBottomsSniffed];
	return [result longLongValue];
}

- (void)setNumberOfBottomsSniffedValue:(int64_t)value_ {
	[self setNumberOfBottomsSniffed:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveNumberOfBottomsSniffedValue {
	NSNumber *result = [self primitiveNumberOfBottomsSniffed];
	return [result longLongValue];
}

- (void)setPrimitiveNumberOfBottomsSniffedValue:(int64_t)value_ {
	[self setPrimitiveNumberOfBottomsSniffed:[NSNumber numberWithLongLong:value_]];
}





@dynamic numberOfCatsChased;



- (int64_t)numberOfCatsChasedValue {
	NSNumber *result = [self numberOfCatsChased];
	return [result longLongValue];
}

- (void)setNumberOfCatsChasedValue:(int64_t)value_ {
	[self setNumberOfCatsChased:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveNumberOfCatsChasedValue {
	NSNumber *result = [self primitiveNumberOfCatsChased];
	return [result longLongValue];
}

- (void)setPrimitiveNumberOfCatsChasedValue:(int64_t)value_ {
	[self setPrimitiveNumberOfCatsChased:[NSNumber numberWithLongLong:value_]];
}





@dynamic numberOfFacesLicked;



- (int64_t)numberOfFacesLickedValue {
	NSNumber *result = [self numberOfFacesLicked];
	return [result longLongValue];
}

- (void)setNumberOfFacesLickedValue:(int64_t)value_ {
	[self setNumberOfFacesLicked:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveNumberOfFacesLickedValue {
	NSNumber *result = [self primitiveNumberOfFacesLicked];
	return [result longLongValue];
}

- (void)setPrimitiveNumberOfFacesLickedValue:(int64_t)value_ {
	[self setPrimitiveNumberOfFacesLicked:[NSNumber numberWithLongLong:value_]];
}





@dynamic breed;

	

@dynamic pendingCreationSubmission;

	

@dynamic pendingDeletionSubmission;

	

@dynamic pendingUpdateSubmission;

	






@end
