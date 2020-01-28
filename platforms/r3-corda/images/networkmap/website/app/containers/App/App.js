import React from 'react';
import Default from 'containers/Default/Default';
import { Login } from 'containers/Login/Login'
import { login, checkAuth, deleteNodes } from 'scripts/restCalls';
import { LoginModal, LogoutModal, DeleteModal } from 'components/Modal/Modal';

export default class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      admin: (sessionStorage["AccessToken"]) ? true : false,
      status: 'done',
      subDomain: 'default',
      style: false,
      modal: ''
    }

    this.NMSLogin = this.NMSLogin.bind(this);
    this.toggleModal = this.toggleModal.bind(this);
    this.setAdmin = this.setAdmin.bind(this);
    this.deleteNode = this.deleteNode.bind(this);
  }
  

  NMSLogin(loginData){
    return login(loginData)
    .then( () => checkAuth() )
    .then( status => {
      if(status != 200)  return "fail";
      return "success";
    })
    .catch( err => console.log(err) )
  }

  toggleModal(e, node){
    if(!e){
      this.setState({
        modal: '',
        style: !this.state.style
      }) 
    }
    else if(e.target.dataset.link){
      this.setState({
        modal: e.target.dataset.link || '',
        style: !this.state.style,
        selectedNode: (!!node) ? node : null
      })    
    }
  }

  setAdmin(adminFlag){
    this.setState({ admin: adminFlag});
  }

  deleteNode(){
    deleteNodes(this.state.selectedNode.nodeKey)
    .then(result => this.setState({selectedNode: null}) )
  }

  render(){
    let page = null;
    switch(this.state.subDomain){
      case 'login':
        page = <Login nmsLogin={this.NMSLogin} />;
        break;
      case 'default':
        page = <Default 
                toggleModal={this.toggleModal} 
                admin={this.state.admin} />;
        break;
      default: 
        page = <Login nmsLogin={this.nmsLogin} />;
        break;
    }

    let modal = null;
    switch(this.state.modal){
      case 'sign-in':
        modal = <LoginModal
                  toggleModal={this.toggleModal}
                  style={this.state.style} 
                  nmsLogin={this.NMSLogin}
                  setAdmin={this.setAdmin}/>
        break;
      case 'sign-out':
        modal = <LogoutModal 
                  toggleModal={this.toggleModal}
                  style={this.state.style} 
                  setAdmin={this.setAdmin} />
        break;
      case 'delete':
        modal = <DeleteModal 
                  toggleModal={this.toggleModal}
                  style={this.state.style} 
                  setAdmin={this.setAdmin}
                  selectedNode={this.state.selectedNode}
                  deleteNode={this.deleteNode} />
        break;
      default:
        modal = "";
        break;
    }
    
    return (
      <div className='app-component'>
        { (this.state.status == 'done') ? page :  "" }
        { modal }
      </div>    
    );
  }
}