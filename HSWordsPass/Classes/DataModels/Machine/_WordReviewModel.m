// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordReviewModel.m instead.

#import "_WordReviewModel.h"

const struct WordReviewModelAttributes WordReviewModelAttributes = {
	.cpID = @"cpID",
	.created = @"created",
	.status = @"status",
	.uID = @"uID",
	.wID = @"wID",
};

const struct WordReviewModelRelationships WordReviewModelRelationships = {
};

const struct WordReviewModelFetchedProperties WordReviewModelFetchedProperties = {
};

@implementation WordReviewModelID
@end

@implementation _WordReviewModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WordReviewModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WordReviewModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WordReviewModel" inManagedObjectContext:moc_];
}

- (WordReviewModelID*)objectID {
	return (WordReviewModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"createdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"created"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cpID;






@dynamic created;



- (int32_t)createdValue {
	NSNumber *result = [self created];
	return [result intValue];
}

- (void)setCreatedValue:(int32_t)value_ {
	[self setCreated:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCreatedValue {
	NSNumber *result = [self primitiveCreated];
	return [result intValue];
}

- (void)setPrimitiveCreatedValue:(int32_t)value_ {
	[self setPrimitiveCreated:[NSNumber numberWithInt:value_]];
}





@dynamic status;



- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithInt:value_]];
}





@dynamic uID;






@dynamic wID;











@end
