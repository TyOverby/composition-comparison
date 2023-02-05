import React, { useReducer } from 'react';
import Counter, {
  applyAction as counterApplyAction,
  defaultState as counterDefaultState,
} from '../../shared/Counter';

const defaultState = {};

function applyAction(state, { which, subAction }) {
  return {
    ...state,
    [which]: counterApplyAction(state[which] || 0, subAction),
  };
}

const App = ({ title }) => {
  let [howMany, injectHowMany] = useReducer(
    counterApplyAction,
    counterDefaultState
  );
  let [subcomponentState, subcomponentInject] = useReducer(
    applyAction,
    defaultState
  );
  let subcomponents = Array.from({ length: howMany }, function (_, i) {
    let injectMe = (subAction) => subcomponentInject({ which: i, subAction });
    return (
      <Counter
        key={i}
        label={i}
        by={1}
        state={subcomponentState[i] || 0}
        inject={injectMe}
      />
    );
  });
  return (
    <div>
      <Counter
        label="how many"
        by={1}
        state={howMany}
        inject={injectHowMany}
      />
      {subcomponents}
    </div>
  );
};

export default App;
