import React, {useReducer } from 'react';
import Counter, {applyAction, defaultState} from '../../shared/Counter'

const App = ({ title }) => {
    let [state, inject] = useReducer(applyAction, defaultState);
    return <Counter label="counter" by={1} state={state} inject={inject} />;
}

export default App;
