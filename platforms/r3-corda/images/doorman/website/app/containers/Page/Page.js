import React from 'react';
import PropTypes from 'prop-types';
import {Home} from 'containers/Pages/Home/Home'
import {Swagger} from 'containers/Pages/Swagger/Swagger';
import {Braid} from 'containers/Pages/Braid/Braid'

const PAGES = {
  home: Home,
  swagger: Swagger,
  braid: Braid
}

export const Page = (props) => {
  const Handler = PAGES[props.page]

  return <Handler {...props} />
}

Page.propTypes = {
  page: PropTypes.oneOf(Object.keys(PAGES)).isRequired
}
