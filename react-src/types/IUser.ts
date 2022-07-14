export interface IUser {
  _id: string;
  username: string;
  email: string;
  admin?: boolean;
  createdAt: Date;
  updatedAt: Date;
}
