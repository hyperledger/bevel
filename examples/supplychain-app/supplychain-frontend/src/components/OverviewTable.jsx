import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import { Link } from 'react-router-dom';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import parseName from '../util/parseName';

const styles = theme => ({
  root: {
    width: '100%',
    marginTop: theme.spacing.unit ,
    overflowX: 'auto',
    borderRadius:'0px',
    borderBottomLeftRadius:'3px',
    borderBottomRightRadius:'3px',
  },
  table: {
    minWidth: '20%',
  },
  header:{
    //boxShadow:'0px 1px 5px 0px rgba(0,0,0,0.2), 0px 2px 2px 0px rgba(0,0,0,0.14), 0px 3px 1px -2px rgba(0,0,0,0.12)',
    height:10
  },
  cellName:{
    color:'black',
    fontWeight:500,
    textDecoration:'none',
  },
  icon: {
    margin: '10px 10px',
    //width: '3em',
    height:25,
    width:25,
    float:'left',
  },
  cell:{
    width:'100%',

  },
  emptyCell:{
    fontSize:14,
    textAlign:'center',
  },
  emptyRow:{
    height:'100px'
  }
});

function createData(name, id, location, type, containerID) {
  return { name, id, location, type, containerID };
}


function SimpleTable(props) {
  const { classes,containers } = props;
  const rows = containers.map(row =>{
    //let timestamp = new Date(row.timestamp);
    return(
      createData(row.misc.name, row.trackingID,` ${parseName.getLocation(row.custodian)}` ,(row.misc.type)?(`${row.misc.type}`):('default'),row.containerID)
    )
  })

  return (
    <Paper className={classes.root}>
      <Table component="table" className={classes.table}>
        <TableHead className={classes.header}>
          <TableRow style = {{height:7}}>
            <TableCell style = {{backgroundColor:props.color,height:8,padding:0}}> </TableCell>
          </TableRow>
        </TableHead>
        <TableBody component="tbody" style={{borderBottomRadius:3}}>
          {(rows.length === 0) ?(
            <TableRow component="tr" className={classes.emptyRow} >
              <TableCell component="td" scope="row">
                <div className={classes.cell}>
                  <Typography variant="h5" className={classes.emptyCell} > No Shipments Present</Typography>
                </div>
              </TableCell>
            </TableRow>):(
              rows.map(row => (
              <TableRow component="tr" key={row.id}  >
                <TableCell component="td" scope="row">
                  <Link to={`/container/${row.id}/details`} style={{ textDecoration:'none'}}>
                    <img className={classes.icon} alt=" " src={`/${row.type.toLowerCase()}.png`} />
                    <div className={classes.cell}>
                      <Typography variant="h5" className={classes.cellName} >{row.name} </Typography>
                      <Typography noWrap style={{maxWidth:'50%'}}> {row.id} </Typography>
                    </div>
                  </Link>
                </TableCell>
              </TableRow>
            ))
          )
          }
        </TableBody>
      </Table>
    </Paper>
  );
}

SimpleTable.propTypes = {
  classes: PropTypes.object.isRequired,
  containers: PropTypes.array
};

export default withStyles(styles)(SimpleTable);
