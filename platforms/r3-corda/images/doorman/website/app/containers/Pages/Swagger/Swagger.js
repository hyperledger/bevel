import React from 'react';

export const Swagger = (props) => {
  console.log(document.baseURI);
  return(
    <div className='swagger-component'>
      <iframe 
      title="Swagger API" src="{ document.baseURI }swagger/#/admin/post_admin_api_login" />
    </div>
  );
}