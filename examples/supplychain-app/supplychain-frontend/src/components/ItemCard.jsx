import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import { Typography } from '@material-ui/core';
import PropTypes from 'prop-types';

const styles = theme => ({
  root: {
    display: 'flex',
    width: '100%',
    //backgroundColor: '#FFFFFF',
    borderColor: '#222222',
    borderWidth: '1px',
    alignItems: 'center'
  },
  icon: {
    margin: '0px 20px',
    //width: '3em',
    height:60,
    width:60,
    fontSize: '60px'
  },
  text: {
    margin: '12px 2px'
  }
});

function ItemCard(props) {
  const { classes, name, info,type } = props;

  return (
    <div className={classes.root}>
    {type?(<img className={classes.icon} alt=" product" src={`/${type.toLowerCase()}.png`} />):(null)}

      <div className={classes.text}>
        <Typography>{name}</Typography>
        <Typography>{info}</Typography>
      </div>
    </div>
  );
}
ItemCard.propTypes = {
  classes: PropTypes.object.isRequired,
  name: PropTypes.string,
  info: PropTypes.string,
  type: PropTypes.string,
};

export default withStyles(styles)(ItemCard);
