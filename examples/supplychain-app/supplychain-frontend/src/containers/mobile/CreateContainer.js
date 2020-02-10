import React from 'react';
import { Link } from 'react-router-dom';
import { withStyles } from '@material-ui/core/styles';
import { Button, ListItem, List, Typography } from '@material-ui/core';
import DetailHeader from '../../components/DetailHeader';
import MenuBar from '../../components/MenuBar';
import ItemCard from '../../components/ItemCard';
import InputBase from '@material-ui/core/InputBase';
import IconButton from '@material-ui/core/IconButton';
import SearchIcon from '@material-ui/icons/Search';
import AddCircle from '@material-ui/icons/AddCircle';
import supplyChainRequests from '../../util/api/supplyChainRequests';
import parseName from '../../util/parseName';
import styles from '../../mobileStyles';

class CreateContainer extends React.Component {
  constructor({match}){
    super();

    this.state = {
      trackingID: match.params.trackingID,
      container: {
        id: match.params.trackingID,
        misc:{},
      },
      filteredOrphanedItems: [],
      isLoading: [],
      isAdded: [],
      buttonText: [],
      searchedItems: [],
      //chipData:[{}],
    };
    this.handleDelete = this.handleDelete.bind(this);
  }

  handleDelete = data => () => {
      this.setState(state => {
        const chipData = [...state.chipData];
        const chipToDelete = chipData.indexOf(data);
        chipData.splice(chipToDelete, 1);
        return { chipData };
      });
    };

  packageItem(productID) {
    let loading = this.state.isLoading;
    let added = this.state.isAdded;
    let buttonText = this.state.buttonText;
    // let chipValue = productID.split('-')[0];
    // let chipIndex = this.state.chipData.length;
    // let chip = {[chipIndex]:chipValue};
    loading[productID] = true;
    buttonText[productID] = '...';


    this.setState({
      isLoading: loading,
      buttonText: buttonText
    });

    let contents = {contents:productID};
    console.log(contents);
    supplyChainRequests.packageGood(this.state.trackingID, contents)
    .then(res => {
      loading[productID] = false;
      added[productID] = true;
      buttonText[productID] = 'Added';
      this.setState({
        isLoading: loading,
        isAdded: added,
        buttonText: buttonText,
        //chipData: this.state.chipData.push(chip)
      })
    })
    .catch(error => {
      console.error(error);

      loading[productID] = false;
      added[productID] = true;
      buttonText[productID] = 'Error';
      this.setState({
        isLoading: loading,
        isAdded: added,
        buttonText: buttonText
      })
    });
    this.update = true;
  }

  filterList(event) {
		var updatedList = this.state.filteredOrphanedItems;
		updatedList = updatedList.filter(function(item){
      return item.productName.toLowerCase().search(
        event.target.value.toLowerCase()) !== -1;
    });
    this.setState({searchedItems: updatedList});
	}


  async componentDidMount() {
    let container = await supplyChainRequests.getContainerByID(this.state.trackingID);
    let orphanedItems = [];
    orphanedItems = await supplyChainRequests.getContainerlessProducts();
    let filteredOrphanedItems = orphanedItems.filter(item =>
      parseName.getOrganizationUnit(item.custodian)===this.props.role
    );
    this.setState({
      container,
      filteredOrphanedItems,
      searchedItems: filteredOrphanedItems
    });
  }
  async componentDidUpdate() {
    if(this.update){
      let container = await supplyChainRequests.getContainerByID(this.state.trackingID);
      let orphanedItems = [];
      orphanedItems = await supplyChainRequests.getContainerlessProducts();
      let filteredOrphanedItems = orphanedItems.filter(item =>
        parseName.getOrganizationUnit(item.custodian)===this.props.role
      );

      this.setState({
        container,
        filteredOrphanedItems,
        searchedItems: filteredOrphanedItems
      });

      setTimeout(function () {
        this.update = false;
      }.bind(this), 5000);
    }
  }

  render() {
    const { classes } = this.props;
    const { container, searchedItems, isLoading, isAdded, buttonText } = this.state;

    return(
      <MenuBar title="Container" variant = "transistion"
        header={
          <div>
            <DetailHeader name="Container 1" variant='container' id={container.id} type={container.misc.type?(`${container.misc.type}`):('default')} />
            <Typography variant="subtitle2" component={Link} to={`/container/${container.trackingID}`}>Add Products Later</Typography>
          </div>
          }>
        <div className={classes.root} >
          <div className={classes.details}>
              <div className={classes.addProducts}>
                <Typography variant="subtitle2">Add product to container</Typography>
              </div>
              {/*chipData.map(data => {
                let icon = null;
                return (
                  <Chip
                    key={data.key}
                    icon={icon}
                    label={data.label}
                    onDelete={this.handleDelete(data)}
                    className={classes.chip}
                  />
                );
              })*/}
              <div className={classes.searchItems}>
                <IconButton className={classes.iconButton} aria-label="Search">
                  <SearchIcon />
                </IconButton>
                <InputBase className={classes.input} placeholder=" " onChange={this.filterList.bind(this)}/>
              </div>
              <List className={classes.itemList}>
                {searchedItems.map(item => {
                  return (
                    <ListItem className={classes.listItem} disableGutters key={item.trackingID}>
                      <Link to={`/product/${item.trackingID}`}>
                        <ItemCard name={item.productName} info="Additional details..." type={(item.misc.type)?(`${item.misc.type}`):('default')}/>
                      </Link>
                      <IconButton disabled={isLoading[item.trackingID] || isAdded[item.trackingID]} className={classes.circleButton} onClick={() => this.packageItem(item.trackingID)}>{buttonText[item.trackingID] || (<AddCircle/>)}</IconButton>
                    </ListItem>
                  )
                })}
                <ListItem disableGutters>
                  {/* links to scanner for create new product, but should be for adding product to container */}
                </ListItem>
              </List>
            <div>
              <Button className={classes.button1} variant="contained" component={Link} to={`/container/${container.trackingID}`}>Done</Button>
            </div>
          </div>

        </div>

      </MenuBar>
    )
  }
}

export default withStyles(styles)(CreateContainer);
