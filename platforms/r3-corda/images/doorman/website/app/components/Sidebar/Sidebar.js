import React from 'react';

export const Sidebar = (props) => {
  return(
    <div id="sidebar" className="column sidebar-component">
      <ul>
        {
          props.navOptions[0].map((option, index) => {
            return(
              <li key={index}>
                <NavLink title={option.title} icon={option.icon} handleBtn={props.handleBtn} />
              </li>
            );
          }, {props: props})
        }
      </ul>
      <h5 className='title-override'>APIs</h5>
      <ul>
        {
          props.navOptions[1].map(function(option, index){
            return(
              <li key={index}>
                <NavLink title={option.title} icon={option.icon} handleBtn={this.props.handleBtn} />
              </li>
            );
          }, {props: props})
        }
        <li key={Math.floor(Math.random() * 100) + 7}>
          <button 
          className='sidebar-button-component' 
          data-btn="swagger"
          onClick={e => props.handleBtn(e)}>
            <svg 
              xmlns="http://www.w3.org/2000/svg" 
              viewBox="0 0 305.5 305.7" 
              id="Layer_1">
              <circle 
                cx="152.8" 
                cy="152.8" 
                r="142" />
              <path 
                d="M305.5 153c.9 83.3-69.5 153.1-153.5 152.7C70.5 305.3-.5 237.4 0 151.8.5 69.2 69.4-.6 154.2 0c82.4.6 152.2 69.4 151.3 153zm-69.4-.1c-11.6 7.1-15.5 18.1-16.5 30.2-.8 9.1-.8 18.3-1.1 27.4-.3 10.5-2.6 13.3-12.9 13.1-5.2-.1-6.4 1.6-6.3 6.6.3 14.4.1 14.4 14.6 12.9 14-1.4 21.2-7.6 24.3-21.4 1.1-5 1.5-10.1 1.8-15.3.5-8.9.4-17.9 1.2-26.9.9-10.4 5.7-14.7 16-15.4 2.8-.2 3.9-1.2 3.8-3.9-.1-4.5-.2-9 0-13.5.2-3.8-1.1-5.3-5.1-5.3-7.5 0-11.5-2.9-13.5-10.1-1.3-4.6-2-9.4-2.3-14.2-.6-9.3-.4-18.6-1.1-27.9-1.5-18-11.1-26.7-29.2-26.8-10.3-.1-10.3-.1-10.3 10.6 0 8.6 0 8.6 8.7 8.9 6.3.2 8.7 1.7 9.6 7.8.9 6.5.5 13.3.9 19.9 1 16.2.9 32.8 17.4 43.3zm-166.4-.1c11.3-7.4 15.7-17.8 16.4-30 .6-9.1.4-18.3 1.1-27.4.8-10.2 1.8-14 13.2-13.3 5.3.3 6.4-2 5.7-6.4-.1-.7 0-1.3 0-2 0-11.5 0-11.5-11.8-11.2-16.8.4-27 10.2-27.9 26.9-.5 10.1-.7 20.3-1 30.4-.4 14.5-4.1 19-17.9 21.9-1.2.2-2.7 2.3-2.8 3.7-.4 4.5 0 9-.2 13.5-.2 3.9 1.1 5.3 5.1 5.3 7.1 0 11.6 3.2 13.5 9.6 1.2 4.2 2 8.7 2.2 13.2.6 9.5.6 18.9 1.1 28.4 1.2 22 15.8 30.6 39.6 26.8v-9.4c0-8.8 0-8.8-8.9-9.2-6.2-.3-8.4-1.8-9.1-8.1-.8-7.9-.5-15.9-1.1-23.9-.8-14.8-2.5-29.4-17.2-38.8zm40-12.3c-7.1 0-12.8 5.6-12.7 12.5.1 6.8 5.6 12.1 12.5 12.1 7.3 0 12.7-5.4 12.7-12.4-.2-6.7-5.7-12.2-12.5-12.2zm43.1 24.6c7.3 0 12.3-4.8 12.3-12 .1-7.5-4.9-12.6-12.2-12.7-7.3 0-12.5 5.3-12.4 12.6.1 7.1 5.1 12.1 12.3 12.1zm43.2 0c6.9 0 12.9-5.6 12.9-12.2s-5.9-12.4-12.8-12.4-12.7 5.8-12.6 12.5c.1 6.6 5.8 12.1 12.5 12.1z"
              />
            </svg>
            SWAGGER
          </button>
        </li>
      </ul>
    </div>
  );
}

const NavLink = (props) => {
  return(
    <button className='sidebar-button-component' data-btn={props.title} onClick={e => props.handleBtn(e)}>
      <em className={`fa ${props.icon}`}></em>
      {props.title.toUpperCase()}
    </button>
  );
}