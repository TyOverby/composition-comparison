import React, { useReducer } from 'react';
import ReactDOM from 'react-dom';
import Counter, {
  applyAction as counterApplyAction,
  defaultState as counterDefaultState,
} from '../../shared/Counter';

const defaultState = {
  first: counterDefaultState,
  second: counterDefaultState,
};

function applyAction(state, { which, subAction }) {
  switch (which) {
    case 'first':
      return {
        ...state,
        first: counterApplyAction(state.first, subAction),
      };
    case 'second':
      return {
        ...state,
        second: counterApplyAction(state.second, subAction),
      };
  }
}

const App = () => {
  let [state, inject] = useReducer(applyAction, defaultState);
  let injectFirst = (subAction) => inject({ which: 'first', subAction });
  let injectSecond = (subAction) => inject({ which: 'second', subAction });
  return (
    <div>
      <Counter label="first" by={1} state={state.first} inject={injectFirst} />
      <Counter
        label="second"
        by={state.first}
        state={state.second}
        inject={injectSecond}
      />
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('app'));
