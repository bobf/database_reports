import React from 'react'
import { createRoot } from 'react-dom/client'

const DatabaseInspector = (props) => {
  return <div className="bg-purple-800">hello</div>
}

document.addEventListener('DOMContentLoaded', () => {
  console.log(document.querySelector('#react-database-inspector'))
  const root = createRoot(document.querySelector('#react-database-inspector'))
  root.render(<DatabaseInspector />)
})
