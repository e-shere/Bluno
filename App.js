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
  View
} from 'react-native';
import { BleManager } from 'react-native-ble-plx';

export default class App extends Component<{}> {
  constructor() {
    super();
    this.manager = new BleManager();
    this.state = { deviceName: 'UNKNOWN' };
  }

  componentWillMount() {
    const subscription = this.manager.onStateChange((state) => {
      console.warn('state: ' + state);
      if (state === 'PoweredOn') {
        this.scanAndConnect();
        subscription.remove();
      }
    }, true);
  }

  scanAndConnect() {
    this.manager.startDeviceScan(null, null, (error, device) => {
      if (error) {
        return;
      }

      this.setState({ deviceName: device.name + ' ' + device.id });
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to Bluno!!!
        </Text>
        <Text style={styles.device}>
          {this.state.deviceName}
        </Text>
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
    margin: 10,
  },
  device: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
