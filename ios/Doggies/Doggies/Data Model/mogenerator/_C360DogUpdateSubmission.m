// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360DogUpdateSubmission.m instead.

#import "_C360DogUpdateSubmission.h"

const struct C360DogUpdateSubmissionAttributes C360DogUpdateSubmissionAttributes = {
	.breedId = @"breedId",
	.breedName = @"breedName",
	.name = @"name",
	.numberOfBottomsSniffed = @"numberOfBottomsSniffed",
	.numberOfCatsChased = @"numberOfCatsChased",
	.numberOfFacesLicked = @"numberOfFacesLicked",
};

const struct C360DogUpdateSubmissionRelationships C360DogUpdateSubmissionRelationships = {
	.dog = @"dog",
};

const struct C360DogUpdateSubmissionFetchedProperties C360DogUpdateSubmissionFetchedProperties = {
};

@implementation C360DogUpdateSubmissionID
@end

@implementation _C360DogUpdateSubmission

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DogUpdateSubmission" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DogUpdateSubmission";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DogUpdateSubmission" inManagedObjectContext:moc_];
}

- (C360DogUpdateSubmissionID*)objectID {
	return (C360DogUpdateSubmissionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"breedIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"breedId"];
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





@dynamic dog;

	






@end
