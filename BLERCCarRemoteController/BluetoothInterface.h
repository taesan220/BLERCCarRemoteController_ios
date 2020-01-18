//
//  BluetoothInterface.h
//  BluetoothCommunicationPractice
//
//  Created by Taesan Kim on 22/12/2019.
//  Copyright © 2019 Taesan Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BluetoothInterfaceDelegate <NSObject>

-(void) discoveredBluetoothDeviceListDelegate:(NSArray<CBPeripheral *> *) deviceList;

-(void) selectedBluetoothDeviceDelegate:(CBPeripheral *) deviceInfo;

-(void) receivedDataFromBluetoothDeviceDelegate:(NSString *)dataString;

@end

@interface BluetoothInterface : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property id<BluetoothInterfaceDelegate> delegate;

@property NSMutableArray<CBPeripheral *> *devicesList;

-(BOOL) sendStringData:(NSString *)stringData;

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (strong, nonatomic) CBPeripheral *connectedPeripheral;

-(void) searchBluetoothDevices;

/*
 @bfief 블루투스 장치와 연결을 시도하는 메소드
 */
-(void) connectWithBluetoothDevice:(CBPeripheral *)peripheral;
    
@end
