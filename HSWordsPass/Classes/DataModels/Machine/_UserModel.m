// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserModel.m instead.

#import "_UserModel.h"

const struct UserModelAttributes UserModelAttributes = {
	.canMove = @"canMove",
	.email = @"email",
	.enabled = @"enabled",
	.laterLogin = @"laterLogin",
	.level = @"level",
	.location = @"location",
	.logined = @"logined",
	.name = @"name",
	.nick = @"nick",
	.picture = @"picture",
	.userID = @"userID",
};

const struct UserModelRelationships UserModelRelationships = {
};

const struct UserModelFetchedProperties UserModelFetchedProperties = {
};

@implementation UserModelID
@end

@implementation _UserModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserModel" inManagedObjectContext:moc_];
}

- (UserModelID*)objectID {
	return (UserModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"canMoveValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"canMove"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"enabledValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"enabled"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"laterLoginValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"laterLogin"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"loginedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"logined"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic canMove;



- (BOOL)canMoveValue {
	NSNumber *result = [self canMove];
	return [result boolValue];
}

- (void)setCanMoveValue:(BOOL)value_ {
	[self setCanMove:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCanMoveValue {
	NSNumber *result = [self primitiveCanMove];
	return [result boolValue];
}

- (void)setPrimitiveCanMoveValue:(BOOL)value_ {
	[self setPrimitiveCanMove:[NSNumber numberWithBool:value_]];
}





@dynamic email;






@dynamic enabled;



- (BOOL)enabledValue {
	NSNumber *result = [self enabled];
	return [result boolValue];
}

- (void)setEnabledValue:(BOOL)value_ {
	[self setEnabled:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveEnabledValue {
	NSNumber *result = [self primitiveEnabled];
	return [result boolValue];
}

- (void)setPrimitiveEnabledValue:(BOOL)value_ {
	[self setPrimitiveEnabled:[NSNumber numberWithBool:value_]];
}





@dynamic laterLogin;



- (int32_t)laterLoginValue {
	NSNumber *result = [self laterLogin];
	return [result intValue];
}

- (void)setLaterLoginValue:(int32_t)value_ {
	[self setLaterLogin:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLaterLoginValue {
	NSNumber *result = [self primitiveLaterLogin];
	return [result intValue];
}

- (void)setPrimitiveLaterLoginValue:(int32_t)value_ {
	[self setPrimitiveLaterLogin:[NSNumber numberWithInt:value_]];
}





@dynamic level;






@dynamic location;






@dynamic logined;



- (BOOL)loginedValue {
	NSNumber *result = [self logined];
	return [result boolValue];
}

- (void)setLoginedValue:(BOOL)value_ {
	[self setLogined:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLoginedValue {
	NSNumber *result = [self primitiveLogined];
	return [result boolValue];
}

- (void)setPrimitiveLoginedValue:(BOOL)value_ {
	[self setPrimitiveLogined:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic nick;






@dynamic picture;






@dynamic userID;











@end
