// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointProgressModel.m instead.

#import "_CheckPointProgressModel.h"

const struct CheckPointProgressModelAttributes CheckPointProgressModelAttributes = {
	.bID = @"bID",
	.cpID = @"cpID",
	.progress = @"progress",
	.status = @"status",
	.uID = @"uID",
	.version = @"version",
};

const struct CheckPointProgressModelRelationships CheckPointProgressModelRelationships = {
};

const struct CheckPointProgressModelFetchedProperties CheckPointProgressModelFetchedProperties = {
};

@implementation CheckPointProgressModelID
@end

@implementation _CheckPointProgressModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckPointProgressModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckPointProgressModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckPointProgressModel" inManagedObjectContext:moc_];
}

- (CheckPointProgressModelID*)objectID {
	return (CheckPointProgressModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"progressValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"progress"];
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




@dynamic bID;






@dynamic cpID;






@dynamic progress;



- (float)progressValue {
	NSNumber *result = [self progress];
	return [result floatValue];
}

- (void)setProgressValue:(float)value_ {
	[self setProgress:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveProgressValue {
	NSNumber *result = [self primitiveProgress];
	return [result floatValue];
}

- (void)setPrimitiveProgressValue:(float)value_ {
	[self setPrimitiveProgress:[NSNumber numberWithFloat:value_]];
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






@dynamic version;











@end
