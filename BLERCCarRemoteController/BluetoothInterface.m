//
//  BluetoothInterface.m
//  BluetoothCommunicationPractice
//
//  Created by Taesan Kim on 22/12/2019.
//  Copyright © 2019 Taesan Kim. All rights reserved.
//

#import "BluetoothInterface.h"
@interface BluetoothInterface()

@property (strong, nonatomic) NSMutableData *data;

@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;

@property (strong, nonatomic) CBMutableCharacteristic *cbCharacteristic;

@property (strong, nonatomic) NSString *connectedDeviceUUID;

@property BOOL isBluetoothSearching;

@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;

@property (nonatomic) CBCharacteristicWriteType *charactersticWriteType;

@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *characteristicUUID;

@end


@implementation BluetoothInterface

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBluetoothInterface];
    }
    return self;
}

-(void) initBluetoothInterface {
    self.isBluetoothSearching = false;
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager.delegate = self;
    self.data = [[NSMutableData alloc] init];
    
    self.serviceUUID = [CBUUID UUIDWithString:@"FFE0"];
    self.characteristicUUID = [CBUUID UUIDWithString:@"FFE1"];
}

#pragma Bluetooth
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        NSLog(@"Bluetooth ON");
      
        [self searchBluetoothDevices];  //블루투스 장치 검색

    } else {
        NSLog(@"Bluetooth OFF");
        
        [self.centralManager stopScan];
        self.isBluetoothSearching = NO;
    }
}

//블루투스 장치 검색
-(void) searchBluetoothDevices {
    
    //연결된 장치가 있다면 disconnect
    if (self.connectedPeripheral != nil){
        [self.centralManager cancelPeripheralConnection: self.connectedPeripheral];
        self.connectedPeripheral = nil;
    }
    
    self.discoveredPeripheral = nil;
    
    self.devicesList = [[NSMutableArray alloc] init];
    
    //연결할때까지 블루 투스 장지를 계속 검색하는 옵션
    NSDictionary *scanOption = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

    [self.centralManager scanForPeripheralsWithServices:@[self.serviceUUID] options: nil];
    
    self.isBluetoothSearching = YES;
}

//장치를 감지하면 호출
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
        
    NSLog(@"descovered device  = %@", peripheral.name.capitalizedString);
    
    if (self.discoveredPeripheral != peripheral) {
                
        self.discoveredPeripheral = [peripheral copy];
        
        [self.devicesList addObject:peripheral];
        
        [self.delegate discoveredBluetoothDeviceListDelegate:self.devicesList];
    }
}

//블루투스 장치와 연결을 시도하는 메소드
-(void) connectWithBluetoothDevice:(CBPeripheral *)peripheral {
    
    [self.centralManager connectPeripheral:peripheral options:nil];
}



//블루투스 연결 성공시 호출 되는 델리게이트 메소드
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager stopScan];
    self.connectedPeripheral = peripheral;
    peripheral.delegate = self;

    self.connectedDeviceUUID = peripheral.identifier.UUIDString;

    [self.connectedPeripheral discoverServices:@[self.serviceUUID]];
}

//블루투스 연결 실패시 호출 되는 델리게이트 메소드
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"블루투스 연결 실패");
    self.connectedPeripheral = nil;
    self.discoveredPeripheral = nil;
    [self.centralManager stopScan];
}

//Peripheral 으로 부터 서비스를 찾는 델리게이트 메소드
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {

    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
    return;
}

//서비스로 부터 케릭터리스틱을 찾는 델리게이트 메소드
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"Characteristic uuid === %@", characteristic.UUID);
        NSLog(@"Characteristic uuid === %@",  self.characteristicUUID);

        if ([characteristic.UUID.UUIDString isEqualToString: self.characteristicUUID.UUIDString]) {
            [peripheral setNotifyValue:true forCharacteristic:characteristic];
            
            //keep a reference to this characteristic so we can write to it
            self.writeCharacteristic = characteristic;
            
            self.charactersticWriteType = CBCharacteristicWriteWithoutResponse;
            
            [self.delegate selectedBluetoothDeviceDelegate:self.connectedPeripheral];
        }
    }
}

//블루투스 장치로 String 데이터를 보내는 메소드
-(BOOL) sendStringData:(NSString *)stringData {
    if ([self.connectedPeripheral canSendWriteWithoutResponse]) {
        

        NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];

        [self.connectedPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        
        return true;
    }
    
    return false;
}

//블루투스 장치로 데이터를 전송 완료 했을때 호출되는 델리게이트 메소드
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"Write");
}

//블루투스 장치로 부터 값을 전송 받을때 호출되는 델리게이트 메소드
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSDate *receivedData = characteristic.value;
    
    NSString *dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
    if (dataString != nil) {
        //'/n' 문자 제거
        dataString = [dataString substringToIndex: dataString.length - 1];
        //받은 데이터 스트링을 메인으로 전송
        [self.delegate receivedDataFromBluetoothDeviceDelegate:dataString];
    }
}

@end
