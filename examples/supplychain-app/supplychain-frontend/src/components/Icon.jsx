import React from "react";
import Icons from "../icon/icons.svg";
import PropTypes from 'prop-types';

const Icon = ({ variant, color, size }) => (
  <svg className={`icon ${variant}`} fill={color} width={size} height={size}>
    <use xlinkHref={`${Icons}#${variant}`} />
  </svg>
);

Icon.propTypes = {
  variant: PropTypes.string.isRequired,
  color: PropTypes.string,
  size: PropTypes.number
};

export default Icon;
