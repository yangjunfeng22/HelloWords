// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserLaterStatuModel.m instead.

#import "_UserLaterStatuModel.h"

const struct UserLaterStatuModelAttributes UserLaterStatuModelAttributes = {
	.bookID = @"bookID",
	.categoryID = @"categoryID",
	.checkPointID = @"checkPointID",
	.nexCheckPointID = @"nexCheckPointID",
	.timeStamp = @"timeStamp",
	.userID = @"userID",
};

const struct UserLaterStatuModelRelationships UserLaterStatuModelRelationships = {
};

const struct UserLaterStatuModelFetchedProperties UserLaterStatuModelFetchedProperties = {
};

@implementation UserLaterStatuModelID
@end

@implementation _UserLaterStatuModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserLaterStatuModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserLaterStatuModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserLaterStatuModel" inManagedObjectContext:moc_];
}

- (UserLaterStatuModelID*)objectID {
	return (UserLaterStatuModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"timeStampValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeStamp"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bookID;






@dynamic categoryID;






@dynamic checkPointID;






@dynamic nexCheckPointID;






@dynamic timeStamp;



- (float)timeStampValue {
	NSNumber *result = [self timeStamp];
	return [result floatValue];
}

- (void)setTimeStampValue:(float)value_ {
	[self setTimeStamp:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTimeStampValue {
	NSNumber *result = [self primitiveTimeStamp];
	return [result floatValue];
}

- (void)setPrimitiveTimeStampValue:(float)value_ {
	[self setPrimitiveTimeStamp:[NSNumber numberWithFloat:value_]];
}





@dynamic userID;











@end
