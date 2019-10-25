import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import api from '../../util/api/supplyChainRequests';
import MenuBar from '../../components/MenuBar';
import Locations from '../../components/Locations';
import MapWithPath from '../../components/MapWithPath'
import styles from '../../mobileStyles';
import ItemCard from '../../components/ItemCard';

const minMapWidth = 500;
const mapHeight = 200;

class LocationDetails extends React.Component{
  constructor({match}){
    super()
    this.state = {
      variant:match.params.variant,
      history: [],
      trackingID: match.params.trackingID,
      mapPropsLoaded: false,
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

  componentDidMount(){
    this.setContainerHistory()
    .then(() => {
      if(this.state.history.length > 0) {
        this.setState({mapPropsLoaded: true});
      }
    })
    .catch(error => {
      console.log(error);
    })
  }

  render(){
    const { classes,name } = this.props;
    const { history, trackingID, mapPropsLoaded, variant } = this.state;
    return(
      <MenuBar title="Location" variant = "location" path={`/${variant}/${trackingID}`}>
        <div className={classes.root}>
          <div className={classes.landingBottom}>
            <div className={classes.slide}>
              <div className={classes.map}>
              {mapPropsLoaded && <MapWithPath markers={history} mapHeight={mapHeight} mapWidth={minMapWidth}></MapWithPath>}
              </div>
              <ItemCard name={name} info={`${trackingID}`}/>
              <Locations locationHistory={history}/>
            </div>
          </div>
        </div>
      </MenuBar>
    )
  }
}

export default withStyles(styles)(LocationDetails);
