import React from 'react';
import { Link } from 'react-router-dom';
import { withStyles } from '@material-ui/core/styles';
import { Typography, Button, ListItem, List ,IconButton} from '@material-ui/core';
import RemoveCircle from '@material-ui/icons/RemoveCircle';
import DetailHeader from '../../components/DetailHeader';
import MenuBar from '../../components/MenuBar';
import ItemCard from '../../components/ItemCard';
import supplyChainRequests from '../../util/api/supplyChainRequests';
import styles from '../../mobileStyles';

class ContainerDetails extends React.Component {
  constructor({match}){
    super();

    this.state = {
      trackingID: match.params.trackingID,
      container: {
        trackingID: match.params.trackingID,
        misc:{

        }
      },
      items: [],
      isLoading: [],
      isRemoved: [],
      buttonText: [],
    };
  }

  unPackageItem(productID) {
    let loading = this.state.isLoading;
    let added = this.state.isRemoved;
    let buttonText = this.state.buttonText;
    loading[productID] = true;
    buttonText[productID] = '...';


    this.setState({
      isLoading: loading,
      buttonText: buttonText
    });

    let contents = {contents:productID};
    console.log(contents);
    supplyChainRequests.unPackageGood(this.state.trackingID, contents)
    .then(res => {
      loading[productID] = false;
      added[productID] = true;
      buttonText[productID] = ' ';
      this.setState({
        isLoading: loading,
        isRemoved: added,
        buttonText: buttonText
      })
    })
    .catch(error => {
      console.error(error);

      loading[productID] = false;
      added[productID] = true;
      buttonText[productID] = 'Error';
      this.setState({
        isLoading: loading,
        isRemoved: added,
        buttonText: buttonText
      })
    });
    this.update = true;
  }

  async componentDidMount() {
    let container = await supplyChainRequests.getContainerByID(this.state.trackingID);
    console.log(container);
    let items = await Promise.all(container.contents.map(itemID => {
      return supplyChainRequests.getProductByID(itemID);
    }))
    .catch(error => {
      console.error(error);
    });

    this.setState({
      container,
      items
    });
  }

  async componentDidUpdate() {
    if (this.update){
      let container = await supplyChainRequests.getContainerByID(this.state.trackingID);
      console.log(container);
      let items = await Promise.all(container.contents.map(itemID => {
        return supplyChainRequests.getProductByID(itemID);
      }))
      .catch(error => {
        console.error(error);
      });

      this.setState({
        container,
        items
      });

      setTimeout(function () {
        this.update = false;
      }.bind(this), 5000);
    }
  }

  render() {
    const { classes } = this.props;
    const { container, items ,isLoading, isRemoved, buttonText} = this.state;
    let containerName = container.misc.name;
    const header = (
      <div className={classes.headerTop}>
        <DetailHeader name={containerName} variant='container' id={container.trackingID} type={container.misc.type?(`${container.misc.type}`):('default')}/>
        <div className={classes.topDetails}>
          <Typography variant="h5" className={classes.regularText}>Description</Typography>
          <Typography variant="h6" className={classes.regularText}> Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium. </Typography>
        </div>
      </div>
    );
    return(
      <MenuBar title="Container" variant = "transistion" header={header}>
        <div className={classes.root}>
          <div className={classes.details}>
            <div className={classes.paddingDiv}>
              <Typography variant="h5" style={{display:"inline-flex",paddingRight:10}} >Products in the Container</Typography>
              <Button variant='contained' className={classes.buttonGreen} style={{display:"inline-flex"}} component={Link} to={`/package/scanner/${this.state.trackingID}`} fullWidth>
                Add
              </Button>
            </div>
            <List className={classes.itemList}>
              {items.map(item => {
                return (
                  <ListItem className={classes.listItem} disableGutters key={item.trackingID}>
                    <Link to={`/product/${item.trackingID}`}>
                      <ItemCard name={item.productName} info={`${item.trackingID.split('-')[0]}...`} type={(item.misc.type)?(`${item.misc.type}`):('default')} />
                    </Link>
                    <IconButton style={{color:'#FF7773'}} disabled={isLoading[item.trackingID] || isRemoved[item.trackingID]} className={classes.circleButton} onClick={() => this.unPackageItem(item.trackingID)}>{buttonText[item.trackingID] || (<RemoveCircle/>)}</IconButton>
                  </ListItem>
                )
              })}
              <ListItem disableGutters>
                {/* links to scanner for create new product, but should be for adding product to container */}
              </ListItem>
            </List>
          </div>
        </div>
      </MenuBar>
    )
  }
}

export default withStyles(styles)(ContainerDetails);
