// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPoint_WordModel.h instead.

#import <CoreData/CoreData.h>


extern const struct CheckPoint_WordModelAttributes {
	__unsafe_unretained NSString *cpID;
	__unsafe_unretained NSString *wID;
} CheckPoint_WordModelAttributes;

extern const struct CheckPoint_WordModelRelationships {
	__unsafe_unretained NSString *cpWordShip;
} CheckPoint_WordModelRelationships;

extern const struct CheckPoint_WordModelFetchedProperties {
	__unsafe_unretained NSString *cpWord;
} CheckPoint_WordModelFetchedProperties;

@class WordModel;




@interface CheckPoint_WordModelID : NSManagedObjectID {}
@end

@interface _CheckPoint_WordModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CheckPoint_WordModelID*)objectID;





@property (nonatomic, strong) NSString* cpID;



//- (BOOL)validateCpID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wID;



//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *cpWordShip;

- (NSMutableSet*)cpWordShipSet;




@property (nonatomic, readonly) NSArray *cpWord;


@end

@interface _CheckPoint_WordModel (CoreDataGeneratedAccessors)

- (void)addCpWordShip:(NSSet*)value_;
- (void)removeCpWordShip:(NSSet*)value_;
- (void)addCpWordShipObject:(WordModel*)value_;
- (void)removeCpWordShipObject:(WordModel*)value_;

@end

@interface _CheckPoint_WordModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCpID;
- (void)setPrimitiveCpID:(NSString*)value;




- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;





- (NSMutableSet*)primitiveCpWordShip;
- (void)setPrimitiveCpWordShip:(NSMutableSet*)value;


@end
