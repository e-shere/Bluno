/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  FlatList,
  Button
} from 'react-native';
import { BleManager } from 'react-native-ble-plx';

export default class App extends Component<{}> {
  constructor() {
    super();
    this.manager = new BleManager();
    this.state = { devices: [], enabled: false };
  }

  componentDidMount() {
    const subscription = this.manager.onStateChange((state) => {
      if (state === 'PoweredOn') {
        this.setState({ enabled: true });
      } else {
        this.setState({ enabled: false });
      }
    }, true);
  }

  async writeRead(device_id) {
    serviceUUID = '0000dfb0-0000-1000-8000-00805f9b34fb';
    characteristicUUID = '0000dfb1-0000-1000-8000-00805f9b34fb';

    await this.manager.connectToDevice(device_id);
    await this.manager.discoverAllServicesAndCharacteristicsForDevice(device_id);
    await this.manager.writeCharacteristicWithoutResponseForDevice(
      device_id, serviceUUID, characteristicUUID, 'QQ==');
    var characteristic = await this.manager.readCharacteristicForDevice(
      device_id, serviceUUID, characteristicUUID);
    console.warn(characteristic.value);
    await this.manager.cancelDeviceConnection(device_id);
  }

  scanDevices() {
    this.manager.stopDeviceScan();
    this.setState({ devices: [] });

    if (this.state.enabled) {
      this.manager.startDeviceScan(null, null, (error, device) => {
        if (error) {
          console.warn(error);
          return;
        }

        var devices = this.state.devices;
        if (devices.filter(item => item.key == device.id).length == 0) {
          devices = devices.concat([{ name: device.name, key: device.id }]);
          this.setState({ devices: devices });
          this.writeRead(device.id);
        }
      });
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to Bluno!!!
        </Text>
        <Text>
          Bluetooth: { this.state.enabled ? 'Enabled' : 'Disabled' }
        </Text>
        <Button title='Scan'
          onPress={ () => this.scanDevices() } />
        <FlatList style={styles.list}
          data = { this.state.devices }
          renderItem={({item}) => <Text style={styles.item}>{item.name} {item.key}</Text>}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 100,
  },
  list: {
  },
  item: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
