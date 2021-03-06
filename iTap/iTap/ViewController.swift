//
//  ViewController.swift
//  iTap
//
//  Created by Fedor Sheremetyev on 03/03/2018.
//  Copyright © 2018 Elizaveta Sheremetyeva. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, StreamDelegate {
  @IBOutlet weak var log: UITextView!
  @IBOutlet weak var message: UITextField!
  @IBOutlet weak var serverAddress: UITextField!

  var centralManager:CBCentralManager!
  var sensorTag:CBPeripheral?
  var readCharacteristic:CBCharacteristic?

  var inputStream: InputStream!
  var outputStream: OutputStream!
  var blunoName: String!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
  }

  @IBAction func connectBluno1(_ sender: UIButton) {
    blunoName="Bluno1"
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  @IBAction func connectBluno2(_ sender: UIButton) {
    blunoName="Bluno2"
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  @IBAction func connectServer(_ sender: UIButton) {
    let address = serverAddress.text!;

    // connect to server
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?

    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
      address as CFString,
      8888, &readStream, &writeStream)

    inputStream = readStream!.takeRetainedValue()
    outputStream = writeStream!.takeRetainedValue()

    // receive notifications when data is received
    inputStream.delegate = self

    inputStream.schedule(in: .current, forMode: .commonModes)
    outputStream.schedule(in: .current, forMode: .commonModes)

    inputStream.open()
    outputStream.open()

    log.insertText("Connecting to server\n")
  }

  @IBAction func tapFriend(_ sender: UIButton) {
    var text = message.text!
    if text == "" {
      text = "Buzz"
    }

    if (outputStream != nil)
    {
      let data = (text + "\n").data(using: .ascii)!
      _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
      log.insertText("You sent: " + text + "\n")
    }
    else
    {
      log.insertText("Not connected to server\n")
    }
  }

  // notification when message from server received
  func stream(_ stream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case .hasBytesAvailable:
      let inputStream = stream as! InputStream
      while inputStream.hasBytesAvailable {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        let numberOfBytesRead = inputStream.read(buffer, maxLength: 1024)
        if numberOfBytesRead < 0 {
          if let _ = stream.streamError { break }
        }
        let str = String(bytesNoCopy: buffer, length: numberOfBytesRead,
          encoding: .utf8, freeWhenDone: true)
        if str != "HELLO\n" {
          log.insertText("They sent: " + str!)
          // notify Bluno
          let bytes = "X".data(using: .utf8)
          sensorTag?.writeValue(bytes!, for: readCharacteristic!, type: .withResponse)
        } else {
          log.insertText("Connected to server\n")
        }
      }
    case .endEncountered:
      log.insertText("connection endEncountered\n")
    case .errorOccurred:
      log.insertText("connection errorOccurred\n")
    default:
      print("")
    }
  }

  @IBAction func tapSelf(_ sender: UIButton) {
    log.insertText("Tapped self\n")
    if (readCharacteristic != nil)
    {
      let bytes = "X".data(using: .utf8)
      sensorTag?.writeValue(bytes!, for: readCharacteristic!, type: .withResponse)
    }
    else
    {
      log.insertText("No characteristic\n")
    }
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
      log.insertText("Bluetooth is switched off\n")
    case .poweredOn:
      log.insertText("Bluetooth is switched on\n")
      centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
  }

  // notification when device is discovered
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
      if peripheralName == blunoName
      {
        log.insertText("Connected to " + blunoName + "\n")
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
        peripheral.discoverCharacteristics(nil, for: service)
      }
    }
  }

  // notification when characteristic is discovered
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let characteristics = service.characteristics {
      for characteristic in characteristics {
        // DFB1 and DFB2
        if characteristic.uuid.uuidString == "DFB1" {
          readCharacteristic = characteristic
          // enable notifications from characteristic
          sensorTag?.setNotifyValue(true, for: characteristic)

          log.insertText("Discovered characteristics\n")
        }
      }
    }
  }

  // notification when value is received from characteristic
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let dataBytes = characteristic.value {
      let str = String(data: dataBytes, encoding: .utf8)
      print(str!)

      // send message to server
      if (outputStream != nil)
      {
        let text = "Buzz";
        let data = (text + "\n").data(using: .ascii)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
        log.insertText("You sent: " + text + "\n")
      }
      else
      {
        log.insertText("Not connected to server\n")
      }
    }
  }

}

