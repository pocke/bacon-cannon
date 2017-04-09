// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import ReactDOM from 'react-dom';
import 'whatwg-fetch';
import groupBy from 'lodash.groupby';

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.handleChangeCode = this.handleChangeCode.bind(this);
    this.handleChangeParsers = this.handleChangeParsers.bind(this);
    this.parseCode = this.parseCode.bind(this);

    const parsers = BaconCannonConstant.Parsers.map(p =>
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
        rows="10"
        onChange={this.handleChangeCode}
        value={this.state.code}
        style={{fontFamily: 'monospace'}}
        className="form-control"
      ></textarea>
      <ParserCheckboxes
        parsers={this.state.parsers}
        onChecked={this.handleChangeParsers}
      />
      <button className="btn btn-primary" onClick={this.parseCode}>Parse</button>
      <hr />

      {this.state.asts.map(ast =>
        ast.error_class ?
          <ASTError key={ast.parser_name} error={ast}></ASTError> :
          <ASTContent key={ast.parser_name} ast={ast}></ASTContent>
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
    const {ripper, parser} = groupBy(this.props.parsers, p => /^([a-z]+)_/.exec(p.name)[1]);

    return <div className="row">
      <ParserCheckboxesContent
        parsers={ripper}
        onChecked={this.props.onChecked}
      />
      <ParserCheckboxesContent
        parsers={parser}
        onChecked={this.props.onChecked}
      />
    </div>
  }
}

class ParserCheckboxesContent extends React.Component {
  render() {
    return <div className="col-xs-6">
      {this.props.parsers.map(parser =>
        <div className="checkbox" key={parser.name}>
          <label>
            <input
              name={parser.name}
              type="checkbox"
              onChange={this.props.onChecked}
              checked={parser.enabled}
            />
            {parser.name}
          </label>
        </div>
      )}
    </div>

  }
}

class ASTContent extends React.Component {
  render() {
    const ast = this.props.ast;
    return <div>
      <h4>{ast.parser_name}</h4>
      <ul>
        {Object.keys(ast.meta).map(key =>
          <li><code>{key}</code>: <code>{ast.meta[key]}</code></li>
        )}
      </ul>
      <pre><code>{ast.body_screen}</code></pre>
    </div>
  }
}

class ASTError extends React.Component {
  render() {
    const error = this.props.error;
    return <div>
      <h4>{error.parser_name}</h4>
      <div className="alert alert-danger" role="alert">
        {error.error_class}<br />
        {error.error_message}
      </div>
    </div>
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Main />,
    document.querySelector('#app-main')
  )
})
