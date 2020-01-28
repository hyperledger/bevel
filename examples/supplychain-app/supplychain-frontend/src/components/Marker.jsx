import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

const K_WIDTH = 20;
const K_HEIGHT = 20;

const styles = theme => ({
  markers:{
    position: 'absolute',
    width: K_WIDTH,
    height: K_HEIGHT,
    left: -K_WIDTH / 2,
    top: -K_HEIGHT / 2,
    borderRadius: K_HEIGHT,
    backgroundColor: 'white',
    textAlign: 'center',
    color: 'white',
    fontSize: 15,
    fontWeight: 'bold',
    padding: 4

  },
});

function Marker(props) {
  const { classes } = props;

  return (
    <div
      style = {props.style}
      className ={classes.markers}>
        {props.children}
    </div>
  );
}

Marker.propTypes = {
  classes : PropTypes.object.isRequired,
  style : PropTypes.object,
  children: PropTypes.any
}

export default withStyles(styles)(Marker)
