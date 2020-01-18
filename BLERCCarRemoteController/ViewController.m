//
//  ViewController.m
//  BluetoothCommunicationPractice
//
//  Created by Taesan Kim on 22/12/2019.
//  Copyright © 2019 Taesan Kim. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothInterface.h"

@interface ViewController ()

@property (nonatomic, strong) BluetoothInterface *bluetoothInterface;

@property (weak) CBPeripheral *connectedDevice;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.bluetoothConnectionStateLb setText:@"장치를 연결하세요"];
    
 //   UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//                                                                                                                         [self.goButton addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
         NSLog(@"Long Press");
        //send 'g' to Bluetooth Device
        [self.bluetoothInterface sendStringData:@"g"];
    } else if (gesture.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"Long Cancel");
        //send 'g' to Bluetooth Device
        [self.bluetoothInterface sendStringData:@"s"];
    } else if (gesture.state == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Long Cancel");
        //send 'g' to Bluetooth Device
        [self.bluetoothInterface sendStringData:@"s"];
    }
}

#pragma Bluetooth Connection
- (IBAction)showDevicesListButtonTouched:(id)sender {
    
    if (self.bluetoothInterface == nil) {
        self.bluetoothInterface = [[BluetoothInterface alloc] init];
    }
    [self performSegueWithIdentifier:@"devicesList" sender:self];
    
    [self.bluetoothConnectionStateLb setText:@"장치를 연결하세요"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BluetoothConnectViewController *bluetoothConnect = segue.destinationViewController;
    bluetoothConnect.delegate = self;
    bluetoothConnect.bluetoothInterface = self.bluetoothInterface;
}

//블루투스 장치와 연결 성공시 호출되는 델리게이트 메소드
- (void)selectedDeviceDelegate:(BluetoothInterface *)bluetoothInterface deviceName:(NSString *)deviceName {
    self.bluetoothInterface = bluetoothInterface;
    [self.bluetoothConnectionStateLb setText:[NSString stringWithFormat:@"Connected Device : %@", deviceName]];
    self.bluetoothInterface.delegate = self;
}

//블루투스 장치로 부터 String Data를 전송 받았을 때 호출되는 델리게이트 메소드
- (void)receivedDataFromBluetoothDeviceDelegate:(NSString *)dataString {
    [self.receivedStringLb setText:[NSString stringWithFormat:@"Received String : %@", dataString]];
}

#pragma Controll

- (IBAction)leftButtonTouching:(id)sender {
    [self.bluetoothInterface sendStringData:@"l"];
}

- (IBAction)rightButtonTouching:(id)sender {
    [self.bluetoothInterface sendStringData:@"r"];
}

- (IBAction)directionChangeButtonCancled:(id)sender {
    [self.bluetoothInterface sendStringData:@"m"];
}


- (IBAction)goButtonTouched:(id)sender {
    //send 'g' to Bluetooth Device
    [self.bluetoothInterface sendStringData:@"g"];

}
- (IBAction)leftButtonTouched:(id)sender {
    [self.bluetoothInterface sendStringData:@"l"];
}
- (IBAction)rightButtonTouched:(id)sender {
    //send 'r' to Bluetooth Device
    
    [self.bluetoothInterface sendStringData:@"r"];
    
}

- (IBAction)goButtonTouching:(id)sender {
    [self.bluetoothInterface sendStringData:@"g"];
    
}

- (IBAction)backButtonTouching:(id)sender {
    //send 'b' to Bluetooth Device
    [self.bluetoothInterface sendStringData:@"b"];

}

- (IBAction)moveButtonTouchCancled:(id)sender {
    //send 's' to Bluetooth Device
     [self.bluetoothInterface sendStringData:@"s"];
    
}
@end
