// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointModel.h instead.

#import <CoreData/CoreData.h>


extern const struct CheckPointModelAttributes {
	__unsafe_unretained NSString *bID;
	__unsafe_unretained NSString *cpID;
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *name;
} CheckPointModelAttributes;

extern const struct CheckPointModelRelationships {
} CheckPointModelRelationships;

extern const struct CheckPointModelFetchedProperties {
} CheckPointModelFetchedProperties;







@interface CheckPointModelID : NSManagedObjectID {}
@end

@interface _CheckPointModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CheckPointModelID*)objectID;





@property (nonatomic, strong) NSString* bID;



//- (BOOL)validateBID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cpID;



//- (BOOL)validateCpID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* index;



@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _CheckPointModel (CoreDataGeneratedAccessors)

@end

@interface _CheckPointModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBID;
- (void)setPrimitiveBID:(NSString*)value;




- (NSString*)primitiveCpID;
- (void)setPrimitiveCpID:(NSString*)value;




- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
