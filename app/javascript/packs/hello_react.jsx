// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import ReactDOM from 'react-dom';
import 'whatwg-fetch';

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.handleChange = this.handleChange.bind(this);
    this.parseCode = this.parseCode.bind(this);

    this.state = {code: '', asts: []};
  }

  render() {
    return <div>
      <textarea cols="30" rows="10" onChange={this.handleChange}>{this.state.code}</textarea>
      <button onClick={this.parseCode}>Parse</button>

      {this.state.asts.map(ast =>
        <pre><code>{ast}</code></pre>
      )}
    </div>;
  }

  handleChange(e) {
    this.setState({code: e.target.value});
  }

  parseCode() {
    const code = this.state.code;
    fetch('/parse', {
      body: JSON.stringify({code: code}),
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'POST',
    }).then(resp => resp.json())
      .then(json => this.setState({asts: json}));
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Main />,
    document.querySelector('#app-main')
  )
})
