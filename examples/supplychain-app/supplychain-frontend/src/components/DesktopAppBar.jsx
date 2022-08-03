import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import IconButton from '@material-ui/core/IconButton';
import Menu from '@material-ui/icons/Menu';

const styles = theme => ({
  appBar:{
    width:'100%',
    padding:'30px',
    backgroundColor:'white',
    display:'-webkit-box',
    zIndex: theme.zIndex.drawer + 1,

  },
  notiButton: {
    width: 'fit-content',
  },
});

function MenuBar(props) {
  const { classes } = props;
  return (
    <div>
      <AppBar position="absolute" className = {classes.appBar}>
        <IconButton className={classes.notiButton} aria-label="Notifications">
          <Menu />
        </IconButton>

      </AppBar>
    </div>
  );
}

MenuBar.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(MenuBar);
