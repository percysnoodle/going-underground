// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to C360PendingSubmission.m instead.

#import "_C360PendingSubmission.h"

const struct C360PendingSubmissionAttributes C360PendingSubmissionAttributes = {
	.createdAtTimestamp = @"createdAtTimestamp",
	.isUnrecoverable = @"isUnrecoverable",
	.lastSubmissionLocalizedDescription = @"lastSubmissionLocalizedDescription",
	.lastSubmissionTimestamp = @"lastSubmissionTimestamp",
	.numberOfErrors = @"numberOfErrors",
};

const struct C360PendingSubmissionRelationships C360PendingSubmissionRelationships = {
};

const struct C360PendingSubmissionFetchedProperties C360PendingSubmissionFetchedProperties = {
};

@implementation C360PendingSubmissionID
@end

@implementation _C360PendingSubmission

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PendingSubmission" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PendingSubmission";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PendingSubmission" inManagedObjectContext:moc_];
}

- (C360PendingSubmissionID*)objectID {
	return (C360PendingSubmissionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"createdAtTimestampValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"createdAtTimestamp"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isUnrecoverableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isUnrecoverable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lastSubmissionTimestampValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lastSubmissionTimestamp"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberOfErrorsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberOfErrors"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdAtTimestamp;



- (double)createdAtTimestampValue {
	NSNumber *result = [self createdAtTimestamp];
	return [result doubleValue];
}

- (void)setCreatedAtTimestampValue:(double)value_ {
	[self setCreatedAtTimestamp:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveCreatedAtTimestampValue {
	NSNumber *result = [self primitiveCreatedAtTimestamp];
	return [result doubleValue];
}

- (void)setPrimitiveCreatedAtTimestampValue:(double)value_ {
	[self setPrimitiveCreatedAtTimestamp:[NSNumber numberWithDouble:value_]];
}





@dynamic isUnrecoverable;



- (BOOL)isUnrecoverableValue {
	NSNumber *result = [self isUnrecoverable];
	return [result boolValue];
}

- (void)setIsUnrecoverableValue:(BOOL)value_ {
	[self setIsUnrecoverable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsUnrecoverableValue {
	NSNumber *result = [self primitiveIsUnrecoverable];
	return [result boolValue];
}

- (void)setPrimitiveIsUnrecoverableValue:(BOOL)value_ {
	[self setPrimitiveIsUnrecoverable:[NSNumber numberWithBool:value_]];
}





@dynamic lastSubmissionLocalizedDescription;






@dynamic lastSubmissionTimestamp;



- (double)lastSubmissionTimestampValue {
	NSNumber *result = [self lastSubmissionTimestamp];
	return [result doubleValue];
}

- (void)setLastSubmissionTimestampValue:(double)value_ {
	[self setLastSubmissionTimestamp:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLastSubmissionTimestampValue {
	NSNumber *result = [self primitiveLastSubmissionTimestamp];
	return [result doubleValue];
}

- (void)setPrimitiveLastSubmissionTimestampValue:(double)value_ {
	[self setPrimitiveLastSubmissionTimestamp:[NSNumber numberWithDouble:value_]];
}





@dynamic numberOfErrors;



- (int16_t)numberOfErrorsValue {
	NSNumber *result = [self numberOfErrors];
	return [result shortValue];
}

- (void)setNumberOfErrorsValue:(int16_t)value_ {
	[self setNumberOfErrors:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumberOfErrorsValue {
	NSNumber *result = [self primitiveNumberOfErrors];
	return [result shortValue];
}

- (void)setPrimitiveNumberOfErrorsValue:(int16_t)value_ {
	[self setPrimitiveNumberOfErrors:[NSNumber numberWithShort:value_]];
}










@end
