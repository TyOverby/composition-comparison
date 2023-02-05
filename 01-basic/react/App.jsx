import React, { useReducer } from 'react';
import ReactDOM from 'react-dom';
import Counter, { applyAction, defaultState } from '../../shared/Counter';

const App = () => {
  let [state, inject] = useReducer(applyAction, defaultState);
  return <Counter label="counter" by={1} state={state} inject={inject} />;
};

ReactDOM.render(<App />, document.getElementById('app'));
