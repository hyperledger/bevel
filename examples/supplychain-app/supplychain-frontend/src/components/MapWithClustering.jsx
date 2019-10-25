import GoogleMap from 'google-map-react';
import React from 'react';
import PropTypes from 'prop-types';
import Marker from '../components/Marker'
import { withStyles } from '@material-ui/core/styles';
import parseName from '../util/parseName';
require('dotenv').config()


const styles = theme => ({
  map: {
    width: '100%',
    height: '100%',
  },

});

class MapWithClustering extends React.Component{
  constructor({match}){
    super()
    this.state = {
      map: 0,
      maps: 0,
      mapLoaded: false,
      mapCenter: {},
      mapZoom: 0,
      mapPropsCalculated: false,
      linePropsCalculated: false,
      locationCoordinates: {}
    }
  }

  componentDidMount(){
    this.setMapProps()
    this.setLocationCoordinates()
  }


  setMapProps() {
    let mapZoom = 0;
    let mapCenter = {};
    const locCoord = this.props.markers;
    if (Object.keys(locCoord).length === 1) {
      var singleLocation
      for(var key in locCoord){
        singleLocation = key
      }
      mapZoom = 11;
      let lat = parseFloat(parseName.getLatitude(singleLocation));
      let lng = parseFloat(parseName.getLongitude(singleLocation));
      mapCenter = {lat: lat, lng: lng}
    } else {
      let minLat = 90;
      let maxLat = -90;
      let minLng = 180;
      let maxLng = -180;
      let lat = 0;
      let lng = 0;
      for ( key in locCoord){
        lat = parseFloat(parseName.getLatitude(key));
        lng = parseFloat(parseName.getLongitude(key));
        minLat = lat < minLat ? lat : minLat;
        maxLat = lat > maxLat ? lat : maxLat;
        minLng = lng < minLng ? lng : minLng;
        maxLng = lng > maxLng ? lng : maxLng;
      }
      mapCenter = {lat: (minLat+maxLat)/2 , lng: (minLng+maxLng)/2}

      var angleLng = maxLng - minLng;
      if (angleLng < 0) {
        angleLng += 360;
      }
      var angleLat = maxLat - minLat;
      if (angleLat < 0) {
        angleLat += 180;
      }
      let wholeAngle;
      let angle;
      let size;

      if (angleLng > angleLat) {
        angle = angleLng;
        wholeAngle = 360;
        size = this.props.mapWidth;
      } else {
        angle = angleLat;
        wholeAngle = 180;
        size = this.props.mapHeight;
      }

      mapZoom = (Math.log(size * wholeAngle / angle / 256) / Math.LN2 - 0.1)-1;
    }
    this.setState({mapZoom: mapZoom});
    this.setState({mapCenter: mapCenter});
    this.setState({mapPropsCalculated: true})
  }

  renderMarkers(classes) {
    var locLabel = this.props.markers;
    var temp = []
    let colors = {1:'#38BDB1',2:'#6FA5FC',3:'#A34CCE',0:'#9f91F3'}
    let i = 0
    for (var key in locLabel){
      temp.push(
      <Marker
      key={key}
      lat = {parseFloat(parseName.getLatitude(key))}
      lng= {parseFloat(parseName.getLongitude(key))}
      style = {{backgroundColor:colors[i%4]}} >
        {locLabel[key].toString()}
      </Marker>)
      i++
    }
    return temp
  }

  setLocationCoordinates() {
    let locationList = [];
    for (var key in this.props.markers){
      let lat = parseFloat(parseName.getLatitude(key))
      let lng = parseFloat(parseName.getLongitude(key))
      locationList.push({lat: lat, lng: lng});
    }
    this.setState({locationCoordinates: locationList})
    this.setState({linePropsCalculated: true})
  }


  render(){
    const { classes } = this.props;
    const { mapCenter, mapZoom,  mapPropsCalculated } = this.state;
    return(
      <div className={classes.map}>
      {this.props.children}
        {mapPropsCalculated && <GoogleMap
          yesIWantToUseGoogleMapApiInternals
          onGoogleApiLoaded={({ map, maps }) => {
            this.setState({ map: map, maps:maps, mapLoaded: true })
          }}
          bootstrapURLKeys={{ key: process.env.REACT_APP_GMAPS_KEY }}
          center={mapCenter}
          zoom={mapZoom}
          >
          {this.renderMarkers(classes)}
        </GoogleMap>}
      </div>
    )
  }
}
MapWithClustering.propTypes = {
  classes: PropTypes.object.isRequired,
  markers: PropTypes.object,
};

export default withStyles(styles)(MapWithClustering);
