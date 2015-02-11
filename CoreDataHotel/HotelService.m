//
//  HotelService.m
//  CoreDataHotel
//
//  Created by Bradley Johnson on 2/10/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "HotelService.h"

@interface HotelService ()



@end

@implementation HotelService

+ (id)sharedService {
  static HotelService *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

-(instancetype)initForTesting {
  self = [super init];
  if (self) {
    self.coreDataStack = [[CoreDataStack alloc] initForTesting];
  }
  return self;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    self.coreDataStack = [[CoreDataStack alloc] init];
  }
  return self;
}

-(Reservation*)bookReservationForGuest:(Guest*)guest ForRoom:(Room *)room forStartDate:(NSDate *)startDate andEndDate:(NSDate*)endDate {
  
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  reservation.room = room;
  reservation.guest = guest;
  reservation.startDate = startDate;
  reservation.endDate = endDate;
  NSError *error;
  [self.coreDataStack.managedObjectContext save:&error];
  if (error) {
    NSLog(@"%@",error.localizedDescription);
    return nil;
  }
  return reservation;
}

@end
