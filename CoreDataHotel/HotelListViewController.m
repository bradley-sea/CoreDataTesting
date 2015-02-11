//
//  HotelListViewController.m
//  CoreDataHotel
//
//  Created by Bradley Johnson on 2/9/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "HotelListViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "RoomListViewController.h"
#import "HotelService.h"

@interface HotelListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *hotels;

@end

@implementation HotelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.dataSource = self;
//  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//  NSManagedObjectContext *context = appDelegate.managedObjectContext;

  HotelService *hotelService = [[HotelService alloc] init];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  //you could create a predicate here
  NSError *fetchError;
  
  NSArray *results = [hotelService.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  if (!fetchError) {
    self.hotels = results;
    [self.tableView reloadData];
  }
  
  
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.hotels) {
    return self.hotels.count;
  } else {
    return 0;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOTEL_CELL" forIndexPath:indexPath];
  Hotel *hotel = self.hotels[indexPath.row];
  cell.textLabel.text = hotel.name;
  return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SHOW_ROOMS"]) {
    RoomListViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    Hotel *hotel = self.hotels[indexPath.row];
    destinationVC.selectedHotel = hotel;
  }
}

@end
