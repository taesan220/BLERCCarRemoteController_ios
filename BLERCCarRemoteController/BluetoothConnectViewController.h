//
//  BluetoothConnectViewController.h
//  BluetoothCommunicationPractice
//
//  Created by Taesan Kim on 22/12/2019.
//  Copyright © 2019 Taesan Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothInterface.h"

@protocol BluetoothConnectDelegate <NSObject>

-(void) selectedDeviceDelegate: (BluetoothInterface *) bluetoothInterface deviceName:(NSString *)deviceName;

@end

@interface BluetoothConnectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BluetoothInterfaceDelegate>

@property id<BluetoothConnectDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *devicesTV;

//@property id<BluetoothDeviceDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *deviceConnectionBtn;

@property (nonatomic, strong) BluetoothInterface *bluetoothInterface;

@end
