import React from 'react'

const handleLogin = (nmsLogin, loginData) => {
  let result = nmsLogin(loginData);
  (result == 'fail') ? true : false;
}

export const Login = (props) => {
  return (
    <div className='login-component' >
      <LoginContainer {...props} />
    </div>
  )
}

export const LoginContainer = (props) => {
  return(
    <div className='login-container-component'>
      <LoginLogo title="stats" />
      <LoginMain 
      nmsLogin={props.nmsLogin} 
      toggleModal={props.toggleModal}
      setAdmin={props.setAdmin} />
      <LoginFooter />
    </div>
  );
}

const LoginLogo = (props) => {
  return(
    <div className='login-logo-component'></div>
  );
}

const LoginMain = (props) => {
  return(
    <div className='login-main-component'>
      <LoginTitle title='Welcome, Please login' />
      <LoginForm
        nmsLogin={props.nmsLogin}
        toggleModal={props.toggleModal}
        setAdmin={props.setAdmin} />
    </div>
  );
}

const LoginFooter = () => {
  return(
    <div className='login-footer-component'>
      <div className="footer-links">
        <a href="#">About</a>
        &nbsp;|&nbsp;
        <a href="#">Privacy</a>
        &nbsp;|&nbsp;
        <a href="#">Contact Us</a>
      </div>
    </div>
  );
}

const LoginTitle = (props) => {
  return(
    <div className='login-title-component'>{props.title}</div>
  );
}

class LoginForm extends React.Component {
  constructor(props){
    super(props)
    this.state = {
      user: '',
      password: '',
      error: ''
    }
    this.handleChange = this.handleChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick = async function(e){
    e.preventDefault();
    if(e.target.dataset.btn == 'cancel'){
      this.props.toggleModal();
      return;
    }
    const loginData = {
      user: this.state.user,
      password: this.state.password
    }
    let result = await this.props.nmsLogin(loginData);
    if (result == 'fail') {
      this.setState({error: 'error'})
    }
    else {
      this.props.setAdmin(true);
      this.props.toggleModal();
    }
  }

  handleChange(e){
    e.preventDefault();
    const { type, value } = e.target;
    switch(type){
      case "text":
        this.setState({ user: value, error: ''});
        break;
      case "password":
        this.setState({ password: value, error: '' });
        break;
      default:
        break;
    }
  }

  render(){
    return(
      <form className='login-form-component'>
        <FormTextInput
          placeholder="Username"
          value={this.state.value}
          handleChange={this.handleChange} />
        <FormPassword
          placeholder="Password"
          value={this.state.value}
          handleChange={this.handleChange} />
        <FormError error={this.state.error}/>
        <FormButtons onClick={this.handleClick} />
      </form>
    );
  }
}

const FormTextInput = (props) => {
  let { placeholder, value, handleChange } = props
  return(
    <div className="form-text-input-component">
        <input
          autoFocus="true"
          className="form-control"
          placeholder={placeholder}
          value={value}
          type="text"
          onChange={(e) => handleChange(e)} />
    </div>
  );
}

const FormPassword = (props) => {
  let { placeholder, value, handleChange } = props
  return(
    <div className="form-password-component">
        <input
          className="form-control"
          placeholder={placeholder}
          value={value}
          type="password"
          onChange={(e) => handleChange(e)} />
    </div>
  );
}

const FormButtons = (props) => {
  const { onClick } = props
  return(
    <div className="form-buttons-component">
      <a href="#" className="btn">Forgot your password?</a>     
      <button
        className="btn"
        onClick={(e) => onClick(e)}>
        Log In
      </button>
      <button
        className="btn"
        data-btn="cancel"
        onClick={(e) => onClick(e)}>
        Cancel
      </button>
    </div>
  );
}

const FormError = (props) => {
  return(
    <div className={`form-error-component ${props.error}`}>
      Username/password is invalid
    </div>
  );
}