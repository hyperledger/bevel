import React from 'react';
import Card from '@material-ui/core/Card';
import PropTypes from 'prop-types';
import CardContent from '@material-ui/core/CardContent';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import {MuiThemeProvider, createMuiTheme, withStyles } from '@material-ui/core/styles';

const theme = createMuiTheme({
  overrides: {
    typography: {
    useNextVariants: true,
  },
    MuiButton:{
      root:{
        textTransform:'none',
      },
    },
    MuiTypography:{
      h6:{
          color: '#5F0095'
      },
    },
  }
})

function UiCard(props) {
  return (
    <div>
      <React.Fragment>
      <MuiThemeProvider theme={theme}>
      <Card>
      <CardContent>
        <Button size="small"onClick={props.handler} style={{display:'contents'}}>
          <img src={props.image} style={{height:'170px'}}alt="tempplaceholder" />
          <Typography style={{marginTop:'20px'}}variant='h6'>{props.label}</Typography>
          <Typography>{props.text}</Typography>
        </Button>
      </CardContent>
    </Card>
      </MuiThemeProvider>
      </React.Fragment>
    </div>
  );
}
UiCard.propTypes = {
  handler: PropTypes.object.isRequired,
  image: PropTypes.string,
  label: PropTypes.string,
  text: PropTypes.string,
};

export default withStyles(theme)(UiCard);
