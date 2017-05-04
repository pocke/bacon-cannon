/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import React from 'react';
import ReactDOM from 'react-dom';
import 'whatwg-fetch';
import 'babel-polyfill';
import groupBy from 'lodash.groupby';

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.handleChangeCode = this.handleChangeCode.bind(this);
    this.handleChangeParsers = this.handleChangeParsers.bind(this);
    this.parseCode = this.parseCode.bind(this);
    this.getParmlink = this.getParmlink.bind(this);

    const parsers = BaconCannonConstant.Parsers.map(p =>
      ({name: p, enabled: p.includes('24')})
    );
    const code = BaconCannonConstant.Code || '';
    const asts = BaconCannonConstant.ASTs || [];
    const parmlink_uuid = location.pathname.startsWith('/parmlinks/') ?
      location.pathname.split('/').pop()
      : null;

    this.state = {
      code,
      asts,
      parsers,
      parmlink_uuid,
      error: {},
      isError: false,
      isLoading: false,
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
        placeholder="puts 'Hello, world'"
        name="ruby_code"
      ></textarea>
      <ParserCheckboxes
        parsers={this.state.parsers}
        onChecked={this.handleChangeParsers}
      />
      <button className="btn btn-primary" onClick={this.parseCode}>Parse</button>&nbsp;
      <button className="btn btn-default" onClick={this.getParmlink} disabled={this.state.asts.length === 0}>Permlink</button>
      <hr />

      <ErrorAlert isError={this.state.isError} error={this.state.error} />
      <Loading isLoading={this.state.isLoading} />

      {this.state.asts.map(ast =>
        ast.error_class ?
          <ASTError key={ast.parser} error={ast}></ASTError> :
          <ASTContent key={ast.parser} ast={ast}></ASTContent>
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
    this.setState({asts: [], isError: false, isLoading: true});

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
    }).then(resp => {
      resp.json().then(json => {
        if (resp.status / 100 === 2) {
          this.setState({asts: json, isLoading: false});
        } else {
          this.setState({error: json, isError: true, isLoading: false});
        }
      })
    });
  }

  getParmlink() {
    const code = this.state.code;
    const asts = this.state.asts;
    fetch('/permlinks', {
      body: JSON.stringify({
        code,
        asts,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'POST',
    }).then(resp => {
      resp.json().then(json => {
        if (resp.status / 100 === 2) {
          const uuid = json['uuid'];
          window.history.pushState(null, '', `/permlinks/${uuid}`);
          this.setState({parmlink_uuid: uuid});
        } else {
          this.setState({error: json, isError: true, isLoading: false});
        }
      })
    });
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
      <h4>{ast.parser}</h4>
      <ul>
        {Object.keys(ast.meta).map(key =>
          <li key={key}><code>{key}</code>: <code>{ast.meta[key]}</code></li>
        )}
      </ul>
      <pre><code>{ast.ast}</code></pre>
    </div>
  }
}

class ASTError extends React.Component {
  render() {
    const error = this.props.error;
    return <div>
      <h4>{error.parser}</h4>
      <div className="alert alert-danger" role="alert">
        {error.error_class}<br />
        {error.error_message}
      </div>
    </div>
  }
}

class ErrorAlert extends React.Component {
  render() {
    const error = this.props.error;
    return this.props.isError ?
      <div className="alert alert-danger" role="alert">
        {error.error_class}<br />
        {error.error_message}
      </div> :
      null;
  }
}

class Loading extends React.Component {
  render() {
    return this.props.isLoading ?
      <img src="/loading.svg" alt="Loading..." /> :
      null;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Main />,
    document.querySelector('#app-main')
  )
})
