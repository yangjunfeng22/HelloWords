// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookCategoryTransModel.h instead.

#import <CoreData/CoreData.h>


extern const struct BookCategoryTransModelAttributes {
	__unsafe_unretained NSString *cID;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *tID;
} BookCategoryTransModelAttributes;

extern const struct BookCategoryTransModelRelationships {
} BookCategoryTransModelRelationships;

extern const struct BookCategoryTransModelFetchedProperties {
} BookCategoryTransModelFetchedProperties;







@interface BookCategoryTransModelID : NSManagedObjectID {}
@end

@interface _BookCategoryTransModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookCategoryTransModelID*)objectID;





@property (nonatomic, strong) NSString* cID;



//- (BOOL)validateCID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* language;



//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tID;



//- (BOOL)validateTID:(id*)value_ error:(NSError**)error_;






@end

@interface _BookCategoryTransModel (CoreDataGeneratedAccessors)

@end

@interface _BookCategoryTransModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCID;
- (void)setPrimitiveCID:(NSString*)value;




- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveTID;
- (void)setPrimitiveTID:(NSString*)value;




@end
