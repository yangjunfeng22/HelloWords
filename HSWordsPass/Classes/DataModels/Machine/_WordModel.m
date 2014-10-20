// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordModel.m instead.

#import "_WordModel.h"

const struct WordModelAttributes WordModelAttributes = {
	.audio = @"audio",
	.chinese = @"chinese",
	.picture = @"picture",
	.pinyin = @"pinyin",
	.property = @"property",
	.tAudio = @"tAudio",
	.wID = @"wID",
};

const struct WordModelRelationships WordModelRelationships = {
	.wordCpShip = @"wordCpShip",
};

const struct WordModelFetchedProperties WordModelFetchedProperties = {
	.wordCheckpoint = @"wordCheckpoint",
};

@implementation WordModelID
@end

@implementation _WordModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WordModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WordModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WordModel" inManagedObjectContext:moc_];
}

- (WordModelID*)objectID {
	return (WordModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic audio;






@dynamic chinese;






@dynamic picture;






@dynamic pinyin;






@dynamic property;






@dynamic tAudio;






@dynamic wID;






@dynamic wordCpShip;

	



@dynamic wordCheckpoint;




@end
