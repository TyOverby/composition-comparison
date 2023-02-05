import React, { useReducer } from 'react';
import ReactDOM from 'react-dom';
import Counter, { applyAction, defaultState } from '../../shared/Counter';

const App = () => {
  let [state1, inject1] = useReducer(applyAction, defaultState);
  let [state2, inject2] = useReducer(applyAction, defaultState);
  return (
    <div>
      <Counter label="first" by={1} state={state1} inject={inject1} />
      <Counter label="second" by={1} state={state2} inject={inject2} />
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('app'));
