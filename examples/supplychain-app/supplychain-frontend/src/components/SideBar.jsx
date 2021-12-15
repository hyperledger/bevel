import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import { withStyles } from '@material-ui/core/styles';
import {ListItem, Drawer, List, Divider, Typography} from '@material-ui/core';

const styles = theme => ({
  drawer: {
      width: 240,
      flexShrink: 0,
    },
    drawerPaper: {
      width: 240,
    },
    toolbar:{
    },
    userInfo:{
      height:150,
      backgroundColor: '#f5f8fA',
    },
    icon: {
      height: 75,
      width:75,
      margin: '15px 0px'
    },
    item:{
      justifyContent:'center',
      padding:'20px 16px'
    }
});

function SideBar(props) {
  const { classes } = props;
  return (
    <div className={classes.toolbar} >
    <Drawer
      className={classes.drawer}
      variant="permanent"
      classes={{
        paper: classes.drawerPaper,
      }}
      anchor="left"
    >
    <Divider style = {{height:108, backgroundColor:'white'}}/>
      <div className={classes.userInfo}>
        <img className={classes.icon} alt='logo' src={'/default.png'}/>
        <Typography variant='h5'>Hyperledger Bevel</Typography>
      </div>
    <Divider/>
      <List>
        <ListItem className={classes.item} button component={Link} to={`/`}>
          <Typography  variant='h5'>Dashboard</Typography>
        </ListItem>
        <ListItem className={classes.item} button component={Link} to={`/map`}>
          <Typography variant='h5'>Product World Map</Typography>
        </ListItem>
        <ListItem className={classes.item} button>
          <Typography variant='h5'>Settings</Typography>
        </ListItem>
      </List>
    </Drawer>
  </div>
  );
}

SideBar.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(SideBar);
