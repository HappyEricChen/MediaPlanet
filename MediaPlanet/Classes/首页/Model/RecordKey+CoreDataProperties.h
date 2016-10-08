//
//  RecordKey+CoreDataProperties.h
//  
//
//  Created by jamesczy on 16/8/4.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RecordKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordKey (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *keyWord;

@end

NS_ASSUME_NONNULL_END
