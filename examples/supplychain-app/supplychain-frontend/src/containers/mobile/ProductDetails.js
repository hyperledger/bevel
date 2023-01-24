import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import { Typography ,Button} from '@material-ui/core';
import { Link } from 'react-router-dom';
import DetailHeader from '../../components/DetailHeader';
import MenuBar from '../../components/MenuBar';
import api from '../../util/api/supplyChainRequests';
import Location from '../../components/Location';
import styles from '../../mobileStyles';

class ProductDetails extends React.Component {
  constructor({match}){
    super();

    this.state = {
      trackingID: match.params.trackingID,
      product: {
        trackingID: match.params.trackingID,
        misc:{},
      },
      history:[],
      lastScanTime:0,
      orphanedItems: [],
      isLoading: [],
      isRemoved: [],
      buttonText: [],
    };
  }

  async getProductHistory(trackingID){
    let res = await api.locationHistory(trackingID)
      .catch(error =>{
        console.error(error);
        return null;
      })
      return res
  }

  unPackageItem(productID) {
    let loading = this.state.isLoading;
    let added = this.state.isRemoved;
    let buttonText = this.state.buttonText;
    loading[productID] = true;
    buttonText[productID] = 'Removing...';


    this.setState({
      isLoading: loading,
      buttonText: buttonText
    });

    let contents = {contents:productID};
    console.log(contents);
    api.unPackageGood(this.state.product.containerID, contents)
    .then(res => {
      loading[productID] = false;
      added[productID] = true;
      buttonText[productID] = 'Removed';
      this.setState({
        isLoading: loading,
        isRemoved: added,
        buttonText: buttonText
      })
    })
    .catch(error => {
      console.error(error);

      loading[productID] = false;
      added[productID] = true;
      buttonText[productID] = 'Error';
      this.setState({
        isLoading: loading,
        isRemoved: added,
        buttonText: buttonText
      })
    });
    this.update = true;
  }


  async componentDidMount() {
    let product = await api.getProductByID(this.state.trackingID)
    .catch(error => {
      console.error(error);
    });

    this.setState({
      product,
    });
    let history = await this.getProductHistory(this.state.trackingID)
    .catch(error => {
      console.error(error);
    });
    this.setState({history,lastScanTime:history[0].time})
  }

  async componentDidUpdate() {
    if (this.update){
      let product = await api.getProductByID(this.state.trackingID)
      .catch(error => {
        console.error(error);
      });

      this.setState({
        product,
      });
      let history = await this.getProductHistory(this.state.trackingID)
      .catch(error => {
        console.error(error);
      });
      this.setState({history,lastScanTime:history[0].time})

      setTimeout(function () {
        this.update = false;
      }.bind(this), 5000);
    }
  }

  displayFields(description,classes){
    let temp = []
    for (var field in description){
      temp.push(
        <div key={field}>
          <Typography variant="h6" className={classes.boldText}> {field.charAt(0).toUpperCase() + field.slice(1)} </Typography>
          <Typography variant="h6" className={classes.regularText}> {description[field]} </Typography>
          </div>
      )
    }
    return temp

  }

  render() {
    const { classes } = this.props;
    const { product,history,lastScanTime,isLoading, isRemoved, buttonText,trackingID } = this.state;
    //let timeOfLastScan = new Date(history[0].time);
    return(
      <MenuBar variant = "product" header={<DetailHeader name={product.productName} id={product.trackingID} variant='product' type={(product.misc.type)?(`${product.misc.type}`):('default')} />}>
        <div className={classes.root}>
          <div className={classes.details}>
            <Typography variant="h5" className={classes.regularText}> Description </Typography>
            {product.misc.description?(this.displayFields(product.misc.description,classes)):(null)}
            {product.containerID?(
              <div className={classes.paddingDiv}>
                <Typography component={Link} to={`/container/${product.containerID}`}variant="h5">Located in Container {product.containerID.split("-")[0]}...</Typography>
                <Button className={classes.buttonGreen}>Change Container</Button>
                <Button disabled={isLoading[trackingID] || isRemoved[trackingID]} className={classes.buttonRed} onClick={() => this.unPackageItem(trackingID)}>{buttonText[trackingID] || 'Remove'}</Button>
              </div>
            ):(null)}

            <Typography variant='h5'> Current Location </Typography>
            {history.length !== 0?(
              <Link style= {{textDecoration:'none'}} to={`/product/${product.trackingID}/locationDetails`}>
                <div className={classes.currentLocation}>
                  <Location location={history[0]} time={new Date(lastScanTime)}/>
                </div>
              </Link>
            ):(null)
            }

          </div>
        </div>
      </MenuBar>
    )
  }
}

export default withStyles(styles)(ProductDetails);
