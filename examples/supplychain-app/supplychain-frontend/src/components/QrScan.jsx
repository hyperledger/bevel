import React from 'react';
import QrScanner from 'react-qr-reader'
import PropTypes from 'prop-types';

class QrScan extends React.Component{
  constructor(props){
    super(props)

    this.openImageDialog = this.openImageDialog.bind(this)
  }

  openImageDialog() {
        this.refs.qrReader1.openImageDialog()
    }
render(){
  const { legacyMode } = this.props;
    return (
      <div >
        <QrScanner ref="qrReader1"
          delay={this.props.delay}
          onError={this.props.onError}
          onScan={this.props.onScan}
          resolution={800}
          legacyMode={legacyMode}
          style={{ position:'relative',top:'-28px',zIndex:1, textAlign:'center' }}
        />
        {legacyMode?(
          <input type="button" value="Upload QR Code" onClick={this.openImageDialog.bind(this)} />):(null)}
      </div>
    );
  }
}

QrScan.propTypes = {
  legacyMode: PropTypes.bool.isRequired,
};

export default (QrScan);
