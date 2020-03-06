import React, { Component } from 'react';
import './App.css';
import {isMobile} from "react-device-detect";
import MobileDash from './containers/mobile/DashboardQrScan';
import ProductDetails from './containers/mobile/ProductDetails';
import ContainerDetails from './containers/mobile/ContainerDetails';
import LocationDetails from './containers/mobile/LocationDetails';
import PackageGood from './containers/mobile/PackageGood';
import CreateContainer from './containers/mobile/CreateContainer';
import DesktopDash from './containers/desktop/Dashboard';
import DesktopContainerDetails from './containers/desktop/ContainerDetails';
import ProductMap from './containers/desktop/ProductMap';
import QrGen from './containers/desktop/QrGen';
import api from './util/api/supplyChainRequests';
import {BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import { MuiThemeProvider, createMuiTheme, withStyles } from '@material-ui/core/styles';
import styles from './mobileStyles';

const mobileTheme = createMuiTheme({
  overrides:{
    MuiButton:{
      root:{
        minWidth: 10,
      },
      contained:{
        fontSize: '12px',
        fontFamily:'PingFangSC-Regular',
        backgroundColor:'#FFFFFF',
        width: '60%',
        borderRadius:6,
        boxShadow:'none'
      }
    },
    MuiTypography:{
      h3:{
        fontSize:22,
        color:'#414c5e'
      },
      h4:{
        fontSize:18,
        color:'#93979C',
      },
      h5:{
        fontSize:16,
        color:'#93979C'
      },
      h6:{
        fontFamily:'PingFangSC',
        fontSize:12,
        color:'#93979C'
      },
    }
  },
  typography: {
    useNextVariants: true,
  },
});

createMuiTheme({
  overrides:{
    MuiTypography:{
      root:{
        fontFamily:'PingFangSC-Regular',

      },
      h3:{
        fontFamily:'PingFangSC-Regular',
        fontSize:22,
        color:'#414c5e'
      },
      h4:{
        fontFamily:'PingFangSC-Regular',
        fontSize:18,
        color:'#93979C',
      },
      h5:{
        fontFamily:'PingFangSC-Regular',
        fontSize:16,
        color:'#93979C'
      },
      h6:{
        fontFamily:'PingFangSC-Regular',
        fontSize:12,
        color:'#93979C'
      },
    }
  },
  typography: {
    useNextVariants: true,
  },
});

class App extends Component {
  constructor(){
    super()
    this.state = {
      role:'Consumer'
    };
  }

  getRole(){
    api.getRole((data)=>{
      console.log(data.organizationUnit)
      this.setState({role:data.organizationUnit.charAt(0).toUpperCase() + data.organizationUnit.slice(1)})
    })
  }

  componentDidMount(){
    this.getRole();
  }

  render() {
    const { classes } = this.props;
    return (
      <div className={classes.app}>
      {isMobile?
        (
          <MuiThemeProvider theme={mobileTheme}>
            <Router>
              <Switch>
                <Route exact path = '/'  render={(props) => <MobileDash {...props} role={this.state.role} />}/>
                <Route exact path = '/product/:trackingID'  render={(props) => <ProductDetails {...props} role={this.state.role} />}/>
                <Route exact path = '/container/create/:trackingID'  render={(props) => <CreateContainer {...props} role={this.state.role}/>}/>
                <Route exact path = '/container/:trackingID'  render={(props) => <ContainerDetails {...props} role={this.state.role}/>}/>
                <Route exact path = '/:variant/:trackingID/locationDetails' render={(props) => <LocationDetails{...props} role={this.state.role}/>}/>
                <Route exact path = '/package/scanner/:containerID'  render={(props) => <PackageGood{...props} role={this.state.role}/>}/>
              </Switch>
            </Router>
          </MuiThemeProvider>
        ):
        <MuiThemeProvider theme={mobileTheme}>
          <Router>
            <Switch>
              <Route exact path = '/'  render={(props) => <DesktopDash {...props}/>}/>
              <Route exact path = '/container/:trackingID/details' render={(props) => <DesktopContainerDetails{...props} role={this.state.role}/>}/>
              <Route exact path = '/map' render={(props) => <ProductMap{...props} role={this.state.role}/>}/>
              <Route exact path = '/generate/qr'  render={(props) => <QrGen {...props}/>}/>
            </Switch>
          </Router>
        </MuiThemeProvider>
      }
      </div>
    );
  }
}

export default withStyles(styles)(App);
