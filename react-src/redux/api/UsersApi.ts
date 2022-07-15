import { appApi } from './appApi';

export const UsersApi = appApi.injectEndpoints({
  endpoints: (builder) => ({
    listUsers: builder.query({
      query: () => '/users',
      keepUnusedDataFor: 60,
    }),
  }),
});

export const { useListUsersQuery } = UsersApi;
