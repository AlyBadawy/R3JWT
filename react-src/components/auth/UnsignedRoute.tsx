import { useLocation, Navigate, Outlet } from 'react-router-dom';
import { useAppSelector } from '../../redux/hooks';
import * as React from 'react';

export const UnsignedRoute = () => {
  const isLoggedIn = useAppSelector((state) => state.auth.isLoggedIn);
  const location = useLocation();
  return isLoggedIn ? (
    <Navigate to="/dashboard" state={{ from: location }} replace />
  ) : (
    <Outlet />
  );
};
