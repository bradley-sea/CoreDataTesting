//
//  HotelService.h
//  CoreDataHotel
//
//  Created by Bradley Johnson on 2/10/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "Room.h"
#import "Reservation.h"

@interface HotelService : NSObject
@property (strong,nonatomic) CoreDataStack *coreDataStack;

-(instancetype)initForTesting;

-(Reservation*)bookReservationForGuest:(Guest*)guest ForRoom:(Room *)room forStartDate:(NSDate *)startDate andEndDate:(NSDate*)endDate;

+ (id)sharedService;


@end
