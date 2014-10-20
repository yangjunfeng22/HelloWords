// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Word_SentenceModel.m instead.

#import "_Word_SentenceModel.h"

const struct Word_SentenceModelAttributes Word_SentenceModelAttributes = {
	.sID = @"sID",
	.wID = @"wID",
};

const struct Word_SentenceModelRelationships Word_SentenceModelRelationships = {
};

const struct Word_SentenceModelFetchedProperties Word_SentenceModelFetchedProperties = {
};

@implementation Word_SentenceModelID
@end

@implementation _Word_SentenceModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Word_SentenceModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Word_SentenceModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Word_SentenceModel" inManagedObjectContext:moc_];
}

- (Word_SentenceModelID*)objectID {
	return (Word_SentenceModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic sID;






@dynamic wID;











@end
