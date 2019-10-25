import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import parseName from '../util/parseName';

const styles = theme => ({
  root: {
    width: '100%',
    marginTop: theme.spacing.unit * 3,
    overflowX: 'auto',
  },
  table: {
    minWidth: 700,
  },
  header:{
    boxShadow:'0px 1px 5px 0px rgba(0,0,0,0.2), 0px 2px 2px 0px rgba(0,0,0,0.14), 0px 3px 1px -2px rgba(0,0,0,0.12)',
    backgroundColor:'#5677F1',

  },
  headerCell:{
    color:'white',
    fontSize:15
  },
});

let id = 0;
function createData(name, trackingID, location, lastScanned) {
  id += 1;
  return { id, name, trackingID,location, lastScanned };
}


function SimpleTable(props) {
  const { classes,products } = props;
  const rows = products.map(row =>{
    let timestamp = new Date(row.timestamp);
    return(
      createData(row.productName,row.trackingID,` ${parseName.getLocation(row.custodian)} ,${parseName.getCountry(row.custodian)} `,`${timestamp.getMonth()}/${timestamp.getDate()}/${timestamp.getFullYear()}`)
    )
  })

  return (
    <Paper className={classes.root}>
      <Table className={classes.table}>
        <TableHead className={classes.header}>
          <TableRow>
            <TableCell className={classes.headerCell} >Product Name</TableCell>
            <TableCell className={classes.headerCell} align="right">Tracking ID</TableCell>
            <TableCell className={classes.headerCell} align="right">Location</TableCell>
            <TableCell className={classes.headerCell} align="right">Last Scan</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {rows.map(row => (
            <TableRow key={row.id}>
              <TableCell component="th" scope="row">
                {row.name}
              </TableCell>
              <TableCell align="right">{row.trackingID}</TableCell>
              <TableCell align="right">{row.location}</TableCell>
              <TableCell align="right">{row.lastScanned}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Paper>
  );
}

SimpleTable.propTypes = {
  classes: PropTypes.object.isRequired,
  products: PropTypes.array,
};

export default withStyles(styles)(SimpleTable);
