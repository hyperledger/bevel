import React from 'react';
import DesktopAppBar from '../../components/DesktopAppBar';
import Table from '../../components/OverviewTable';
import { withStyles } from '@material-ui/core/styles';
import api from '../../util/api/supplyChainRequests';
import parseName from '../../util/parseName';
import Typography from '@material-ui/core/Typography';
import SideBar from '../../components/SideBar'
import styles from '../../desktopStyles';


class Dashboard extends React.Component{
  constructor({match}){
    super()
    this.state = {
      containers:[],
      sortedContainers:{
        Manufacturer:[],
        Carrier:[],
        Warehouse:[],
        Store:[]
      },
      containerIndex: 0,
      history:[],
    }
    this.handleChange = this.handleChange.bind(this);
  }


  handleChange  = value => {
    this.setState({
      input: value,
    });
  };
  //api calls
  async getAllContainers(){
    let containers = await api.getContainers()
    this.setState({containers:containers,
      sortedContainers:{Manufacturer:[],
        Carrier:[],
        Warehouse:[],
        Store:[]}})
  }

  //componentDid
  componentDidMount(){
    this.timer = setInterval(() => this.getAllContainers() //longpolling every 2 seconds
    .then(()=>{
      this.filterByRole();
    })
    .catch(error => {
      console.log(error);
    })
    , 2000);
  }
  componentWillUnmount(){
    //api.cancelRequest(); //in order to cancel async requests but kinda glitchy on going back to the page
    clearInterval(this.timer);
    this.timer= null;

  }

  //function to filter containers by role
  filterByRole(){
    var newSortedContainers = this.state.sortedContainers;
    this.state.containers.map(container => {
      let role = parseName.getOrganizationUnit(container.custodian);
      newSortedContainers[role].push(container);
      return("")
    })
    this.setState({sortedContainers:newSortedContainers});

  }

  getTables(sortedContainers,classes){
    let temp=[];
    let i = 1;
    let colors = {1:'#38BDB1',2:'#6FA5FC',3:'#A34CCE',0:'#9f91F3'}
    for(var role in sortedContainers){
      temp.push(
        <div className = {classes.column} key = {role}>
          <Typography className = {classes.columnHeading} style = {{color:colors[i%4]}} variant='h4'> {role} </Typography>
          <Table containers={sortedContainers[role]} color={colors[i%4]}/>
        </div>
      )
      i++
    }
    return temp;
  }

  render(){
    const { classes } = this.props;
    const { sortedContainers } = this.state;
    return(
      <div className = {classes.root}>
          <DesktopAppBar/>
          <SideBar/>
          <div className={classes.dashContent}>
            <Typography variant='h3' className = {classes.titleText}> Active Shipments </Typography>
            <div className={classes.columns}>
              {this.getTables(sortedContainers,classes)}
            </div>
          </div>
      </div>
    );
  }
}


export default withStyles(styles)(Dashboard);
