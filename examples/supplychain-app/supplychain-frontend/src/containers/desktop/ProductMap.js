import React from 'react';

import {Typography,FormGroup,FormControlLabel,Checkbox} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import api from '../../util/api/supplyChainRequests';
import Radio from '@material-ui/icons/RadioButtonUnchecked'
import RadioChecked from '@material-ui/icons/RadioButtonChecked'
//import ProductsTable from '../../components/ProductsTable';
import DesktopAppBar from '../../components/DesktopAppBar';
import SideBar from '../../components/SideBar';
import MapWithClustering from '../../components/MapWithClustering'
import parseName from '../../util/parseName';
import styles from '../../desktopStyles';

//import Locations from '../../components/Locations';
//import Search from '../../components/Search';

const mapWidth = 900;
const mapHeight = 500;


class ProductMap extends React.Component{

  constructor({match}){
    super()
    this.state = {
      products: [],
      markers:{},
      sortedProducts:{},
      mapPropsLoaded: false,
    }
    this.updateFilters = this.updateFilters.bind(this)
  }

  //api calls
  async getProducts(){
    let products = await api.getProducts()
    .catch(error =>{
    })
    this.setState({products})
  }

  //define a object with unique product names as keys to alist of their custodians
  sortProducts(){
    let sortedProducts = {}
    for (var i = 0; i < this.state.products.length; i++) {
      if (!(this.state.products[i].productName in sortedProducts)){
        sortedProducts[this.state.products[i].productName] =
          {
            locations:[this.state.products[i].custodian],
            enabled:true
          }
      }else {
        sortedProducts[this.state.products[i].productName].locations.push(this.state.products[i].custodian)
        sortedProducts[this.state.products[i].productName].enabled = true
      }
    }
    this.setState({sortedProducts})
  }

  // set markers based on list of viewable products at unique locations
  setMarkers(){
    let products = []
    for (var product in this.state.sortedProducts) {
      if (this.state.sortedProducts[product].enabled){
        products = products.concat(this.state.sortedProducts[product].locations)
      }
    }
    var markers = {}
    //var markers = []
    products.map(product => {
      if (!([product] in markers )){
        markers[product] = 0
        //markers.push(product.custodian)
      }
      markers[product] += 1
      return 1
    })
    this.setState({markers})
  }

  async componentDidMount(){
    await this.getProducts()
    this.sortProducts()
    this.setMarkers()
    if(this.state.markers !== {}) {
      this.setState({mapPropsLoaded: true});
    }
  };

  updateFilters(event){
    var newSortedProducts = this.state.sortedProducts
    newSortedProducts[event.target.value].enabled = !newSortedProducts[event.target.value].enabled
    this.setState({sortedProducts:newSortedProducts})
    this.setMarkers()

  }

  handleSearchInput = prop => event => {
    this.setState({ [prop]: event.target.value });
  };

  checkboxes(classes){
    var temp = []
    temp.push(
      <div key="title" style = {{padding:'10px 0px'}}>
        <Typography variant='h4' className ={classes.mediumText}>Hyperledger Bevel</Typography>
      </div>
    )
    for (var key in this.state.sortedProducts) {
      let uniqueLocations = [ ...new Set(this.state.sortedProducts[key].locations) ]
      temp.push(
        <div key = {key} className={classes.overlayItem}>
          <FormControlLabel
            className={classes.mediumText}
            control={
              <Checkbox icon={<Radio style={{fontSize:15}}/>} checkedIcon={<RadioChecked style={{fontSize:15,color:'silver'}}/>} checked={this.state.sortedProducts[key].enabled} onChange={(event)=>this.updateFilters(event)} value={key} />
            }
            label={key}
          />
          {this.displayUniqueLocations(uniqueLocations,key,classes)}
        </div>
      )
    }
    return temp
  }
  displayUniqueLocations(locations,key,classes){
    return(locations.map(location =>{
      return(
        <Typography key={key+location}variant='h6' className={classes.subText}> {parseName.getOrganization(location)} {parseName.getLocation(location)} </Typography>
      )
    }))
  }

  render(){
    const { classes } = this.props;
    const { markers,  mapPropsLoaded} = this.state;

    return (
      <div className={classes.root}>
        <React.Fragment>
          <DesktopAppBar/>
          <SideBar/>
          <main className={classes.largeMapContent}>
            <div className={classes.contentContainer}>
              <div className={classes.mapCard}>
                <div className={classes.locationText}>
                  <Typography variant="h5"> World Map </Typography>
                </div>
                <div className={classes.map}>
                  {mapPropsLoaded && <MapWithClustering markers={markers} mapHeight={mapHeight} mapWidth={mapWidth}>
                    <div className={classes.mapOverlay} >
                      <FormGroup >
                        {this.checkboxes(classes)}
                      </FormGroup>
                    </div>
                  </MapWithClustering>}
                </div>
              </div>
            </div>
          </main>
        </React.Fragment>
      </div>
    );
  }
}
export default withStyles(styles)(ProductMap);
