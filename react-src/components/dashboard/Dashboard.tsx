import { useAppSelector } from '../../redux/hooks';
// import { Link } from 'react-router-dom';

import React from 'react';

export const Dashboard = () => {
  const userId = useAppSelector((state) => state.auth.user_id);
  return <div>Welcome {userId}! </div>;
};
