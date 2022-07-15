import React from 'react';
import { Route, Routes } from 'react-router-dom';
// import { Login } from '../components/auth/Login';
import { PrivateRoute } from '../components/auth/PrivateRoute';
import { UnsignedRoute } from '../components/auth/UnsignedRoute';
import { Dashboard } from '../components/dashboard/Dashboard';
import { Home } from '../components/home/Home';
import { Layout } from '../components/Layout';

export const App = () => {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        {/* Any Person route */}
        <Route index element={<Home />} />

        {/* un-signed in routes */}
        <Route element={<UnsignedRoute />}>
          {/* <Route path="login" element={<Login />} /> */}
        </Route>

        {/* Private routes */}
        <Route element={<PrivateRoute />}>
          <Route path="dashboard" element={<Dashboard />} />
        </Route>
      </Route>
    </Routes>
  );
};
