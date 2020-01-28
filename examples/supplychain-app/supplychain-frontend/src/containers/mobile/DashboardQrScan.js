import React from 'react';
import { Redirect } from 'react-router-dom'
import { withStyles } from '@material-ui/core/styles';
import { Typography, Modal } from '@material-ui/core';
import QrReader from './QrReader';
import MenuBar from '../../components/MenuBar';
import api from '../../util/api/supplyChainRequests';
import styles from '../../mobileStyles';

class DashboardQrScan extends React.Component{
  constructor({match}){
    super();
    this.state = {
      callbackError: false,
      success: false,
      redirect: false,
      path: '/',
      scanResult:'',
      response:'Added!'
    };
    this.scanItem=this.scanItem.bind(this);
    this.createProducts=this.createProducts.bind(this);
    this.createContainers=this.createContainers.bind(this);
    this.receiveContainer=this.receiveContainer.bind(this);
    this.receiveProduct=this.receiveProduct.bind(this);
    this.goToProductInfo=this.goToProductInfo.bind(this);
    this.goToContainerInfo=this.goToContainerInfo.bind(this);

  }
  //API Calls

  //Api call to generate product
  createProducts(productRequestBody){
    api.newProduct(productRequestBody)
    .then(res => {
      this.setState({
        success: true,
        path: `/product/${res.generatedID}`,
        response: 'Product Created!',
      });
    })
    .catch(error => {
      console.error(error);
      this.setState({ callbackError: true });
    });
  }

  //Api call to generate container
  createContainers(containerRequestBody) {
    api.newContainer(containerRequestBody)
    .then(res => {
      this.setState({
        success: true,
        path: `/container/create/${res.generatedID}`,
        response: 'Container Created!',
      });
    })
    .catch(error => {
      console.error(error);
      this.setState({ callbackError: true });
    });
  }

  //Api call to tranfer custodian to self of a container
  receiveContainer(containerRequestBody) {
    api.receiveContainer(containerRequestBody.trackingID)
    .then(res => {
      console.log('res', res);
      this.setState({
        success: true,
        path: `/container/${containerRequestBody.trackingID}`,
        response: 'Container Received!',
      });
    })
    .catch(error => {
      console.error(error);
      this.setState({ callbackError: true });
    });
  }

  //Api call to tranfer custodian to self of a container
  receiveProduct(productRequestBody) {
    api.receiveProduct(productRequestBody.trackingID)
    .then(res => {
      console.log('res', res)
      this.setState({
        success: true,
        path: `/product/${productRequestBody.trackingID}`,
        response: 'Product Received!',
      });
    })
    .catch(error => {
      console.error(error);
      this.setState({ callbackError: true });
    });
  }

  //function call to redirect to details page of product
  goToProductInfo(productRequestBody) {
    this.setState({
      success: true,
      path: `/product/${productRequestBody.trackingID}`,
      response: 'Found!',
    });
  }

  //function call to redirect to details page of container
  goToContainerInfo(containerRequestBody) {
    this.setState({
      success: true,
      path: `/container/${containerRequestBody.trackingID}`,
      response: 'Found!',
    });
  }

  //function to handle Manufacturer trying to view details of item on mobile they dont own
  unowned() {
    this.setState({
      success: true,
      response: 'You longer own this item!',
    });
  }

  //Function which handles the scanning of the object and determines the appropriate action
  async scanItem(requestBody){
    await api.scan(requestBody.trackingID)
    .then(res => {
      this.setState({
        scanResult: res.status,
      });
    })
    .catch(error => {
      console.error(error);
      this.setState({ callbackError: true });
    });
    var type = 'container'
    if (requestBody.productName !== undefined){
      type = 'product'
    };

      switch (this.state.scanResult) {
        case 'owned':
          if (type === 'container'){this.goToContainerInfo(requestBody)}
          else{this.goToProductInfo(requestBody)}
          break;
        case 'unowned':
          if (this.props.role === 'Carrier' || this.props.role === 'Store' || this.props.role === 'Warehouse'){
            if (type === 'container'){this.receiveContainer(requestBody)}
            else{this.receiveProduct(requestBody)}
          }else (this.unowned())
          break;
        case 'new':
          if (type === 'container'){this.createContainers(requestBody)}
          else{if(this.props.role === 'Manufacturer'){this.createProducts(requestBody)}}
          break;
        default:
          break;
      }
  }

  //Event Handlers

  //Handles redirect
  handleRedirect() {
    if (this.state.path === '/'){window.location.reload()}
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
      <React.Fragment>
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
            {callbackError ? "Scan Failed" : this.state.response}
          </div>
        </Modal>
        <MenuBar title = {''} header = {header}>
          <QrReader handleScan={this.scanItem} callbackError={this.state.callbackError} />
        </MenuBar>
      </React.Fragment>
    )
  }
}

export default withStyles(styles)(DashboardQrScan);
