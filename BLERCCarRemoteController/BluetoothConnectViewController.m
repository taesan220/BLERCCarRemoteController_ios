//
//  BluetoothConnectViewController.m
//  BluetoothCommunicationPractice
//
//  Created by Taesan Kim on 22/12/2019.
//  Copyright © 2019 Taesan Kim. All rights reserved.
//

#import "BluetoothConnectViewController.h"
@interface BluetoothConnectViewController()
@property NSMutableArray<CBPeripheral *> *devicesList;
@end


@implementation BluetoothConnectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bluetoothInterface != nil) {
        NSLog(@"블루투스 시작");
        
        self.bluetoothInterface.delegate = self;

        [self.bluetoothInterface searchBluetoothDevices];
    }
}

- (IBAction)searchBluetoothDeviceButtonTouched:(id)sender {
    
    [self.bluetoothInterface searchBluetoothDevices];
}

- (void)discoveredBluetoothDeviceListDelegate:(NSMutableArray<CBPeripheral *> *)deviceList {
    self.devicesList = self.bluetoothInterface.devicesList;
    [self.devicesTV reloadData];
}

#pragma TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.devicesList == nil) {
        return 0;
    }
    return self.devicesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CBPeripheral *peripheral = self.devicesList[indexPath.row];
        
    [cell.textLabel setText: peripheral.name];
    
    return cell;
}

//블루투스 디바이스와의 연결 성공시 호출되는 메소드
-(void)selectedBluetoothDeviceDelegate:(CBPeripheral *)deviceInfo {
    NSLog(@"들어옴");
    
    [self.delegate selectedDeviceDelegate: self.bluetoothInterface deviceName: deviceInfo.name];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBPeripheral *per = self.devicesList[indexPath.row];
    NSLog(@"%@", per);
    
    //메인 뷰에 디바이스 명 전달
 //   [self.delegate selectedDeviceDelegate:per.name];
    
    //블루투스 장치 연결
    [self.bluetoothInterface connectWithBluetoothDevice:per];
}


@end
