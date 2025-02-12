// App.jsx
import React, { useState } from 'react';

function App() {
  const [count, setCount] = useState(0); // unused variable (should trigger eslint warning)

  const increment = () => {
    setCount(count + 1);
  };

  return (
    <div>
      <h1>Hello, World!</h1>
      <p>Count: {count}</p>
      <button onClick={increment}>Increment</button>
    </div>
  );
}

export default App;
