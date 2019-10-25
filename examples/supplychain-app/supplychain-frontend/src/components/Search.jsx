import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Paper from '@material-ui/core/Paper';
import InputBase from '@material-ui/core/InputBase';
import IconButton from '@material-ui/core/IconButton';
import SearchIcon from '@material-ui/icons/Search';

const styles = {
  root: {
    padding: '2px 4px',
    display: 'flex',
    alignItems: 'center',
    width: '400px',
    height: 40,
    //boxShadow:'inset 0px 8px 8px -10px #CCC, inset 0px -8px 8px -10px #CCC, inset 6px 6px 8px -10px #CCC',
    border: '1px solid #DDDDDD',
  },
  input: {
    marginLeft: 8,
    flex: 1,
    fontFamily:'PingFangSC-Regular',
    fontWeight:300,
  },
  iconButton: {
    padding: 10,
  },
  divider: {
    width: 1,
    margin: 4,
  },
};

function Search(props) {
  const { classes } = props;

  return (
    <Paper className={classes.root}>
      <IconButton className={classes.iconButton} aria-label="Search">
        <SearchIcon />
      </IconButton>
      <InputBase className={classes.input} placeholder=" " />
    </Paper>
  );
}

Search.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(Search);
