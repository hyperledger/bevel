import GoogleMap from 'google-map-react';
import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import parseName from '../util/parseName';
require('dotenv').config()


const styles = theme => ({
  map: {
    width: '100%',
    height: '100%',
  }
});

class MapWithPath extends React.Component{
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

    if (locCoord.length === 1) {
      mapZoom = 11;
      let lat = parseFloat(parseName.getLatitude(locCoord[0].party));
      let lng = parseFloat(parseName.getLongitude(locCoord[0].party));
      mapCenter = {lat: lat, lng: lng}
    } else {
      let minLat = 90;
      let maxLat = -90;
      let minLng = 180;
      let maxLng = -180;
      let lat = 0;
      let lng = 0;
      for (let i=0; i<locCoord.length; i++) {
        lat = parseFloat(parseName.getLatitude(locCoord[i].party));
        lng = parseFloat(parseName.getLongitude(locCoord[i].party));
        minLat = lat < minLat ? lat : minLat;
        maxLat = lat > maxLat ? lat : maxLat;
        minLng = lng < minLng ? lng : minLng;
        maxLng = lng > maxLng ? lng : maxLng;
      }
      mapCenter = {lat: (minLat+maxLat)/2, lng: (minLng+maxLng)/2}

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

      mapZoom = Math.log(size * wholeAngle / angle / 256) / Math.LN2 - 0.1;
    }

    this.setState({mapZoom: mapZoom});
    this.setState({mapCenter: mapCenter});
    this.setState({mapPropsCalculated: true})
  }

  renderMarkers(map,maps) {
    var locCoord = this.props.markers;
    for (let i=0; i<locCoord.length; i++) {
      new maps.Marker({
        position: {lat: parseFloat(parseName.getLatitude(locCoord[i].party)), lng: parseFloat(parseName.getLongitude(locCoord[i].party))},
        map: map,
        title: parseName.getOrganization(locCoord[i].party),
        zIndex: i,
        label: (locCoord.length-i).toString(),
      });
    }
  }

  setLocationCoordinates() {
    let locationList = [];
    for (let i=0; i<this.props.markers.length; i++) {
      let lat = parseFloat(parseName.getLatitude(this.props.markers[i].party))
      let lng = parseFloat(parseName.getLongitude(this.props.markers[i].party))
      locationList.push({lat: lat, lng: lng});
    }
    this.setState({locationCoordinates: locationList})
    this.setState({linePropsCalculated: true})
  }


  render(){
    const { classes } = this.props;
    const { map, maps, mapCenter, mapZoom, mapLoaded, mapPropsCalculated, locationCoordinates, linePropsCalculated } = this.state;
    return(
      <div className={classes.map}>
        {mapPropsCalculated && <GoogleMap
          onGoogleApiLoaded={({ map, maps }) => {
            this.setState({ map: map, maps:maps, mapLoaded: true })
            this.renderMarkers( map, maps)
          }}
          yesIWantToUseGoogleMapApiInternals
          bootstrapURLKeys={{ key: process.env.REACT_APP_GMAPS_KEY }}
          center={mapCenter}
          zoom={mapZoom}
          >

        </GoogleMap>}
        {linePropsCalculated && mapLoaded && <Polyline map={map} maps={maps} locations={locationCoordinates}/>}
      </div>
    )
  }
}


class Polyline extends React.PureComponent {

  componentWillUpdate() {
    this.line.setMap(null)
  }

  componentWillUnmount() {
    this.line.setMap(null)
  }

  getPaths() {
    return this.props.locations
  }

  render() {
    const { map, maps } = this.props
    const Polyline = maps.Polyline
    const renderedPolyline = this.renderPolyline()
    const paths = { path: this.getPaths() }
    this.line = new Polyline(Object.assign({}, renderedPolyline, paths))
    this.line.setMap(map)

    return null
  }

  renderPolyline() {
    return {
      geodesic: true,
      strokeColor: '#5b5b5b',
      strokeOpacity: 1,
      strokeWeight: 1
    }
  }
}

MapWithPath.propTypes = {
  classes: PropTypes.object.isRequired,
  markers: PropTypes.array,
};

export default withStyles(styles)(MapWithPath);
