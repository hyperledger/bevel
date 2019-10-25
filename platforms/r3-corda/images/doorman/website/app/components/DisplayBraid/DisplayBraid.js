import React from 'react'

export const DisplayBraid = (props) => {
  return(
    <div className="display-braid-component column">
      <div className="card">
        <div className="card-title">
          <h2>Braid API</h2>
          <div className="clearfix">
            <pre>{JSON.stringify(props.json, null, 2)}</pre>
          </div>
        </div>
      </div>
    </div>
  );
}

