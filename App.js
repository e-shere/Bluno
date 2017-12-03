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

  scanDevices() {
    this.setState({ devices: [] });

    if (this.state.enabled) {
      this.manager.startDeviceScan(null, null, (error, device) => {
        if (error) {
          console.warn(error);
          return;
        }

        this.setState({ devices: this.state.devices.concat([
          { name: device.name, key: device.id }
        ]) });
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
