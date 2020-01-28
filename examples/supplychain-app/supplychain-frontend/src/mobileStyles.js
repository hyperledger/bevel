const mapHeight = 400;

const styles = theme => ({
  app :{
    textAlign: 'center',
    width:'100vw',
    height:'100vh',
    backgroundColor: '#f5f8fA',
    overflowX:'hidden',
  },
  scanPaper: {
    position : 'absolute',
    textAlign: 'center',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%) !important',
    width: 160,
    backgroundColor: theme.palette.background.paper,
    boxShadow: theme.shadows[5],
    padding: theme.spacing.unit * 4,
    borderRadius: 8
  },
  menuRoot: {
    flexGrow: 1,
    overflowX:'hidden',
  },
  appBar:{
    backgroundColor:'#FDFDFD',
    color:'black',
    borderBottomRightRadius:28,
    borderBottomLeftRadius:28,
    position:'relative',
    zIndex:1500,
  },
  appBarProduct:{
    backgroundColor:'white',
    color:'black',
    //borderBottomRightRadius:28,
    //borderBottomLeftRadius:28,
    position:'relative',
    zIndex:1500,
    boxShadow:'none',
  },
  grow: {
    flexGrow: 1,
    fontFamily:'PingFangSC-Regular',
  },
  menuButton: {
    marginLeft: -12,
  },
  notiButton: {
    marginRight: -12,
  },
  bodyContent:{
  },
  root: {
    display: 'flex',
    flexDirection: 'column',
    width: '100%',
  },
  details: {
    position:'relative',
    top:'-28px',
    flex: 1,
    padding: '48px 40px 0px 40px',
    textAlign: 'left',
    //height:'-webkit-fill-available'
  },
  buttons: {
    marginBottom: '8px'
  },
  landingBottom: {
    backgroundColor: '#F8F9FA',
    height: 'inherit',
    overflowX:'hidden',
  },
  slide: {
    width: '90%',
    margin: '0 Auto',
    textAlign:'left'
  },
  map: {
    width: '100%',
    height: mapHeight,
    marginBottom: '20px',
    marginTop: '20px',
  },
  itemList: {
    backgroundColor: '#F3F5F6',
    maxHeight: 150,
    overflow: 'auto',
    marginBottom: '15px'
  },
  listItem: {
    padding: '2px 0px',
    backgroundColor: '#FFFFFF',
    borderColor: '#DEE0E3',
    borderWidth: '1px',
    borderStyle: 'solid',
  },
  smallButton: {
    backgroundColor:'#BEC2C6',
    width: '10%',
    marginRight: '10px',
  },
  button1: {
    backgroundColor:'#FFFFFF',
    border: '1px solid #DEE0E3',
    fontSize:12,
    fontFamily:'PingFangSC-Regular',
    minWidth: '50%',
    display: 'block',
    textAlign: 'center',
  },
  buttonRed: {
    backgroundColor:'#FF7773',
    fontSize:13,
    color:'white',
    fontFamily:'PingFangSC-Regular',
    width: 'fit-content',
    display: 'inline-flex',
    textAlign: 'center',
    padding:5,
    margin:5,
  },
  buttonGreen: {
    backgroundColor:'#5DC09B',
    color:'white',
    fontSize:13,
    fontFamily:'PingFangSC-Regular',
    width: 'fit-content',
    display: 'inline-flex',
    textAlign: 'center',
    padding:5,
    margin:5,

  },
  circleButton:{
    borderRadius:'50%',
    height:30,
    width:30,
    color:'grey',
    fontSize:20,
    padding:0,
    margin:0,
    flexGrow:1,
  },
  addProducts: {
    display: 'flex',
    justifyContent: 'space-between',
    padding:'0 10px 0 10px',
  },

  //componentStyles
  detailHeaderRoot: {
    width: '100%',
    padding: '0px 0px 40px 0px',
  },
  detailHeaderIcon: {
    fontSize: '100px',
    height:'200px',
    margin: '15px 0px'
  },
  locationBody:{
    display:'inline-flex',
    alignItems:'center',
    width:'100%'
  },
  date:{
    paddingRight:30,
  },
  historyItem:{
    height:60,
    float:'right',
    backgroundColor:'white',
    padding:0,
    margin:5,
    display:"inline-table",
  },
  //Text
  boldText:{
    fontFamily:'PingFangSC-Regular',
    fontWeight:600,
  },
  chip: {
    margin: theme.spacing.unit / 2,
  },
  regularText:{
    fontFamily:'PingFangSC-Regular',
    textAlign:'left',
    paddingBottom:10
  },
  lightText:{
    fontFamily:'PingFangSC-Regular',
    textAlign:'left',
  },
  lastScanned:{
    display:'grid',
    alignItems:'center',
    height:'100%',
    width:200
  },
  currentLocation:{
    backgroundColor:'white',
    borderRadius:6,
    boxShadow:theme.shadows[3],
    padding:5,
  },
  headerTop:{
    margin:'20px 0px',
  },
  searchItems: {
    backgroundColor: '#FFFFFF',
    marginTop: '10px',
    borderColor: '#DEE0E3',
    borderWidth: '1px',
    borderStyle: 'solid',
  },
  topDetails:{
    paddingLeft:40
  },
  paddingDiv:{
    paddingTop:15,
    paddingBottom:15,
  },
});

export default styles
