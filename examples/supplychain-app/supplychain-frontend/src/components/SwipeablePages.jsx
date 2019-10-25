import React from 'react';
import SwipeableViews from 'react-swipeable-views';

const styles = {
  root: {
    padding: "0 30px",
    overflowX:'visible',
    width:120,
  },
  sliderHeaderContainer:{
    width:120,
    overflowX:'visible',
  },
  title:{
    padding:"25px 0px",
  },
  swipeablePage:{
    height:'-webkit-fill-available',
  }
};


function SwipeablePages(props){
  const {headers,pages,handleChangeIndex,pageIndex} = props;
  return(
    <div>
      <div style={styles.title}>
        <SwipeableViews
          style={styles.root}
          index = {pageIndex}
          enableMouseEvents
          onChangeIndex={handleChangeIndex}
          slideStyle = {styles.sliderHeaderContainer}>
          {headers}
        </SwipeableViews>

      </div>
      <div style={styles.body}>
        <SwipeableViews
          style={styles.swipeablePage}
          index = {pageIndex}
          enableMouseEvents
          onChangeIndex={handleChangeIndex}>
          {pages}
        </SwipeableViews>
      </div>
    </div>
  )
}

SwipeablePages.propTypes = {
  headers: PropTypes.any,
  pages: PropTypes.any,
  handleChangeIndex: PropTypes.object.isRequired,
  pageIndex: PropTypes.number.isRequired,
}

export default (SwipeablePages);
