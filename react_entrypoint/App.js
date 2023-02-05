import React from 'react';
import { useReducer } from 'react';
import BasicApp from '../01-basic/react/App'
import ParallelApp from '../02-parallel/react/App'
import SequentialApp from '../03-sequential/react/App'
import MultiplicityApp from '../04-multiplicity/react/App'

const App = ({ title }) => <div>
    <BasicApp />
    <br/> <br/>
    <ParallelApp />
    <br/> <br/>
    <SequentialApp />
    <br/> <br/>
    <MultiplicityApp />
</div>

export default App;
