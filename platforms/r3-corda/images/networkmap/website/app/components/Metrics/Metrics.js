import React from 'react';

export const Metrics = (props) => {
  return(
    <div className="row grid-responsive metrics-component">
      <Metric nodes={props.nodes} />
      <Metric notaries={props.notaries} />
    </div>
  );
}

const Metric = (props) => {
  let node = Object.keys(props)[0];
  let additions = '';
  if(node === 'notaries'){
    additions = 'Node';
  }
  return(
    <div className="m-component column">
      <div className="card">
        <div className="card-title">
          <h2 className="float-left">{node + " " + additions + " #"}</h2>
          <div className="badge background-primary float-right">{props[node].length}</div>
          <div className="clearfix"></div>
        </div>
      </div>
    </div>
  );
}

