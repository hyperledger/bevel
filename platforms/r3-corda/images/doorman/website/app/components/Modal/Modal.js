import React from 'react'
import { LoginContainer } from 'containers/Login/Login';

const loggingOut = (toggleModal) => {
  sessionStorage.clear();
  toggleModal();
}

export const LoginModal = (props) => {
  return(
    <div 
      className={`modal-component ${ props.style ? 'on' : '' }`} 
      data-link='default' 
      onClick={e => props.toggleModal(e)} >
      <LoginContainer 
        nmsLogin={props.nmsLogin} 
        toggleModal={props.toggleModal}
        setAdmin={props.setAdmin}/>
    </div>
  );
}

export const LogoutModal = (props) => {
  return(
    <div 
      className={`modal-component ${ props.style ? 'on' : '' }`} 
      data-link='default' 
      onClick={e => props.toggleModal(e)} >
      <div className="lm-container">
        <div className="lm-middle">
          <ModalTitle />
          <ModalContent />
          <ModalButtonGroup 
            toggleModal={props.toggleModal}
            setAdmin={props.setAdmin}
            />
        </div>
      </div>
    </div>
  );
}

export const DeleteModal = (props) => {
  return(
    <div
      className={`modal-component ${ props.style ? 'on' : '' }`} 
      data-link='default' 
      onClick={e => props.toggleModal(e)} >
      <div className="lm-container">
        <div className="lm-middle">
          <ModalTitleDelete />
          <ModalContentDelete node={props.selectedNode} />
          <div className="lm-footer">
            <button 
              className="btn pull-right"
              data-btn
              onClick={ (e) => {props.deleteNode(); props.toggleModal()} }>
              Yes
            </button>
            <button 
              className="btn pull-right"        
              data-btn="cancel" 
              onClick={ e => props.toggleModal()}>
              No
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

const ModalTitleDelete = (props) => {
  return(
   <div className="lm-title">
      <span className="fa fa-trash"></span>
      <strong>{`     Delete Node`}</strong>
    </div>
  );
}

const ModalTitle = (props) => {
  return(
   <div className="lm-title">
      <span className="fa fa-sign-out"></span>
      <strong>{` LOG OUT?`}</strong>
    </div>
  );
}

const ModalContentDelete = (props) => {
  return(
    <div className="lm-content">
      <p className="node-id">{props.node.O}</p>
      <p className="node-id">for node {props.node.nodeKey}</p>
      <p>Are you sure you want to delete this node?</p>
    </div>    
  );
}

const ModalContent = (props) => {
  return(
    <div className="lm-content">
      <p>Are you sure you want to log out?</p>                    
      <p>Press No if you want to continue work. Press Yes to logout current user.</p>
    </div>    
  );
}

const ModalButtonGroup = (props) => {
  return(
    <div className="lm-footer">
      <button 
        className="btn pull-right"
        data-btn
        onClick={ (e) => { props.setAdmin(false); loggingOut(props.toggleModal); } }>
        Yes
      </button>
      <button 
        className="btn pull-right"        
        data-btn="cancel" 
        onClick={ e => props.toggleModal()}>
        No
      </button>
    </div>
  );
}