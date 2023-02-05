import React from 'react';

export const defaultState = 0;

export function applyAction(state, { action, by }) {
  switch (action) {
    case 'increment':
      return state + by;
    case 'decrement':
      return state - by;
    default:
      console.error('BUG');
  }
}

const Counter = ({ label, by, state, inject }) => {
  let increment = () => inject({ action: 'increment', by });
  let decrement = () => inject({ action: 'decrement', by });
  return (
    <div>
      {label}:<button onClick={decrement}> -{by}</button>
      {state}
      <button onClick={increment}> +{by}</button>
    </div>
  );
};

export default Counter;
