//
//  CoreDataStack.m
//  CoreDataHotel
//
//  Created by Bradley Johnson on 2/10/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"

@implementation CoreDataStack


-(instancetype)initForTesting {
  self = [super init];
  if (self) {
    self.testing = true;
  }
  return self;
}

-(instancetype)init {
  
  self = [super init];
  if (self) {
    [self seedDataBaseIfNeeded];
  }
  return self;
}

-(NSManagedObjectContext *)managedObjectContext {
  
  if (! _managedObjectContext) {
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
  }
  return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (! _persistentStoreCoordinator) {
    
    //load the MOM file
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataHotel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //setup the PSC
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataHotel.sqlite"];
    NSError *error = nil;
    NSString *storeType;
    if (self.testing) {
      storeType = NSInMemoryStoreType;
    } else {
      storeType = NSSQLiteStoreType;
    }
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error];
    if (!store) {
      NSLog(@"failed to add the persistent store");
      abort();
    }
    
  }
  return _persistentStoreCoordinator;
}

-(void)seedDataBaseIfNeeded {
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  
  NSInteger results = [self.managedObjectContext countForFetchRequest:fetchRequest error:&fetchError];
  
  if (results == 0) {
    
    NSURL * seedURL = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
    NSData *seedData = [[NSData alloc] initWithContentsOfURL:seedURL];
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:seedData options:0 error:&error];
    if (!error) {
      NSArray *hotelsArray = jsonDictionary[@"Hotels"];
      
      for (NSDictionary *hotelDictionary in hotelsArray) {
        Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:_managedObjectContext];
        hotel.name = hotelDictionary[@"name"];
        hotel.rating = hotelDictionary[@"stars"];
        hotel.location = hotelDictionary[@"location"];
        
        NSArray *roomsArray = hotelDictionary[@"rooms"];
        
        for (NSDictionary *roomDictionary in roomsArray) {
          Room *room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:_managedObjectContext];
          room.number = roomDictionary[@"number"];
          room.beds = roomDictionary[@"beds"];
          room.rate = roomDictionary[@"rate"];
          room.hotel = hotel;
        }
      }
      
    }
    
    
    NSError *saveError;
    [_managedObjectContext save:&saveError];
    
    
    if (saveError) {
      NSLog(@" %@",saveError.localizedDescription);
    }
  }
}

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "BPJ.HotelReservations" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
