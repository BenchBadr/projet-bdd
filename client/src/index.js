import ReactDOM from 'react-dom/client';
import './App.css';
import reportWebVitals from './reportWebVitals';
import Homepage from './pages/homepage/homepage';
import ToExport from './App';
import { createBrowserRouter, RouterProvider } from 'react-router';
import React, { StrictMode, useEffect, useState } from 'react';
import Codex from './pages/codex/codex';

const Redirect = ({url}) => {
  useEffect(() => {
    window.location.href = url;
  }, []);

  return null;
};

const routes = [
  {
    path:'/',
    element: <ToExport><Homepage/></ToExport>
  },
  {
    path:'/codex',
    element: <ToExport><Codex/></ToExport>
  }
];


const router = createBrowserRouter(routes);

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);

reportWebVitals();

