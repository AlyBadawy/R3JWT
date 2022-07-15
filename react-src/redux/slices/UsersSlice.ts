import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface AuthState {
  user_id?: string;
  jwt_token?: string;
  refresh_token?: string;
  expire_at?: number;
  isLoggedIn?: boolean;
}

const initialState: AuthState = {
  user_id: undefined,
  jwt_token: undefined,
  refresh_token: undefined,
  expire_at: undefined,
  isLoggedIn: false,
};

const authSlice = createSlice({
  name: 'authSlice',
  initialState,
  reducers: {
    setCredentials: (state, action: PayloadAction<AuthState>) => {
      state = action.payload;
    },
    logOut: (state, _action: PayloadAction<void>) => {
      state.user_id = undefined;
      state.jwt_token = undefined;
      state.refresh_token = undefined;
      state.expire_at = undefined;
    },
  },
});

export const { setCredentials, logOut } = authSlice.actions;
export default authSlice.reducer;
