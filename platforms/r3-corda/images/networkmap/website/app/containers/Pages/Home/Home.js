import React from 'react'
import PropTypes from 'prop-types';
import {Nav} from 'components/Nav/Nav'
import {Table} from 'components/Table/Table';
import DemoMap from 'components/Map/MyMap';
import {Metrics} from 'components/Metrics/Metrics';

export const Home = (props) => {
  const { nodes, notaries, headersList, sortTable } = props
  return (
    <section className='home-component'>
      <DemoMap nodes={nodes}/>          
      <Metrics 
        nodes={nodes}
        notaries={notaries}
      />
      <Table 
        headersList={headersList}
        rowData={nodes}
        sortTable={sortTable}
        toggleModal={props.toggleModal}
        admin={props.admin}
      />
    </section>
  )
}

Home.propTypes = {
  headersList: PropTypes.object.isRequired,
  nodes: PropTypes.array.isRequired,
  notaries: PropTypes.array.isRequired
}

/*
<DemoMap nodes={nodes}/>
<Metrics 
  nodes={nodes}
  notaries={notaries}
/>

*/