// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Word_SentenceModel.h instead.

#import <CoreData/CoreData.h>


extern const struct Word_SentenceModelAttributes {
	__unsafe_unretained NSString *sID;
	__unsafe_unretained NSString *wID;
} Word_SentenceModelAttributes;

extern const struct Word_SentenceModelRelationships {
} Word_SentenceModelRelationships;

extern const struct Word_SentenceModelFetchedProperties {
} Word_SentenceModelFetchedProperties;





@interface Word_SentenceModelID : NSManagedObjectID {}
@end

@interface _Word_SentenceModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (Word_SentenceModelID*)objectID;





@property (nonatomic, strong) NSString* sID;



//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wID;



//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;






@end

@interface _Word_SentenceModel (CoreDataGeneratedAccessors)

@end

@interface _Word_SentenceModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;




- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;




@end
