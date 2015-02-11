//
//  HotelServiceTests.m
//  CoreDataHotel
//
//  Created by Bradley Johnson on 2/10/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "Hotel.h"
#import "Guest.h"


@interface HotelServiceTests : XCTestCase

@property (strong,nonatomic) HotelService *hotelService;
@property (strong,nonatomic) Hotel *testHotel;
@property (strong,nonatomic) Room *testRoom;
@property (strong,nonatomic) Guest *testGuest;

@end

@implementation HotelServiceTests

- (void)setUp {
    [super setUp];
  self.hotelService = [[HotelService alloc] initForTesting];
  
   self.testHotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
   self.testHotel.name = @"Fake Hotel";
   self.testHotel.location = @"Fakeville";
   self.testHotel.rating = @4;
  
  self.testRoom = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
   self.testRoom.number = @101;
   self.testRoom.rate = @1;
   self.testRoom.beds = @2;
   self.testRoom.hotel = self.testHotel;
  
  self.testGuest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.testGuest.firstName = @"Testy";
  self.testGuest.lastName = @"MCTestorson";
  
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  self.hotelService = nil;
  self.testHotel = nil;
  self.testRoom = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

-(void)testBookReservationWithValidDates {
  NSDate *start = [NSDate date];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day++;
  NSDate *end = [calendar dateByAddingComponents:components toDate:start options:0];
  
  Reservation *reservation = [self.hotelService bookReservationForGuest:self.testGuest ForRoom:self.testRoom forStartDate:start andEndDate:end];
  
  XCTAssertNotNil(reservation,@"reservation should not be nil");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
