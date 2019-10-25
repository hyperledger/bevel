import React from 'react';
import {osName} from "react-device-detect";
import QrScan from "../../components/QrScan";


class QrReader extends React.Component{
  constructor({match}){
    super();
    this.state = {
      delay: 500,
      scanning: true,
      qrCodeJson: {},
      legacyMode:true,
    };
    this.handleScan = this.handleScan.bind(this);
    this.successCallback = this.successCallback.bind(this);
    this.errorCallback = this.errorCallback.bind(this);

  }

  successCallback (error) {
    // user allowed access to camera
    this.setState({legacyMode:false});
  };
  errorCallback (error) {
    if (error.name === 'NotAllowedError') {
      this.setState({legacyMode:true});
    }
  };

  componentDidMount(){
    navigator.mediaDevices.getUserMedia({video:true})
      .then(this.successCallback, this.errorCallback);

    if (osName === 'Windows'){
      this.setState({legacyMode:true});

    }
  }

  //Handlers
  handleScan(data) {
    if(data) {
      this.setState({
        scanning: false,
        qrCodeJson: JSON.parse(data)
      });
      this.props.handleScan(JSON.parse(data));
    }
  }

  handleError(err) {
    console.error(err);
  }

  render() {
    const { scanning } = this.state;

    return (
      <div >
        {scanning ? (
          <QrScan
            delay={this.state.delay}
            onError={this.handleError}
            onScan={this.handleScan}
            legacyMode={this.state.legacyMode}
          />
        ) : null}
      </div>
    )
  }
}

export default (QrReader);
