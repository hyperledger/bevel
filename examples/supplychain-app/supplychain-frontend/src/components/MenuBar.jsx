import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import { withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import Badge from '@material-ui/core/Badge';
import MenuIcon from '@material-ui/icons/Menu';
import Back from '@material-ui/icons/ArrowBack';
import NotificationsIcon from '@material-ui/icons/Notifications';
import styles from '../mobileStyles';


function MenuBar(props) {
  const { classes ,header ,children,variant} = props;
  return(
    <div className={classes.menuRoot}>
      <AppBar position="static" className={(variant==='product'|| variant === 'location')?(classes.appBarProduct):(classes.appBar)}>
        <Toolbar>
        {variant === "transistion"?(
          <IconButton component={Link} to ={"/"} className={classes.menuButton} aria-label="Menu">
            <Back />
            <Typography variant="h5" className={classes.grow}>
              Home
            </Typography>
          </IconButton>
        ):variant === "location"?(
          <IconButton component={Link} to ={props.path} className={classes.menuButton} aria-label="Menu">
            <Back />
            <Typography variant="h5" className={classes.grow}>
              Details
            </Typography>
          </IconButton>
        ):variant === "product"?(
          <IconButton component={Link} to ={"/"} className={classes.menuButton} aria-label="Menu">
            <Back />
          </IconButton>
        ):(<MenuIcon/>)}
          <div className={classes.grow}/>
          <IconButton className={classes.notiButton} aria-label="Notifications">
            <Badge badgeContent={1} color={'secondary'}>
              <NotificationsIcon />
            </Badge>
          </IconButton>
        </Toolbar>
        {header}
      </AppBar>
      <div className={classes.bodyContent}>
      {children}
      </div>
    </div>
  );
}

MenuBar.propTypes = {
  classes: PropTypes.object.isRequired,
  header: PropTypes.any,
  children: PropTypes.any,
  variant: PropTypes.string,
};

export default withStyles(styles)(MenuBar);
