import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import EditableInline from './EditableInline';
import styles from '../mobileStyles';
import PropTypes from 'prop-types';

function DetailHeader(props) {
  const { classes, name, id, variant,type } = props;

  return (
    <div className={classes.detailHeaderRoot}>
      <EditableInline name={name} id={id} variant={variant} />
      {variant === 'container'?(
      <img className={classes.detailHeaderIcon} alt="Container" src={`/${type}.png`} />
    ):(
      <img className={classes.detailHeaderIcon} alt="Product" src={`/${type}.png`} />

    )}

    </div>
  );
}

DetailHeader.propTypes = {
  classes: PropTypes.object.isRequired,
  name: PropTypes.string,
  id: PropTypes.string,
  variant: PropTypes.string,
  type: PropTypes.string,
};
export default withStyles(styles)(DetailHeader);
