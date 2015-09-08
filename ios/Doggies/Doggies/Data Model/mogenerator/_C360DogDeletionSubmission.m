// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360DogDeletionSubmission.m instead.

#import "_C360DogDeletionSubmission.h"

const struct C360DogDeletionSubmissionAttributes C360DogDeletionSubmissionAttributes = {
};

const struct C360DogDeletionSubmissionRelationships C360DogDeletionSubmissionRelationships = {
	.dog = @"dog",
};

const struct C360DogDeletionSubmissionFetchedProperties C360DogDeletionSubmissionFetchedProperties = {
};

@implementation C360DogDeletionSubmissionID
@end

@implementation _C360DogDeletionSubmission

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DogDeletionSubmission" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DogDeletionSubmission";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DogDeletionSubmission" inManagedObjectContext:moc_];
}

- (C360DogDeletionSubmissionID*)objectID {
	return (C360DogDeletionSubmissionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic dog;

	






@end
