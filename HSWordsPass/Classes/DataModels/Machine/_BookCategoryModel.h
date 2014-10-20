// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookCategoryModel.h instead.

#import <CoreData/CoreData.h>


extern const struct BookCategoryModelAttributes {
	__unsafe_unretained NSString *cID;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *weight;
} BookCategoryModelAttributes;

extern const struct BookCategoryModelRelationships {
} BookCategoryModelRelationships;

extern const struct BookCategoryModelFetchedProperties {
} BookCategoryModelFetchedProperties;







@interface BookCategoryModelID : NSManagedObjectID {}
@end

@interface _BookCategoryModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookCategoryModelID*)objectID;





@property (nonatomic, strong) NSString* cID;



//- (BOOL)validateCID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* picture;



//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weight;



@property int32_t weightValue;
- (int32_t)weightValue;
- (void)setWeightValue:(int32_t)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;






@end

@interface _BookCategoryModel (CoreDataGeneratedAccessors)

@end

@interface _BookCategoryModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCID;
- (void)setPrimitiveCID:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;




- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (int32_t)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(int32_t)value_;




@end
