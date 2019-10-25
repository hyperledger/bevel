import React from 'react';

import Typography from '@material-ui/core/Typography';
import { withStyles } from '@material-ui/core/styles';
import api from '../../util/api/supplyChainRequests';
import ProductsTable from '../../components/ProductsTable';
import SideBar from '../../components/SideBar'
import DesktopAppBar from '../../components/DesktopAppBar';
import MapWithPath from '../../components/MapWithPath'
import Locations from '../../components/Locations';
import Search from '../../components/Search';
import styles from '../../desktopStyles';

const mapWidth = 500;
const mapHeight = 500;

class ContainerLocationDetails extends React.Component{

  constructor({match}){
    super()
    this.state = {
      history: [],
      trackingID: match.params.trackingID,
      mapPropsLoaded: false,
      products:[],
      container:{misc:{"name":""}}
    }
  }

  //api calls
  async setContainerHistory(){
    let history = await this.getContainerHistory()
    .catch(error =>{
      console.error(error);
    })
    this.setState({history: history})
  }

  async getContainerHistory(){
    let res = await api.locationHistory(this.state.trackingID)
      .catch(error =>{
        console.error(error);
        return null;
      })
    return res;
  }

  async componentDidMount(){
    this.setContainerHistory()
    .then(() => {
      if(this.state.history.length > 0) {
        this.setState({mapPropsLoaded: true});
      }
    })
    .catch(error => {
      console.log(error);
    })
    let container = await api.getContainerByID(this.state.trackingID);
    if (container !== null){
      let products = await Promise.all(container.contents.map(itemID => {
        return api.getProductByID(itemID);
      }))
      .catch(error => {
        console.error(error);
      });
      this.setState({
        products,container
      });
      }
  };

  handleSearchInput = prop => event => {
    this.setState({ [prop]: event.target.value });
  };

  render(){
    const { classes } = this.props;
    const { history, trackingID, mapPropsLoaded,products,container} = this.state;

    return (
      <main className={classes.root}>
        <DesktopAppBar/>
        <SideBar/>
        <div className={classes.content}>
          <div className={classes.contentContainer}>
            <div >
              <div className={classes.containerName}>
                <Typography variant="h3" className={classes.largeText}> {container.misc.name} </Typography>
                <Typography variant="h4" className={classes.largeText}> {trackingID} </Typography>
                <Typography variant="h5" className={classes.mediumText}> Details </Typography>
              </div>
              <div className={classes.searchField}>
                <Search/>
              </div>
            </div>
            <div className={classes.mapCard}>
                <div className={classes.locationText}>
                  <Typography variant="h5"> Location </Typography>
                </div>
                <div className={classes.smallMap}>
                  {mapPropsLoaded && <MapWithPath markers={history} mapHeight={mapHeight} mapWidth={mapWidth}></MapWithPath>}
                </div>
                <div className={classes.locationList}>
                  <Locations locationHistory={history}/>
                </div>
            </div>
            <div>
              <Typography variant='h3' className={classes.tableTitle} > Products in Container </Typography>
              <ProductsTable products={products}/>
            </div>
          </div>
        </div>
      </main>
    );
  }
}
export default withStyles(styles)(ContainerLocationDetails);
