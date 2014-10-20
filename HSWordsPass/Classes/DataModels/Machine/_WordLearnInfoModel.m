// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordLearnInfoModel.m instead.

#import "_WordLearnInfoModel.h"

const struct WordLearnInfoModelAttributes WordLearnInfoModelAttributes = {
	.cpID = @"cpID",
	.rights = @"rights",
	.status = @"status",
	.sync = @"sync",
	.uID = @"uID",
	.wID = @"wID",
	.wrongs = @"wrongs",
};

const struct WordLearnInfoModelRelationships WordLearnInfoModelRelationships = {
};

const struct WordLearnInfoModelFetchedProperties WordLearnInfoModelFetchedProperties = {
};

@implementation WordLearnInfoModelID
@end

@implementation _WordLearnInfoModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WordLearnInfoModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WordLearnInfoModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WordLearnInfoModel" inManagedObjectContext:moc_];
}

- (WordLearnInfoModelID*)objectID {
	return (WordLearnInfoModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"rightsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rights"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"syncValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sync"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wrongsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wrongs"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cpID;






@dynamic rights;



- (int32_t)rightsValue {
	NSNumber *result = [self rights];
	return [result intValue];
}

- (void)setRightsValue:(int32_t)value_ {
	[self setRights:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRightsValue {
	NSNumber *result = [self primitiveRights];
	return [result intValue];
}

- (void)setPrimitiveRightsValue:(int32_t)value_ {
	[self setPrimitiveRights:[NSNumber numberWithInt:value_]];
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





@dynamic sync;



- (int32_t)syncValue {
	NSNumber *result = [self sync];
	return [result intValue];
}

- (void)setSyncValue:(int32_t)value_ {
	[self setSync:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSyncValue {
	NSNumber *result = [self primitiveSync];
	return [result intValue];
}

- (void)setPrimitiveSyncValue:(int32_t)value_ {
	[self setPrimitiveSync:[NSNumber numberWithInt:value_]];
}





@dynamic uID;






@dynamic wID;






@dynamic wrongs;



- (int32_t)wrongsValue {
	NSNumber *result = [self wrongs];
	return [result intValue];
}

- (void)setWrongsValue:(int32_t)value_ {
	[self setWrongs:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWrongsValue {
	NSNumber *result = [self primitiveWrongs];
	return [result intValue];
}

- (void)setPrimitiveWrongsValue:(int32_t)value_ {
	[self setPrimitiveWrongs:[NSNumber numberWithInt:value_]];
}










@end
