//
//  ViewController.h
//  BluetoothCommunicationPractice
//
//  Created by Taesan Kim on 22/12/2019.
//  Copyright © 2019 Taesan Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothConnectViewController.h"

@interface ViewController : UIViewController <BluetoothConnectDelegate, BluetoothInterfaceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bluetoothConnectionStateLb;
@property (weak, nonatomic) IBOutlet UILabel *receivedStringLb;

@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

