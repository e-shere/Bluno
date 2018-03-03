//
//  ViewController.swift
//  iTap
//
//  Created by Fedor Sheremetyev on 03/03/2018.
//  Copyright © 2018 Elizaveta Sheremetyeva. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
  @IBOutlet weak var textView: UITextView!

  var centralManager:CBCentralManager!
  var sensorTag:CBPeripheral?
  var readCharacteristic:CBCharacteristic?

  override func viewDidLoad() {
    super.viewDidLoad()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func buzz(_ sender: UIButton) {
    textView.insertText("hello\n")
  }

  // notification from Bluetooth controller when it's on/off
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .unknown:
      print("unknown")
    case .resetting:
      print("resetting")
    case .unsupported:
      print("unsupported")
    case .unauthorized:
      print("unauthorized")
    case .poweredOff:
      print("poweredOff")
    case .poweredOn:
      print("poweredOn")
      centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
  }

  // notification when device is discovered
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
      if peripheralName == "Bluno"
      {
        sensorTag = peripheral
        sensorTag!.delegate = self
        centralManager.connect(sensorTag!, options: nil)
      }
    }
  }

  // notification of failure connecting to device
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    print("failed to connect!")
  }

  // notification of successful connection to device
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    peripheral.discoverServices(nil)
  }

  // notification when service is discovered
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if let services = peripheral.services {
      for service in services {
        // DFB0
        print("service ", service.uuid)
        peripheral.discoverCharacteristics(nil, for: service)
      }
    }
  }

  // notification when characteristic is discovered
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let characteristics = service.characteristics {
      for characteristic in characteristics {
        // DFB1 and DFB2
        print("characteristic ", characteristic.uuid)
        if characteristic.uuid.uuidString == "DFB1" {
          readCharacteristic = characteristic
          // enable notifications from characteristic
          sensorTag?.setNotifyValue(true, for: characteristic)
        }
      }
    }
  }

  // notification when value is received from characteristic
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let dataBytes = characteristic.value {
      let str = String(data: dataBytes, encoding: .utf8)
      print(str!)
    }
  }

}

