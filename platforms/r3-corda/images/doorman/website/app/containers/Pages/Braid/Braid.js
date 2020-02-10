import React from 'react'
import PropTypes from 'prop-types';
import { DisplayBraid } from 'components/DisplayBraid/DisplayBraid';

export const Braid = (props) => {
  const { json } = props
  return (
    <section className='braid-component'>
      <DisplayBraid json={ json }/> 
    </section>
  )
}

Braid.propTypes = {
}