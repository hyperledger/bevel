import React from 'react'
import {Page} from 'containers/Page/Page';
import {Nav} from 'components/Nav/Nav';
import {Sidebar} from 'components/Sidebar/Sidebar';
import {getBraidAPI, getBuildProperties, getNodes, getNotaries, login} from 'scripts/restCalls';
import {isNotary, mutateNodes, sortNodes,} from 'scripts/processData';
import {headersList} from 'scripts/headersList'
import navOptions from 'navOptions.json';

export default class Default extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      nodes: [],
      notaries: [],
      page: 'home',
      braid: {},
      buildProperties: {}
    }
    
    this.getData = this.getData.bind(this);
    this.sortTable = this.sortTable.bind(this);
  }

  componentDidMount(){    
    this.getData();
  }

  getData = async function(){
    let notaries = await getNotaries();
    let nodes = await getNodes();
    let properties = await getBuildProperties();

    nodes = await mutateNodes(nodes);
    nodes = isNotary(nodes, notaries);
    nodes = sortNodes('Organisational Unit', nodes, headersList);
    
    this.setState({
      nodes: nodes,
      notaries: notaries,
      buildProperties: properties
    });
  }

  sortTable(e){
    let sortedNodes = sortNodes(e.target.dataset.header, this.state.nodes, headersList)
    this.setState({nodes: sortedNodes});
  }

  handleBtn = (event, data) => {
    const btnType = event.target.dataset.btn

    switch (btnType.toLowerCase()) {
      case 'swagger':
        window.location = document.baseURI + "swagger/";
        break;
      case 'dashboard':
        this.setState({page: 'home'});
        break;
      case 'braid':
        // window.location = "/braid/api/"
        getBraidAPI()
        .then(result => {
          this.setState({
            braid: result,
            page: 'braid'
          });
        })
        
        break;
      default:
        break;
    }
  }

  render () {
    return (
      <div className='default-component'>
        <Nav toggleModal={this.props.toggleModal} />
        <div className="row">
          {this.props.admin ? 
            <Sidebar 
              navOptions={navOptions} 
              buildProperties={this.state.buildProperties}
              handleBtn={this.handleBtn}/>  : "" }
          <section id="main-content" className={"column" + (this.props.admin ? " column-offset-20" : "")}>
            <Page          
              headersList={headersList}
              nodes={this.state.nodes}
              notaries={this.state.notaries}
              page={this.state.page} 
              sortTable={this.sortTable}
              json={this.state.braid}
              toggleModal={this.props.toggleModal}
              admin={this.props.admin}
              getData={this.getData}
            /> 
          </section>
        </div>        
      </div>    
    )
  }
}