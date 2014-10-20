// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPoint_WordModel.m instead.

#import "_CheckPoint_WordModel.h"

const struct CheckPoint_WordModelAttributes CheckPoint_WordModelAttributes = {
	.cpID = @"cpID",
	.wID = @"wID",
};

const struct CheckPoint_WordModelRelationships CheckPoint_WordModelRelationships = {
	.cpWordShip = @"cpWordShip",
};

const struct CheckPoint_WordModelFetchedProperties CheckPoint_WordModelFetchedProperties = {
	.cpWord = @"cpWord",
};

@implementation CheckPoint_WordModelID
@end

@implementation _CheckPoint_WordModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckPoint_WordModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckPoint_WordModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckPoint_WordModel" inManagedObjectContext:moc_];
}

- (CheckPoint_WordModelID*)objectID {
	return (CheckPoint_WordModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic cpID;






@dynamic wID;






@dynamic cpWordShip;

	
- (NSMutableSet*)cpWordShipSet {
	[self willAccessValueForKey:@"cpWordShip"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"cpWordShip"];
  
	[self didAccessValueForKey:@"cpWordShip"];
	return result;
}
	



@dynamic cpWord;




@end
