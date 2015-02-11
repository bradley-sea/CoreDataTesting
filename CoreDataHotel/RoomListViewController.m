//
//  RoomListViewController.m
//  CoreDataHotel
//
//  Created by Bradley Johnson on 2/10/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "RoomListViewController.h"
#import "Room.h"
#import "AddReservationViewController.h"

@interface RoomListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *rooms;

@end

@implementation RoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.rooms = self.selectedHotel.rooms.allObjects;
  self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROOM_CELL" forIndexPath:indexPath];
  Room *room = self.rooms[indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@",room.number];
  return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SHOW_RESERVATION"]) {
    AddReservationViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    Room *room = self.rooms[indexPath.row];
    destinationVC.selectedRoom = room;
  }
}

@end
