const mapWidth = 900;
const mapHeight = 500;
const smallMapHeight = 500;

const styles = theme => ({
  root: {
    display: 'flex',
    backgroundColor: '#f5f8fA',
    height:'-webkit-fill-available',

  },
  content: {
    flexGrow: 1,
    padding: theme.spacing.unit * 3,
    //marginTop:106,

  },
  largeMapContent: {
    minWidth: mapWidth,
    width:'80%',
    minHeight: mapHeight,
    height: '75%',
    display: 'inline-block',
    marginTop: '20px',
  },
  largeLocationCard: {
    minWidth: mapWidth,
    width:'80%',
    minHeight: mapHeight,
    height: '100%',
    backgroundColor: theme.palette.background.paper,
    display: 'inline-block',
    boxShadow: theme.shadows[5],
  },
  locationText: {
    textAlign: 'left',
    marginLeft: '40px',
    marginTop: '30px',
  },
  map: {
    minWidth: mapWidth,
    width:'100%',
    height: mapHeight,
    margin: '20px 30px 20px 0px',
    display: 'inline-block',
    verticalAlign: 'top',
  },
  smallMap: {
    width: '60%',
    height: smallMapHeight,
    margin: '20px 30px 20px 0px',
    display: 'inline-block',
    verticalAlign: 'top',
  },
  mapOverlay:{
    float:"left",
    zIndex:1,
    position:'relative',
    maxHeight:400,
    width:200,
    backgroundColor:'white',
    margin:10,
    boxShadow: '0 2px 8px 0 rgba(206,206,213,0.50)',
    borderRadius: '4px',
    padding:0,
    overflow:'scroll'
  },
  overlayItem:{
    display:'inline-grid',
    borderTop:'1px solid lightgrey',
    padding:'5px 10px'
  },
  contentContainer: {
    display: 'inline-block',
    marginTop: '160px',
    width:'80%',
  },
  containerName: {
    textAlign: 'left',
    margin: '0px 30px 50px 0px',
    display: 'inline-block',
    verticalAlign: 'top',
  },
  searchField: {
    display: 'inline-block',
    verticalAlign: 'top',
  },
  mapCard: {
    width: '100%',
    height: '600px',
    backgroundColor: theme.palette.background.paper,
    display: 'inline-block',
    boxShadow: theme.shadows[5],
  },

  locationList: {
    marginTop: '30px',
    display: 'inline-block',
    verticalAlign: 'top',
    width: '33%',
    height: '500px',
    overflow: 'scroll',
  },
  tableTitle:{
    paddingTop:'20px',
    textAlign:'left',
  },
  dashContent: {
    marginTop:106,
    flexGrow: 1,
    padding: theme.spacing.unit * 3,
    height:'-webkit-fill-available',
  },
  columnHeading:{
    textAlign:'left',
    marginTop:'25px',
    fontSize:22,
  },
  columns:{
    display:'inline-flex',
    width:'100%',
  },
  column:{
    minWidth:'21%',
    padding:'0px 2%'
  },

  largeText:{
    fontFamily:'PingFangSC-Bold',
  },
  mediumText:{
    fontSize:18,
    color:'#414C5E',
    fontFamily:'PingFangSC-Regular',
  },
  subText:{
    fontSize:12,
    color:'#414C5E',
    textAlign:'left',
    fontFamily:'PingFangSC',
    paddingLeft:50
  },
    titleText:{
      fontSize:24,
      textAlign:'left',
      paddingTop:100,
      paddingLeft:24,
      paddingBottom:34,
  }
});

export default styles
