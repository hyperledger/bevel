import React from 'react';
import { Redirect } from 'react-router-dom'
import { withStyles } from '@material-ui/core/styles';

import { Typography, Modal } from '@material-ui/core';
import QrReader from './QrReader';
import MenuBar from '../../components/MenuBar';
import api from '../../util/api/supplyChainRequests';
import styles from '../../mobileStyles';

class PackageGood extends React.Component{
  constructor({match}){
    super();

    this.state = {
      callbackError: false,
      success: false,
      redirect: false,
      path: '',
      containerID:match.params.containerID,
    };

    this.packageItem = this.packageItem.bind(this);
  }

  packageItem(qrCode){
    let contents = {contents:qrCode.trackingID}
    api.packageGood(this.state.containerID,contents)
    .then(res => {
      this.setState({
        success: true,
        path: `/container/${res}`
      });
    })
    .catch(error => {
      console.error(error);
      this.setState({ callbackError: true });
    });
  }

  handleRedirect() {
    this.setState({
      redirect: true
    });
  }

  render() {
    const { classes } = this.props;
    const { callbackError, success, redirect, path } = this.state;
    const header = (
      <div className={classes.headerTop}>
        <Typography variant='h3' className={classes.boldText}> Scan Item Below </Typography>
        <Typography variant='h6'>Hold the code infront of the camera.</Typography>
        <Typography variant='h6'> Make sure the code is well lit.</Typography>
      </div>
    );
    return(
      <div>
        {redirect ? (
          <Redirect to={path} />
        ) : null}
        <Modal
          aria-labelledby="added"
          aria-describedby="modal for newly added item"
          open={success}
          onClose={() => this.handleRedirect()}
        >
          <div className={classes.scanPaper}>
            {callbackError ? "Creation Failed" : "Added!"}
          </div>
        </Modal>
        <MenuBar title = {''} header = {header}>
          <QrReader handleScan={this.packageItem} callbackError={this.state.callbackError} />
        </MenuBar>
      </div>
    )
  }
}

export default withStyles(styles)(PackageGood);
