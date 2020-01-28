import 'babel-polyfill';
import 'whatwg-fetch';
import React from 'react';
import ReactDOM from 'react-dom';
import App from 'containers/App/App';

const render = Component => {
  ReactDOM.render(
    <Component />,
    document.querySelector('#app')
  );
};

document.addEventListener('DOMContentLoaded', function () {
  render(App);
});