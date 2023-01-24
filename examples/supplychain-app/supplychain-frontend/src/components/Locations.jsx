import React from 'react';
import PropTypes from 'prop-types';
import Location from './Location';


function Locations(props){
  const {locationHistory} = props;
  return(
    <div>
    {locationHistory.map(location => {
      let time = new Date(location.time);
      return(
        <Location time={time} location={location} key={time+location}/>
      )
    })}
    </div>

  );
}

Locations.propTypes = {
  locationHistory: PropTypes.array,

};

export default (Locations);
