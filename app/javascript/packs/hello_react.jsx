// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import ReactDOM from 'react-dom';
import 'whatwg-fetch';

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.handleChangeCode = this.handleChangeCode.bind(this);
    this.handleChangeParsers = this.handleChangeParsers.bind(this);
    this.parseCode = this.parseCode.bind(this);

    const parsers = BaconCanonConstant.Parsers.map(p =>
      ({name: p, enabled: p.includes('24')})
    );

    this.state = {
      code: '',
      asts: [],
      parsers: parsers,
    };
  }

  render() {
    return <div>
      <textarea
        cols="30" rows="10"
        onChange={this.handleChangeCode}
        value={this.state.code}
        style={{fontFamily: 'monospace'}}
      ></textarea>
      <ParserCheckboxes
        parsers={this.state.parsers}
        onChecked={this.handleChangeParsers}
      />
      <button className="btn btn-primary" onClick={this.parseCode}>Parse</button>

      {this.state.asts.map(ast =>
        <pre><code>{ast}</code></pre>
      )}
    </div>;
  }

  handleChangeCode(e) {
    this.setState({code: e.target.value});
  }

  handleChangeParsers(e) {
    const enabled = e.target.checked;
    const name = e.target.name;
    const parsers = this.state.parsers.map(p =>
      p.name == name ? {name: p.name, enabled} : p
    );

    this.setState({parsers})
  }

  parseCode() {
    const code = this.state.code;
    const parsers = this.state.parsers
      .filter(p => p.enabled)
      .map(p => p.name);

    fetch('/parse', {
      body: JSON.stringify({
        code,
        parsers,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'POST',
    }).then(resp => resp.json())
      .then(json => this.setState({asts: json}));
  }
}

class ParserCheckboxes extends React.Component{
  render() {
    return <div>
      {this.props.parsers.map(parser =>
        <label key={parser.name}>
          {parser.name}
          <input
            name={parser.name}
            type="checkbox"
            onChange={this.props.onChecked}
            checked={parser.enabled}
          />
        </label>
      )}
    </div>
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Main />,
    document.querySelector('#app-main')
  )
})
