import React from 'react';
import { QRCode } from 'react-qr-svg';
import PropTypes from 'prop-types';


function NewQrCode(props){
  const {jsonInput} = props;
  return(
    <QRCode
            level="Q"
            style={{ width: 256 }}
            value={JSON.stringify(jsonInput)}
          />
  )
}
NewQrCode.propTypes = {
  jsonInput: PropTypes.object
}

export default NewQrCode;
