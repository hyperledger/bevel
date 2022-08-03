import React from 'react';
import {QRCode} from 'react-qr-svg';
import TextField from '@material-ui/core/TextField';
import Button from '@material-ui/core/Button';
import { saveSvgAsPng } from 'save-svg-as-png';

const uuidv4 = require('uuid/v4');

class QrGen extends React.Component {
  constructor() {
    super()
    this.state = {
      productqr:{},
      containerqr:{},
      productNameP:"",
      trackingIDP:uuidv4(),
      typeP:"",
      descriptionP:"{}",
      counterpartiesP:"Store , Warehouse , Carrier",

      trackingIDC:uuidv4(),
      nameC:"",
      typeC:"",
      counterpartiesC:"Store , Warehouse , Carrier",

    }
    this.handleChange = this.handleChange.bind(this);
    this.handleProductQR = this.handleProductQR.bind(this);
  }

  handleChange = name => event => {
    this.setState({ [name]: event.target.value });

  };
componentDidMount(){
  this.handleProductQR()
  this.handleContainerQR()
}
  handleProductQR = () => {
    this.setState({
      productqr:{
        "productName":this.state.productNameP,
        "trackingID":this.state.trackingIDP,
        "misc":{
          "type":this.state.typeP,
          "description":JSON.parse(this.state.descriptionP)
        },
        "counterparties":this.state.counterpartiesP.split(" , ")
      }
    })

  }

  handleContainerQR = () => {
    this.setState({
      containerqr:{
        "trackingID":this.state.trackingIDC,
        "misc":{
          "type":this.state.typeC,
          "name":this.state.nameC
        },
        "counterparties":this.state.counterpartiesC.split(" , ")
      }
    })
  }


  render(){
    const { productqr,containerqr } = this.state;
    return (
      <div>
        <div style={{padding:25}}>
          <QRCode
                id="productqr"
                level="Q"
                style={{ width: 256 }}
                value={JSON.stringify(productqr)}
          />
            Product
          <div style={{display:'grid'}}>
            <TextField label="Product Name" value={this.state.productNameP} onChange={this.handleChange('productNameP')} />
            <TextField label="Tracking ID" value={this.state.trackingIDP} onChange={this.handleChange('trackingIDP')} />
            <TextField label="Type (must match asset in /public)" value={this.state.typeP} onChange={this.handleChange('typeP')} />
            <TextField label="Product Details (in key:value json format)" value={this.state.descriptionP} onChange={this.handleChange('descriptionP')} />
            <TextField label="Counter Parties (no spaces)" value={this.state.counterpartiesP} onChange={this.handleChange('counterpartiesP')} />
            <Button variant="contained" onClick={() => {
                this.handleProductQR()
            }}> Update QR</Button>
            <Button variant="contained" onClick={() => {
                saveSvgAsPng(document.getElementById("productqr"), "product.png")
            }}> Download QR</Button>
          </div>
        </div>
        <div style={{padding:25}}>
          <QRCode
            id="containerqr"
            level="Q"
            style={{ width: 256 }}
            value={JSON.stringify(containerqr)}
          />
            Container
          <div style={{display:'grid'}}>
          <TextField label="Name" value={this.state.nameC} onChange={this.handleChange('nameC')} />
            <TextField label="Tracking ID" value={this.state.trackingIDC} onChange={this.handleChange('trackingIDC')} />
            <TextField label="Type (must match asset in /public)" value={this.state.typeC} onChange={this.handleChange('typeC')} />
            <TextField label="Counter Parties (no spaces)" value={this.state.counterpartiesC} onChange={this.handleChange('counterpartiesC')} />
            <Button variant="contained" onClick={() => {
              this.handleContainerQR()
            }}> Update QR</Button>
            <Button variant="contained" onClick={() => {
              saveSvgAsPng(document.getElementById("containerqr"), "container.png")
            }}> Download QR</Button>
          </div>
        </div>
      </div>
    )
  }
}

export default (QrGen)
