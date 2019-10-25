import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import { Typography, Input } from '@material-ui/core';
import styles from '../mobileStyles';
import { Link } from 'react-router-dom';
import PropTypes from 'prop-types';

class EditableInline extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      editing: null,
      name: props.name || '',
      id: props.id || ''
    };
  }

  update(event) {
    this.setState({
      [event.target.name]: event.target.value
    });
  }

  // focus(editing) {
  //   this.setState({
  //     editing
  //   });
  //}

  render() {
    let { classes, variant, name, id  } = this.props;
    const { editing } = this.state;

    return (
      <div style={{width:'100%', textAlign:'left', paddingLeft:40}}>
        {editing === 'name' ? (
          <React.Fragment>
            <Input name="name" value={name} onChange={this.update.bind(this)} />
            <Typography>{id}</Typography>
          </React.Fragment>
        ) : editing === 'id' ? (
          <React.Fragment>
            <Typography>{name}</Typography>
            <Input name="id" value={id} onChange={this.update.bind(this)} />
          </React.Fragment>
        ) : (
          <React.Fragment>
            <Typography variant="h4" className={classes.boldText}>{name}</Typography>
            <Typography variant="h6" className={classes.lightText}>{id}</Typography>
            <Typography variant="h6" className={classes.lightText} component={Link} to = {`/${variant}/${id}/locationDetails`}> Details </Typography>
          </React.Fragment>
        )}
      </div>
    );
  }
}
EditableInline.propTypes = {
  classes: PropTypes.object.isRequired,
  name: PropTypes.string,
  id: PropTypes.string,
  variant: PropTypes.string,
};
export default withStyles(styles)(EditableInline);
