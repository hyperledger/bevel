import React from 'react';
import PropTypes from 'prop-types';
import {Typography} from '@material-ui/core';
import parseName from '../util/parseName';
import getTimezone from '../util/getTimezone';
import numberPadding from '../util/numberPadding';
import { withStyles } from '@material-ui/core/styles';
import styles from '../mobileStyles';

const monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
"Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

function Location(props){
  const {classes, time,location } = props;
  return(
    <div className = {classes.locationBody}>
      <Typography variant='h6' className = {classes.date}> {monthNames[time.getMonth()]} {numberPadding(time.getDate())}  </Typography>
      <div className = {classes.historyItem}>
        <div className = {classes.lastScanned}>
          <Typography variant='h6' className={classes.regularText}> {parseName.getOrganization(location.party)} in {parseName.getLocation(location.party)} </Typography>
          <Typography variant='h6' className={classes.regularText}> Scanned at {numberPadding(time.getHours())}:{numberPadding(time.getMinutes())} {getTimezone(time)}</Typography>
        </div>
      </div>

    </div>
  )
}
Location.propTypes = {
  location: PropTypes.object,
  time: PropTypes.object

};

export default withStyles(styles)(Location);
